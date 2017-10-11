%     uses the inputs CLUMP_SPACE_THRESH and CLUMP_T_THRESH to perform
%     clumping. see the function COMPUTE_CLUMPED_FIX for more details.
%     if CLUMP_SPACE_THRESH or CLUMP_T_THRESH are [], this step is
%     skipped
%
%  4) remove short fixations
%     uses the input VT_T_THRESH to remove short fixations. see the 
%     function REMOVE_SHORT_FIXATIONS for more details. this
%     parameter must be specified

% $Id: fix_finder_adaptive_at.m,v July 2002 

function [fix, fix_frames] = fix_finder_adaptive_at(t, x, raw_asl, ...
			     clump_space_thresh, ...
			     clump_t_thresh, ...
			     tl_pupil_thresh, ...
			     vt_t_thresh  )

vel = compute_vel(t, x);
vel = vel.*1000; % deg/ms -> deg/s

% handle track loss
[vel,state] = correct_vel_for_track_loss(  t, vel, raw_asl, tl_pupil_thresh  );
%save piversion vel state


%$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filter
vel     = filter_average( vel , 2 );
%$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kernel  = [ -3 ; -2 ; -1 ; 1 ; 2 ; 3 ];
acc     = conv( vel , kernel );
acc     = acc( 2 : 1+length( vel ) );

% compute fix
[fix, fix_frames] = compute_fix_adaptive_at( t, vel, acc, vt_t_thresh );


% clump fixations
if(~isempty(clump_space_thresh) & ~isempty(clump_t_thresh))
  [fix, fix_frames] = compute_clumped_fix(fix, fix_frames, t, x, ...
			    clump_space_thresh, clump_t_thresh);
end

% remove short fixations
[fix, fix_frames] = remove_short_fixations(fix, fix_frames, vt_t_thresh, ...
					   t);


%find average x,y position and place in fix_frames
fix_frames = average_pos(fix_frames, raw_asl);
