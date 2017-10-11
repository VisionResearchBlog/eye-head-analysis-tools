function [head_move, smooth_head_vel, head_segment] = head_analysis(heading, time, ...
						  segment)

  thresh = 5;
  t_del = time(2:end) - time(1:end-1); 
  h_del = heading(2:end) - heading(1:end-1);
  head_vel = h_del./t_del;
  smooth_head_vel = smooth(head_vel, 5);
  
%  figure(4)   
%  plot(time(2:end), head_vel); 
%  hold on 
%  plot(time(2:end), smooth_head_vel, 'r')
%  hold on

  vel_cond = (smooth_head_vel < -thresh)|(smooth_head_vel > thresh);
  
  
%  figure(5)
%  plot(time(2:end), vel_cond*20)
%  hold on
%  plot(time, heading, 'k')
  
  
  %spin though the vel_cond to find continuous sections which we
  %will identify as head movements
  
  index = 1; move = 0; 
  
  for i = 1:size(vel_cond, 1)
    
    if(vel_cond(i) == 1)&(move == 0)
      move = 1;
      head_move(index,1) = i;
    elseif(vel_cond(i) == 0)&(move == 1)
      move = 0;
      head_move(index,2) = i;
      index = index + 1;
    end
  end
  
  %remove short head movements
  %head_move = [ head_move(1:end-1,:) ( time(head_move(1:end-1,2)) - ...
  %		         time(head_move(1:end-1,1)) ) zeros(size(head_move,1)-1,1) ];
    
  %keyboard
  
  time_delta = time(head_move(1:end-1,2)) - time(head_move(1:end-1,1));
  time_delta(end+1) = 0;
  head_move = [ head_move(:,1:2)  time_delta zeros(size(head_move,1),1) head_move(:,1:2) ];
  t_cond = head_move(:,3) > 0.3; %greater than 300ms
  head_move = head_move(find(t_cond), :);
 
  %label fixations according to direction 
  for i = 1:size(head_move,1)
    
    direction = 0;
    
    for j = head_move(i,1):head_move(i,2)   
    direction = direction + smooth_head_vel(j);
    end
    
    if (direction > 0)
      head_move(i,4) = 2;
    else if (direction < 0)
	head_move(i,4) = 3;	
    end
  end
  end
 
  %find frames corresponding to each model number
  

  for i = 1:5,
    
    seg_cond = ((segment(i,1) <= head_move(:, 1))&...
		(segment(i,2) > head_move(:, 1)));

    head_segment(i,1) = min(find(seg_cond));
    head_segment(i,2) = max(find(seg_cond));
    
  end
  
    %convert to seconds
    head_move = [time(head_move(:, 1)) time(head_move(:, 2)) head_move(:,3:6)];
   
    for i=1:size(head_move,1)
        head_move(i, 7) = heading(head_move(i, 5)); %initial heading    
        head_move(i, 8) = heading(head_move(i, 6)); %ending heading
        head_move(i, 9) = max(abs(smooth_head_vel(head_move(i,5):head_move(i,6))));%maxVel
    end
 
return














