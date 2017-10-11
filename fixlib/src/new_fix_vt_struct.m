%NEW_FIX_VT_STRUCT initialize vt fix struct
%   FS = NEW_FIX_VT_STRUCT initializes the vt struct.
%   
%   This struct encapsulates parameters for running the "fixation
%   finder" (see FIX_FINDER_VT).  It is used by some high-level
%   scripts, so you need to know what the parameters do:
%  
%          - clump_space_thresh            
%               type: scalar
%               used for clumping (see FIX_FINDER_VT)
%          - clump_t_thresh
%               type: scalar
%               used for clumping (see FIX_FINDER_VT)
%          - editable 
%               type: 0 or 1
%               featured offered by eyeviz. if enabled (set to 1),
%               this fixation result can be edited, see eyeviz
%               documentation
%          - eye_data_type 
%               type: 'asl', 'eih', or 'gaze'
%               default: 'gaze'
%               specifies what kind of data is used to calculate 
%               velocities, centroids, etc. 'asl' is asl pixel
%               data. 'eih' is asl pixel data converted to visual
%               angle degrees. 'gaze' is eih plus head angles.
%          - name 
%               type: text
%               can't remember what this does, probably vestigial
%          - output_file
%               type: filename
%               if you enable editing (editable=1), you can
%               use this to identify an output file where data is
%               saved in the .fix format
%          - t_thresh
%               type: scalar
%               used to compute fixations (see FIX_FINDER_VT)
%          - track_loss_pupil_thresh
%               type: scalar
%               used to identify track loss (see FIX_FINDER_VT)
%          - type 
%               always: 'vt'
%          - vel_thresh
%               type: scalar
%               used to compute fixations (see FIX_FINDER_VT)

% $Id: new_fix_vt_struct.m,v 1.5 2001/08/16 19:05:28 pskirko Exp $
% pskirko 7.5.01

function fs = new_fix_vt_struct

fs = struct('clump_space_thresh', [], ...
	    'clump_t_thresh', [], ...
	    'editable', 0, ...
	    'eye_data_type', 'gaze', ...
	    'name', [], ...
	    'output_file', [], ...
	    't_thresh', [], ...
	    'track_loss_pupil_thresh', [], ...
	    'type', 'vt', ...
	    'vel_thresh', []);

