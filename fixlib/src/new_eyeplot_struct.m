%NEW_EYEPLOT_STRUCT initialize eyeplot struct
%   ES = NEW_EYEPLOT_STRUCT initializes the eyeplot struct.
%   See the .m for the parameters needed in the function call.
%
%   A eyeplot is used by eyeviz to represent spatial locations at a 
%   given point in time.  The whole point of eyeviz is to "step
%   through time" and see how the gaze changes, and also get a
%   spatial sense for fixations, etc.  The eyeplot currently used
%   in eyeviz is the 2D field of view, the gaze and fixations are 
%   represented at each point in time.
%
%   Fields:
%
%          - axes_struct
%               type: single struct
%               see NEW_AXES_STRUCT
%          - point_structs
%               type: doubly-nested cell array vector (e.g, {{fs1, fs2}})
%               list of point structs
%               see NEW_POINT_STRUCT

% $Id: new_eyeplot_struct.m,v 1.2 2001/08/15 19:26:11 pskirko Exp $
% pskirko 8.15.01

function eyeplot_struct = new_eyeplot_struct(point_structs, axes_params)

eyeplot_struct = struct('point_structs', point_structs, 'axes_params', ...
                         axes_params);

% ugh, should change axes_params to axes_struct