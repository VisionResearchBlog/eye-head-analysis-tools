%NEW_FIX_DT_STRUCT initialize dt fix struct
%   FS = NEW_FIX_DT_STRUCT initializes the dt struct.
%   
%   This struct encapsulates parameters for running
%   COMPUTE_FIX_DT, a dispersion-based fixation algorithm.  This
%   hasn't been used much (notice there is no FIX_FINDER_DT file),
%   so support for this approach is pretty low. This should work in 
%   both the baufix and cba code, but in any case beware.
%  
%          - disp_thresh
%               type: scalar
%               used to compute fixations (see FIX_FINDER_DT)
%          - eye_data_type 
%               type: 'asl', 'eih', or 'gaze'
%               default: 'gaze'
%               specifies what kind of data is used to calculate 
%               velocities, centroids, etc. 'asl' is asl pixel
%               data. 'eih' is asl pixel data converted to visual
%               angle degrees. 'gaze' is eih plus head angles.
%          - t_thresh
%               type: scalar
%               used to compute fixations (see FIX_FINDER_DT)
%          - type 
%               always: 'dt'

% $Id: new_fix_dt_struct.m,v 1.3 2001/08/16 19:05:22 pskirko Exp $
% pskirko 7.5.01

function fs = new_fix_dt_struct(disp_thresh, t_thresh)

fs = struct('type', 'dt', 'disp_thresh', disp_thresh, 't_thresh', ...
	    t_thresh, 'eye_data_type', 'gaze');