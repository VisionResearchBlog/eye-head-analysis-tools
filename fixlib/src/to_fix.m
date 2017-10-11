function [fix, fix_frames] = to_fix(t, vel , thresh, t_thresh) 


fix         = [];
idx         = 1;


n           = length(vel); %feature = zeros(n,1);

t_start = -1;

for i=1:n
    v = vel(i);
    t_ = t(i);
    
    if(v < thresh) %begin new fixations
       if(t_start == -1) %start fixation
          t_start = t_;   
	  frame_i = i;
       end        
    else %end old fixations
       if(t_start ~= -1) %end fixation
          %fix = [fix; t_start t_];
          if(t_ - t_start > t_thresh)  
	          frame_f = i;
                  fix(idx, :) = [t_start t_];
		  fix_frames(idx, :) = [frame_i frame_f];
	          idx = idx + 1;
          end             
          t_start = -1; 
       end
    end
end
