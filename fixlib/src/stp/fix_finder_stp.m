%0FIX_FINDER_VT comprehensive fixation finder
%  [fix, fix_frames] = FIX_FINDER_VT is a fixation finder built around the velocity
%  threshold fixation algorithm, and also corrects for track loss
%  and performs clumping
%
%  This is the process:
%
%  1) identify track losses
%     uses the inputs PUPIL and TL_PUPIL_THRESH to correct for
%     track losses.  see the function CORRECT_VEL_FOR_TRACK_LOSS
%     for more details.  if TL_PUPIL_THRESH is [], this step is
%     skipped.
%
%  2) compute fixations
%     uses the inputs VT_VEL_THRESH to compute 
%     fixations.  see the function COMPUTE_FIX_VT for more details
%     (this function will be passed in 0 for its t_thresh b/c
%     removing short fixations will be performed after clumping).
%     both inputs must be specified, there are no defaults.
%
%  3) clump
%     uses the inputs CLUMP_SPACE_THRESH and CLUMP_T_THRESH to perform
%     clumping. see the function COMPUTE_CLUMPED_FIX for more details.
%     if CLUMP_SPACE_THRESH or CLUMP_T_THRESH are [], this step is
%     skipped
%
%  4) remove short fixations
%     uses the input VT_T_THRESH to remove short fixations. see the 
%     function REMOVE_SHORT_FIXATIONS for more details. this
%     parameter must be specified

% $Id: fix_finder_vt.m,v 1.6 2003/01/27 17:31:44 sullivan Exp $
% pskirko 8.16.01

function [fix, fix_frames, vel] = fix_finder_stp(t, x, raw_asl, ...
			     clump_space_thresh, ...
			     clump_t_thresh, ...
			     tl_pupil_thresh, ...
			     vt_t_thresh, ...
			     vt_vel_thresh)

vel = compute_vel(t, x);
vel = vel.*1000; % deg/ms -> deg/s

% handle track loss
[vel,state] = correct_vel_for_track_loss(t,vel, raw_asl, tl_pupil_thresh);
% compute fix

[fix, fix_frames] = compute_fix_vt(t, vel, vt_vel_thresh, 0);


% clump fixations

if(~isempty(clump_space_thresh) & ~isempty(clump_t_thresh))
  [fix, fix_frames] = compute_clumped_fix(fix, fix_frames, t, x, ...
			    clump_space_thresh, clump_t_thresh);
end


% remove short fixations

[fix, fix_frames] = remove_short_fixations(fix, fix_frames, vt_t_thresh, t);


%find average x,y position and place in fix_frames

fix_frames = average_pos(fix_frames, raw_asl);

return

