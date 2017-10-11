%COMPUTE_FIX_DT dispersion-based fixation algorithm
%   FIX = COMPUTE_FIX_DT(T, X, DISP_THRESH, T_THRESH) is a
%   dispersion-based algorithm.  T is time, X is space data,
%   DISP_THRESH is the dispersion threshold, and T_THRESH is the
%   minimum time duration of a fixation.
%
%   the dispersion measure formula is:
%      D = [max(y) - min(y)] + [max(x) - min(x)] 
%   
%   where x and y are the points being considered in the current
%   fixation. This is the algorithm described in the paper
%   "Identifying Fixations and Saccades in Eye-Tracking Protocols".
%   Its a pretty sorry paper but has its menial uses.  it was
%   published in ETRA 2000, so find it there (if you're in UR cs,
%   use the ACM digital library)
%
%   WARNING! there might be a bug in this code, or so I vaguely
%   remember... it was never used enough to warrant finding it

% $Id: compute_fix_dt.m,v 1.2 2001/08/16 19:04:51 pskirko Exp $
% pskirko 6.27.01

function fix = compute_fix_dt(t, x, disp_thresh, t_thresh) 

fix = []; idx = 1;

n = length(t);

window = []; prev_window = []; D = []; t_dur = [];
t_window = []; prev_t_window = []; prev_D = []; prev_t_dur = [];
curr_idx = 1;

% assume data 2D, make general later

while(curr_idx < n+1)
  curr_x = x(curr_idx, :);
  curr_t = t(curr_idx);
  
  window = [window; curr_x];
  t_window = [t_window curr_t]; 
  t_dur = max(t_window) - min(t_window);
  
  D = (max(window(:,1)) - min(window(:,1))) + (max(window (:,2)) - ...
					       min(window(:,2)));
  
  if(D > disp_thresh) % erase window, move to right
    if(~isempty(prev_window)) %check previous fixation
      if(prev_D < disp_thresh & prev_t_dur > t_thresh) %keep fixation
	fix(idx,:) = [min(t_window) max(t_window)];
	idx = idx + 1;
      end
    end
    %reset state
    window = []; prev_window = []; D = []; t_dur = [];
    t_window = []; prev_t_window = []; prev_D = []; prev_t_dur = [];    
    curr_idx = curr_idx + 1;
  else %increase window
    curr_idx = curr_idx + 1;
    prev_window = window;
    prev_t_window = t_window;
    prev_D = D;
    prev_t_dur = t_dur;
  end
end