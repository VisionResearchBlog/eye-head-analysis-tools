%  FIX = FIX_FINDER_HMM is a fixation finder using a two state HMM
%  with a single Gaussian distribution as a model for the velocities
%  and also corrects for track loss
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
%     see the function COMPUTE_FIX_CHMM_211 for more details
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

% fix_finder_hmm.m June 2002. constantin rothkopf
% $Id: fix_finder_hmm.m,v 1.2 2003/01/27 17:31:44 sullivan Exp $
% pskirko 8.16.01

function [fix, fix_frames] = fix_finder_hmm(t, x, raw_asl, ...
			     clump_space_thresh, ...
			     clump_t_thresh, ...
			     tl_pupil_thresh, ...
			     vt_t_thresh, reestimate, exp_type)

vel = compute_vel( t, x );
vel = vel.*1000; % deg/ms -> deg/s

% handle track loss
[vel,state] = correct_vel_for_track_loss(  t, vel, raw_asl, tl_pupil_thresh  );

%save piversion vel state

if(~reestimate)
%COMPUTE THE FIXATIONS
%#######################################################################################
%CASE 1:    2 states        1 single gaussian       1 input value       OK  OK  OK  OK

if(strcmp(exp_type, 'bfx'))
A              = [     0.9735            0.0265    ;    0.1002         0.8998 ];%bfx
myu            = [    13.5831    ;      76.2922    ];%bfx
sigma          = [    19.0965    ;     155.6638    ];%bfx

elseif(strcmp(exp_type, 'cba'))
A              = [     0.9721             0.0279    ;    0.2305         0.7695 ];%cba two frame averaging%
myu            = [    32.5157    ;      496.4563    ];%cba
sigma          = [    16.3946    ;      786.7       ];%cba

elseif((strcmp(exp_type, 'bricks'))|(strcmp(exp_type, 'baufix')))
A              = [     0.9644           0.0356    ;    0.3463         0.6537 ];%cba no smoothing
myu            = [    32.0181  ;      574.3510    ];%cba
sigma          = [    19.7     ;     1060         ];%cba
end
 
%if there are problems, the fix_finder_chmm_211_reestimate function
%should be fed by some estimates obtained by EM or some other
%method

elseif(reestimate)
[ A , myu , sigma ] = fix_finder_chmm_211_reestimate( vel )
end


[fix, fix_frames] = compute_fix_chmm_211( t , vel , 0 , 0 , A , myu , sigma );



% clump fixations
if(~isempty(clump_space_thresh) & ~isempty(clump_t_thresh))
  [fix, fix_frames] = compute_clumped_fix(fix, fix_frames, t, x, ...
			    clump_space_thresh, clump_t_thresh);
end

% remove short fixations

[fix, fix_frames] = remove_short_fixations(fix, fix_frames, vt_t_thresh, ...
					  t);

% A
% myu
% sigma


%find average x,y position and place in fix_frames
fix_frames = average_pos(fix_frames, raw_asl);
