% $Id: compute_fix_adaptive_at.m,v 1.1 2003/01/20 19:40:42 sullivan Exp $
% pskirko 7.23.01

function [fix, fix_frames] = compute_fix_adaptive_at(  t, vel, acc, t_thresh  ) 



fix = []; idx = 1;  win_radius = 3 ; win_feature = 0; 

n = length(vel); %feature = zeros(n,1);

t_start = -1;
%vel = acc;
A = 1000;
B = -A;
i=1;
%for i=1:n
while i<=n-9;
    %v = vel(i);
    t_ = t(i);
    
    %change threshold depending on feature
   if (i > win_radius) & (i <= n-win_radius)
       feature  = sum(    (  acc( i-3:i+3 , 1 ).^2  )  )  / 6.0;
       B        = 55 + sqrt( feature );
       A        = -B;
   end
   
   if( acc( i,1 ) > A ) %begin new fixations
       
       if(t_start == -1) %start fixation
          t_start = t_;   
	  frame_i = i;
       end   
       
   else
       
       hit = 0;
       for j=i+1:i+9%scan for opposite peak
           if acc( j,1 ) > B
               hit = 1;
               mem = j;
           end
       end
       if(t_start ~= -1) & (hit == 1)%end fixation
              frame_f = i;
              fix(idx, :) = [t_start t_];    
	      fix_frames(idx, :) = [frame_i frame_f];         
	      idx = idx + 1;
            
          t_start = -1;
          i=mem;
       end
   end
   i=i+1;
end    



%%%%%%%%%%%%    
%     if( abs(v) < B) %begin new fixations
%        if(t_start == -1) %start fixation
%           t_start = t_; 
%        end        
%     else %end old fixations
%        if(t_start ~= -1) %end fixation
%           %fix = [fix; t_start t_];
%           if(t_ - t_start > t_thresh)
%               fix(idx, :) = [t_start t_];          
% 	          idx = idx + 1;
%           end             
%           t_start = -1; 
%        end
%     end
% end
