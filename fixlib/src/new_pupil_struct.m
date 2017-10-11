%NEW_PUPIL_STRUCT initialize pupil struct
%   PS = NEW_PUPIL_STRUCT initializes the pupil struct.
%   See the .m for the parameters needed in the function call.
%
%   A pupil struct represents pupil information in a pupilplot used 
%   by eyeviz.
%
%   Note: when I say pupil struct I sometimes mean "the plot 
%   corresponding to data in a pupil struct".  Beware.
%
%   Fields:
%
%          - color
%               type: Matlab ColorSpec (I think)
%               its color
%          - pupil
%               type: column vector
%               the pupil data. this vector should be the same 
%               length as the time vector used "elsewhere".  right
%               now eyeviz expects all the plots are "synchronized" 
%               according to the same time scale.  To make it
%               simple, just pass in the pupil data read from the
%               file, or some variant of equal length, e.g.
%               one(length(asl_pupil,1)).*mean(asl_pupil)
%          - t
%               type: column vector
%               the time values i described above. 

% $Id: new_pupil_struct.m,v 1.2 2001/08/15 19:26:17 pskirko Exp $
% pskirko 8.15.01

function pupil_struct = new_pupil_struct(t, pupil, color)

pupil_struct = struct('t', t, 'pupil', pupil, 'color', color);