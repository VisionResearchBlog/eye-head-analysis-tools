% COMPUTE_FIX_A_VT fixation finder that uses adaptive velocity threshold
%   FIX = COMPUTE_FIX_A_VT(T, VEL) returns the
%   fixations associated with (T, VEL) in FIX
%   This is based on the experience with the data from the 'old baufix'
%   experiment. adaptive filtering is adequate for signal dependent noise
%   and the threshold is also adapted depending on the noise level
%
% Constantin Rothkopf July 2002
% $Id: compute_fix_a_vt_001.m,v 1.1 2003/01/20 19:40:40 sullivan Exp $
% pskirko 7.23.01

function [fix, fix_frames, avel_thresh] = ...
    compute_fix_a_vt_001(   t , vel, vel_filtered, t_thresh, vel_thresh,...
    win_radius, m, b )

%keyboard

%win_radius  = 9;%size of the time interval over which mean velocity is calculated
t_start     = -1;
fix         = [];
idx         = 1;
n           = length(vel);


%cycle once through entire sequence to get
%equation for linear fit for threshold function
%try to eliminate artifact velocities

%remove velocities above 500 deg/sec (artifacts)
vel_small   = vel_filtered;

%init empty vector for threshold calculation
%give value of average deg/sec just to find min,max
nn          = length( vel_small );
thresh_v    = vel_small;
thresh_v    = ( (max(vel_small)-min(vel_small))/2) + 0.*thresh_v;

%go through sequence and find mean for each window
for i = 1+win_radius : nn-win_radius
    temp        = vel_small( i-win_radius : i+win_radius );
    feature     = mean( temp(:) );
    thresh_v(i) = feature;
end

%that's what we wanted to calculate
min_feature = min(thresh_v);
max_feature = max(thresh_v);

%this is just engineering
%linear fit between min and max values of feature
%which is range where the threshold is adaptive
if(isempty(m))
    m = (  180 - 60  )/( max_feature - min_feature );%200 - 60
end

if(isempty(b))
    b = vel_thresh - m*min_feature;%70
end

avel_thresh = zeros(length(vel),1)+vel_thresh;

for i=1:n
    v = vel(i);
    t_ = t(i);

    %change threshold depending on feature
    if (i > win_radius) & (i <= n-win_radius)
        temp        = vel( i-win_radius : i+win_radius , 1);
        feature     = mean( temp(:) );

        avel_thresh(i)= feature*m + b;
    end

    %the old code for the fixations...
    if(v < avel_thresh(i)) %begin new fixations
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

return


