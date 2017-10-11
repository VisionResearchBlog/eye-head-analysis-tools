%COMPUTE_CLUMPED_FIX clumps fixations
%   [C_FIX, C_FIX_FRAMES] = COMPUTE_CLUMPED_FIX(FIX_IN, T, X, T_THRESH, SPACE_THRESH)
%   returns in FIX the fixations clumped from FIX_IN according to
%   the following guide:
%
%   1) for each fixation in FIX_IN, compute its centroid via
%      COMPUTE_CENTROID
%
%   2) for each consecutive fixation, compute the distance
%      btw. centroids as well as the time separation.  If these values
%      fall above SPACE_THRESH and T_THRESH, respectively, mark this
%      pair is requiring clumping
%
%   3) cycle through all the fixations a second time: collapse all
%      contiguous pairs that have been marked as clumpable; return
%      these in FIX

% $Id: compute_clumped_fix.m,v 1.3 2003/01/20 19:35:07 sullivan Exp $
% pskirko 8.16.01

function [c_fix, c_fix_frames] =  ...
	compute_clumped_fix(fix, fix_frames, t, x, t_thresh, space_thresh)

% clumps fixations according to time and space params

n = size(fix, 1);

% # gaps = # fixes. last gap ignored
gaps = ones(n, 1);

% compute centroids of fixations
[centroid, centroid_frames] = compute_centroid(fix, fix_frames, t, x);

for i=1:n-1 % for each consecutive pair of fixations
    fix1 = fix(i,:); c1 = centroid(i,:);
    fix2 = fix(i+1,:); c2 = centroid(i+1,:);
    
    fix3 = t(fix_frames(i,:)); c3 = centroid(i,:);
    fix4 = t(fix_frames(i+1,:)); c4 = centroid(i+1,:);
    
    % checkno space
    if(norm(c1 - c2) < space_thresh) % qualify
        % check time
        if(fix2(1) - fix1(2) < t_thresh) % clump
            gaps(i) = 0;
        end
    end
    
    % check space
%     if(norm(c3 - c4) < space_thresh) % qualify
%         % check time
%         if(fix4(1) - fix3(2) < t_thresh) % clump
%             gaps(i) = 0;
%         end
%     end
    
end

% now actually perform clumping

fix_start = [];

c_fix = []; idx = 1;

for i=1:n
    fix1 = fix(i,:); gap1 = gaps(i);
    fix2 = fix_frames(i,:); gap2 = gaps(i);
    %if(i == n) break; end
    
    if(gap1 == 0) % clump consec.fixations
        if(isempty(fix_start)) % new fixation
            fix_start = fix1(1); frame_i = fix2(1);
        else
            
        end
    else % start new fix
        if(isempty(fix_start)) %keep existing fixation
            c_fix(idx,:) = fix1;
            c_fix_frames(idx,:) = fix2;
            idx = idx + 1;
        else % cap current fixation
            c_fix(idx,:) = [ fix_start, fix1(2) ];
            c_fix_frames(idx,:) = [ frame_i, fix2(2) ];
            idx = idx + 1;
            fix_start = [];
            frame_i = [];
        end
    end
end

if(~isempty(fix_start)) % get that last fixation
    c_fix(idx, :) = [ fix_start, fix1(2) ];
    c_fix_frames(idx, :) = [ frame_i, fix2(2) ];
    
end

%keyboard
return