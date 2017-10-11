% COMPUTE_FIX_VT fixation finder that uses velocity threshold (VT)
%   FIX = COMPUTE_FIX_VT(T, VEL, VEL_THRESH, T_THRESH) returns the
%   fixations associated with (T, VEL) in FIX
%
%   T is time vector, VEL is velocity vector, VEL_THRESH is the
%   minimum velocity required for fixation, and T_THRESH is the
%   minimum time required for fixation
%
%   NOTE: clumping or track loss is not handled here. for clumping,
%   see COMPUTE_CLUMPED_FIX

% $Id: compute_fix_vt.m,v 1.4 2004/04/20 20:44:25 sullivan Exp $
% pskirko 7.23.01

function [fix, fix_frames] = compute_fix_vt(t, vel, vel_thresh, t_thresh)

%vel_thresh = vel_thresh - 5;

fix = []; idx = 1;  win_radius = 5 ; win_feature = 0;

n = length(vel); %feature = zeros(n,1);
t_start = -1;
for i=1:n
    v = vel(i);
    t_ = t(i);

    %change threshold depending on feature
    %if (i > win_radius) & (i <= n-win_radius)

    %temp = vel( i-win_radius : i+win_radius , 1);
    %feature = mean( temp(:) )
    %vel_thresh = 45 + feature/3.4189e+003;
    %vel_thresh = 44.4 + 0.9259 * std( temp(:) );%44.4 + 0.9259 * std( temp(:) )
    %vel_thresh = 45 + mean( temp(:) )/2.3;%vel_thresh = 45 + feature/1.2;%with radius 7

    %end
    
    %i;
    %vel_thresh;

    if(v < vel_thresh) %begin new fixations
        if(t_start == -1) %start fixation
            t_start = t_;
            frame_i = i;
        end
    else %end old fixations
        if(t_start ~= -1) %end fixation
            %fix = [fix; t_start t_];
            if(t_ - t_start > t_thresh)
                frame_f = i-1;
                fix(idx, :) = [t_start t(i-1)];
                fix_frames(idx, :) = [frame_i frame_f];
                idx = idx + 1;
            end
            t_start = -1;
        end
    end
    
    %just in case EOF, make sure we have last fixation begin & end
    if( (i==n)&& (t_start~=-1) )
        fix(idx, :) = [t_start t_];
        fix_frames(idx, :) = [frame_i i];
    end
    
end

%keyboard

return
