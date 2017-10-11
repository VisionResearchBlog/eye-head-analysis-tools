%NEW_PUPILPLOT_STRUCT initialize pupilplot struct
%   TS = NEW_PUPILPLOT_STRUCT initializes the pupilplot struct.
%   See the .m for the parameters needed in the function call.
%
%   A pupilplot is used by eyeviz to represent pupil data. This
%   struct encapsulates the axes limits along with one or more
%   pupil structs (see NEW_PUPIL_STRUCT). The most common pupil
%   struct is the actual pupil diameter, but it is also helpful
%   to pass in a "bogus pupil dataset"--- same length as pupil
%   data, but each element is just the max value from the pupil
%   data. This is helpful b/c its easier to see how the diameter
%   changes, esp. during track loss.
%
%   Pupils are drawn in the order they are passed in, either
%   back-to-front or front-to-back, I can't remember.  
%
%   Fields:
%
%          - axes_struct
%               type: single struct
%               see NEW_AXES_STRUCT
%          - pupil_structs
%               type: doubly-nested cell array vector (e.g, {{fs1, fs2}})
%               see NEW_PUPIL_STRUCT

% $Id: new_pupilplot_struct.m,v 1.2 2001/08/15 19:26:19 pskirko Exp $
% pskirko 8.15.01

function pupilplot_struct = new_pupilplot_struct(pupil_structs, axes_params)

pupilplot_struct = struct('pupil_structs', pupil_structs, 'axes_params', ...
			  axes_params);
