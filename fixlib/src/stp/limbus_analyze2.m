 function h = limbus_analyze(dataFile)

   close all;
   %load main variables
   
   v_thresh = 100;
   
   time = stp_load_raw(dataFile, 'time');
   heading = stp_load_raw(dataFile, 'head_h');  
   pitch = stp_load_raw(dataFile, 'head_p');   
   roll = stp_load_raw(dataFile, 'head_r');
   asl_h = stp_load_raw(dataFile, 'asl_h');
   asl_v = stp_load_raw(dataFile, 'asl_v');
   pupil = stp_load_raw(dataFile, 'asl_pupil');
   saccade = stp_load_raw(dataFile, 'Saccade');
   mark = stp_load_raw(dataFile, 'Mark');
   raw_volts =  stp_load_raw(dataFile, 'saccade_raw_data');
   %raw_vel =  stp_load_raw(dataFile, 'vel');
   
   
   %convert asl pix to degrees
   %eye_h = asl_h*0.16; eye_v = asl_v*0.16;
   [eye_h, eye_v] = bfx_pix2angle(asl_h, asl_v);
   %run fix_finder for vel and fixe
   [fix, fix_frames, eye_vel] = fix_finder_stp(time, [eye_h, eye_v], ...
					   [asl_h, asl_v, pupil], 0, 0, 0, ...
					   50, 65);

   %convert time and volts for limbus data
   time = time/1000 - time(1,1)/1000;
   limbus_data = stp_convert_saccade_raw_data(time, raw_volts);
   %convert limbus data to degrees and calculate velocity
   limbus_deg = limbus_data(:,3)*5.2; 
   
   
   deg_delta = limbus_deg(2:end)-limbus_deg(1:end-1);
   t_delta = limbus_data(2:end,2)-limbus_data(1:end-1,2);
      
   limbus_vel = deg_delta./t_delta;
 
   %convert limbus vel
   %raw_limbus_vel = stp_convert_saccade_raw_data(time, raw_vel);
   %
   %make the saccade judgement with the video based data
   eye_vel = [eye_vel zeros(size(eye_vel,1),1)];
   eve_vel(find(eye_vel(:,1) >= v_thresh),2) = 1;
   
   
   %for i = 1:size(eye_vel,1)
   %  if(eye_vel(i,1) > 100)
   %    eye_vel(i,2) = 1;
   %  end
   %end
   
   %spin through the marks - find closest saccade markers and
   %record the delta - are two loops needed?
   [B,I,J] = unique(mark);
   
   for i = 2:size(I,1)-1
     k1 = (I(i)+1); k2 = I(i+1);
     for j = k1:k2  
       if (saccade(j) == 1)
	 LimbusOnset(i,1) = j;
	 break
       else
	 LimbusOnset(i,1) = 0;
       end
     end
   end
   
   for i = 2:size(I,1)-1
     k1 = (I(i)+1); k2 = I(i+1);
     for j = k1:k2      
       if (eye_vel(j,2) == 1)
	 VidOnset(i,1) = j;
	 break
       else
	 VidOnset(i,1) = 0;
       end
     end
   end
   
 
[detect100, saccade2] = detect(5, 100, limbus_vel, limbus_data, ...
				     time);

% $$$ run our own version of saccade detection
% $$$ t_thresh = 5; vel_thresh = 50; idx = 0;
% $$$ cond1 = (abs(limbus_vel) >= vel_thresh);
% $$$ saccade2 = zeros(size(cond1,1),1);
% $$$ for i = 1:size(cond1,1)
% $$$   
% $$$   if((cond1(i) == 1)&(idx < t_thresh))
% $$$     idx = idx+1;
% $$$   elseif((cond1(i) == 1)&(idx >= t_thresh))
% $$$     saccade2(i,1) = 1;
% $$$     saccade2(i,2) = limbus_data(i,1);
% $$$     idx = idx+1;
% $$$   elseif(cond1(i) == 0)
% $$$     idx = 0;
% $$$   end
% $$$ end   

keyboard

%find saccade onsets for marks
for i = 2:size(I,1)-1
  k1 = (I(i)+1); k2 = I(i+1); 
  b_pass = (limbus_data(:,1) >= k1)&(limbus_data(:,1) <= k2);
  saccade_list = saccade2(find(b_pass),:);
  
  for j = 1:size(saccade_list,1)  
    if (saccade_list(j,1) == 1)
      NewLimbusOnset(i,1) = saccade_list(j,2);
      break
    else
      NewLimbusOnset(i,1) = 0;
    end
  end
end

keyboard


%Now plot the data        
figure(1)
plot(limbus_data(:,2), limbus_data(:,3), 'b'); hold on;
plot(time, saccade, 'r'); hold on;
plot(time, mark/20, 'k'); hold on;

figure(2)
plot(time, eye_vel, 'k'); hold on; 
plot(limbus_data(2:end,2), smooth(abs(limbus_vel), 5), 'b'); hold ...
    on;
% plot(raw_limbus_vel(:,2),raw_limbus_vel(:,3),'c'); hold on
plot(time, saccade*150, 'r'); hold on;
plot(limbus_data(:,2), saccade2(:,1)*100, 'm'); hold on;
plot(time, mark*20, 'k'); hold on; 
plot(time, eye_vel(:,2)*125, 'g'); hold on
plotedit


%a few results calculations
result = [unique(mark(2:end)) LimbusOnset VidOnset NewLimbusOnset];
lim = find((result(:,2)~= 0)&(result(:,3)~= 0));
latency = (time(result(lim,3)) - time(result(lim, 2)))*1000;  
cond2 = latency>0;
ave_latency = sum(latency(find(cond2)))/size(latency(find(cond2)), 1)
lim2 = find((result(:,3)~= 0)&(result(:,4)~= 0));
latency2 = (time(result(lim,3)) - time(result(lim, 4)))*1000;  
cond3 = latency2>0;
ave_latency2 = sum(latency2(find(cond3)))/size(latency2(find(cond3)), 1)

%find number of saccades identified
mark_size = (size(B,1)-2);
%limbus
limbus_pos = size(find(result(:,2)),1);
limbus_pos2 = size(find(result(:,4)),1);
%asl 
asl_pos = size(find(result(:,3)),1);


limbus_correct = (limbus_pos/mark_size)*100
asl_correct = (asl_pos/mark_size)*100
limbus_correct2 = (limbus_pos2/mark_size)*100
keyboard

return


function [detection, saccade] = detect(t_thresh, vel_thresh, limbus_vel, ...
				       limbus_data, t)
  
  idx = 0;
  cond1 = (abs(limbus_vel) >= vel_thresh);

  saccade = [ zeros(size(cond1,1),1) limbus_data(i, 1)];
  for i = 1:size(cond1,1)
    
    saccade(i,2) = limbus_data(i,1);
    
    if((cond1(i) == 1)&(idx < t_thresh))
      idx = idx+1;
    elseif((cond1(i) == 1)&(idx >= t_thresh))
      saccade(i,1) = 1;
      idx = idx+1;
    elseif(cond1(i) == 0)
      idx = 0;
    end
  end   

  saccade = [ zeros(size(cond1,1),1) limbus_data(i, 1)];
  
  %this bins things in frame time  
  for i = 2:size(t,1)
  
    cond2 = ((saccade(:,2) < t(i,1))&(saccade(:,2) > t(i-1,1)));
    k1 = max(find(cond2)); k2 = min(find(cond2));
    idx = 0;
    
    for j = k1:k2
      if(saccade(j,2) == 2)
	idx = idx + 1;
      end
    end
    
    if (idx >= (t_thresh/0.8))
      detection(i,1) = 1;
    else
      detection(i,1) = 0;
    end
    
  end
  
  return
  

