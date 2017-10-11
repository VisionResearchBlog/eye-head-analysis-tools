% D1: 1 D2: 2 H1: 3 H2: 4 V1: 5 V2: 6 

function h = limbus_analyze(dataFile)

  close all;
  %load main variables
  norm = 0;
  frame_delta = 0.0008; % the C version saccade detection relies on a static sample rate
  vel_thresh = 100; vel_thresh_vid = 100;
  t_thresh = 5;
  Volts2Deg = 5.2;
  
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
  
  
 p_range =  max(heading)-min(heading)
 t = time/1000; 
% t(end)
% keyboard
 
 p_vel = (heading(2:end)-heading(1:end-1))./(t(2:end)-t(1:end-1));
 mean_p_vel =  mean(abs(p_vel))
 max_vel = max(abs(p_vel)) %( plot(abs(p_vel))
 
%  keyboard
  %convert asl pix to degrees
  [eye_h, eye_v] = bfx_pix2angle(asl_h, asl_v);
  
  %run fix_finder for vel and fixs
  [fix, fix_frames, video_eye_vel] = fix_finder_stp(time, [eye_h, eye_v], ...
						    [asl_h, asl_v, pupil], 0, 0, 0, ...
						    50, 65);

  %convert time and volts for limbus data
  time = time/1000 - time(1,1)/1000;
  %limbus_data = [frames true_time volts]
  limbus_data = stp_convert_saccade_raw_data(time, raw_volts);
  %convert limbus data to degrees and calculate velocity
  limbus_deg = limbus_data(:,3)*Volts2Deg; 
  
  deg_delta = limbus_deg(2:end)-limbus_deg(1:end-1);
  %t_delta = limbus_data(2:end,2)-limbus_data(1:end-1,2);
  
  limbus_vel = deg_delta./frame_delta;
  limbus_vel = [0; limbus_vel;];
  
  %make the saccade judgement with the video based data
  video_eye_vel = [video_eye_vel zeros(size(video_eye_vel,1),1)];
  video_eye_vel(find(video_eye_vel(:,1) >= vel_thresh_vid),2) = 1;
  
  [saccade_new, sac_frame] = detect(t_thresh, vel_thresh,...
				    limbus_vel, limbus_data, ...
				    time);

  
  if(norm)
    %spin through the marks - find closest saccade markers and
    %record the delta - are two loops needed?
    [B,I,J] = unique(mark);
    NewLimbusOnset = []; sac_frame = [sac_frame; 0;]; 
    % keyboard
    LimbusOnset = onset(mark, time, saccade, 1);
    VidOnset = onset(mark, time, video_eye_vel, 2);
    FrameOnset =  onset(mark, time, sac_frame, 1);
    
    %for i = 2:size(I,1)-1 
    for i = 3:79
      k1 = (I(i)+1); k2 = I(i+1);
      
      b_pass = (limbus_data(:,1) >= k1)&(limbus_data(:,1) <= k2);
      [b_lo, tmp] = min(find(b_pass));
      [b_hi, tmp] = max(find(b_pass));
      %keyboard
      %find first saccade in k1:k2
      [Y, Idx] = max(saccade_new(b_lo:b_hi,1));
      if(Y>0)
	
	NewLimbusOnset(end+1,1) = Idx + b_lo; 
	NewLimbusOnset(end,2) = sum(saccade_new(b_lo:b_hi,1));
	NewLimbusOnset(end,3) = max(limbus_vel(b_lo:b_hi));
      else 
	NewLimbusOnset(end+1,1) = 0;
	NewLimbusOnset(end,2) = 0;
	NewLimbusOnset(end,3) = 0;
      end
    end
    
    clear Y Idx k1 k2 b_lo b_hi b_pass tmp;
  end
  
  
  %----------- Now plot the data -----------------------%      
  figure(1)
  %plot(time, mark*10, 'k'); hold on
  %plot raw data
  plot(time, video_eye_vel(:,1), 'k'); hold on; 
  plot(limbus_data(:,2), smooth(abs(limbus_vel), 1)*1.1, 'b'); hold on;
  %plot saccade detection
  plot(time, saccade*150, 'r'); hold on;
  plot(time, video_eye_vel(:,2)*125, 'g'); hold on
  plot(limbus_data(:,2), saccade_new(:,1)*100, 'm'); hold on;
  %plot(time(2:end), sac_frame*140, 'y')  
  %plot(time, sac_frame*140, 'y') 
  plotedit
  %------------------------------------------------------%
  
  if(norm)
    
    %a few results calculations
   % keyboard
    
    result = [(3:79)' LimbusOnset' VidOnset' ...
	      NewLimbusOnset(:,1) FrameOnset'];
    
    a1 = find(result(:,2) == 0); a2 = find(result(:,3) == 0); 
    a3 = find(result(:,4) == 0); a4 = find(result(:,5) == 0); 
    
    mark_size = 76; %actual saccade #
    limbus_pos = size(find(result(:,2)),1);
    limbus_pos2 = size(find(result(:,4)),1);
    limbus_pos3 = size(find(result(:,5)),1);
    asl_pos = size(find(result(:,3)),1);
    limbus_correct = (limbus_pos/mark_size)*100;
    asl_correct = (asl_pos/mark_size)*100;
    limbus_correct2 = (limbus_pos2/mark_size)*100;
    frame_correct = (limbus_pos3/mark_size)*100;
    
    result(a1,2) = 1; result(a2,3) = 1;
    result(a3,4) = 1; result(a4,5) = 1;
    clear a1 a2 a3 a4;
    
    result2 = [result(:,1) time(result(:,2)) time(result(:,3)) ...
	       limbus_data(result(:,4),2) time(result(:,5))];
    
    %column 3 contains 501 data
    lim1 = find((result(:,2)~= 0)&(result(:,3)~= 0));
    lim2 = find((result(:,3)~= 0)&(result(:,4) > 1));
    lim3 = find((result(:,3)~= 0)&(result(:,5)~= 0));
    latency1 = (time(result(lim1, 2)) - time(result(lim1,3)));  
    latency2 = (limbus_data(result(lim2, 4), 2) - time(result(lim2,3))); 
    latency3 = (time(result(lim3, 5)) - time(result(lim3,3)));
    Orig_210_Latency = ave_lat(latency1);
    In_frame_210_NewLatency = ave_lat(latency2);
    On_frame_210_NewLatency = ave_lat(latency3);
    clear lim1 lim2 lim3;
    
  
    reference = [ 1 1 5 5 1 1 3 3 1 1 5 5 1 1 3 3 0 ...
		  1 4 6 4 6 4 6 4 6 4 6 4 6 4 6 ...
		  4 6 4 6 4 6 1 1 4 2 4 2 4 2 4 2 ...
		  4 2 4 2 4 2 4 2 4 2 4 1 1 3 3 ...
		  5 3 3 5 3 3 5 3 3 5 3 3 5 5]';
    
    
    result_list = [ result2 reference];
    miss_list = hitORmiss(result_list)
  %  keyboard

    resArray = [ NewLimbusOnset(:,2:3) reference];
    
    %new test for duration and maxvel
    for i = 1:6
      resM(i) = mean(resArray(find(resArray(:,3)==i),2));
      resD(i) = mean(resArray(find(resArray(:,3)==i),1));
    end
    
  end
  
  
  %label onsets of saccades on frames for limbus
  for i = 2:size(sac_frame,1)
    if(sac_frame(i) == 1)&(sac_frame(i-1) == 0)
      sac_new((i),1) = 1;
    end
  end
  
  
  for i = 2:size(saccade,1)
    if(saccade(i) == 1)&(saccade(i-1) == 0)
      sac_orig((i),1) = 1;
    end
  end
  
%  keyboard
  
  saccades_210_orig = sum(sac_orig);
  saccades_210_frame = sum(sac_new);         
  saccades_501 = size(fix,1);
  
  
  %find false pos's for vor and sp
  
  false_pos = false_check(time(find(sac_new)), time(fix_frames(:,1)));
  false_pos2 = false_check(time(find(sac_orig)), time(fix_frames(:,1)));

  {dataFile saccades_210_orig sum(false_pos2)}
  
 % keyboard
  
 % q = [vel_thresh limbus_correct limbus_correct2 asl_correct frame_correct saccades_210_orig saccades_210_frame saccades_501 sum(false_pos)]

 % [resD resM]
 
  time_total= t(end)
   
 keyboard
  
  return
  
%-------------------------------------------------------------%

function [saccade, saccade_frame] = detect(t_thresh, vel_thresh, limbus_vel, ...
					   limbus_data, t)
  
  
  idx = 0;
  cond1 = (abs(limbus_vel) >= vel_thresh);
  
  saccade = [ zeros(size(cond1,1),1) limbus_data(:, 1)];
  
  for i = 1:size(cond1,1)
  
    if((cond1(i) == 1)&(idx < t_thresh))
      idx = idx+1;
    elseif((cond1(i) == 1)&(idx >= t_thresh))
      saccade(i,1) = 1;
      idx = idx+1;
    elseif(cond1(i) == 0)
      idx = 0;
    end
  end  

  for i = 1:size(unique(saccade(:,2)), 1)
       
    I = find(saccade(:,2) == i);
    frame_sum = sum(cond1(min(I):max(I),1));
    if (frame_sum >= t_thresh)
      saccade_frame(i,1) = 1;
    else
      saccade_frame(i,1) = 0;
    end
  end
  
  return

  
%----------------------------------------------------------

function onset_time = onset(mark, time, eye_data, index)
   [B,I,J] = unique(mark);
%  keyboard
   onset_time = [];
   
%   for i = 2:size(I,1)-1
    for i = 3:79       
     k1 = (I(i)+1); k2 = I(i+1);
     
     %find first saccade in k1:k2
     [Y, Idx] = max(eye_data(k1:k2,index));
     
   
     if(Y>0)
       onset_time(end+1) = Idx + k1;   
     else 
       onset_time(end+1) = 0;
     end
   end
   
     
   return


%-----------------------------------

function miss_list = hitORmiss(result_list)

  result_list( find(result_list(:, 4) < 1 ), 4) = 0;
  
  for j = 2:5
    
    for i = 1:6
      [I, J] = find((result_list(:,j) == 0)&(result_list(:,6) == i));
      miss_list(i, j-1) = sum(J);
    end
  end
  
  
  return

  
%----------------------------------------
function ave_latency = ave_lat(latency)

cond = (latency < 0)&(latency > -0.15);
ave_latency = sum(latency(find(cond)))/size(latency(find(cond)), 1)*1000;

return


%-----Corroborate pos's between signal sources
function false_pos = false_check(Limbus, Video)
    
  for i = 1:size(Limbus,1)
    
    MinDelta = min(abs(Video - Limbus(i)));
    
    if (MinDelta >= .5)
      false_pos(i,1) = 1;
    else
      false_pos(i,1) = 0;
    end
  end
 
  return
  
  
