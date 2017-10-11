%NEW_POINT_STRUCT initialize point struct
%   PS = NEW_POINT_STRUCT initializes the point struct.
%   See the .m for the parameters needed in the function call.
%
%   A point struct is currently the one way of representing data 
%   in an eyeplot (see NEW_EYEPLOT_STRUCT). For each point in time,
%   the spatial dimensions are specified.  Gaze is a good example
%   of a point struct with 2 spatial dimensions.
%
%   Note: when I say point struct I sometimes mean "the plot 
%   corresponding to data in a point struct".  Beware.
%
%   Fields:
%
%          - legend
%               type: text
%               legend used in plots
%          - linespec
%               type: Matlab linespec
%               line spec
%          - t
%               type: column vector
%               time values
%          - trail
%               type: 0 or 1
%               default:
%               eyeviz can plot point structs with a trail. useful
%               for visualizing eye data. try it. 1 to enable.
%          - x
%               type: n x ndim, 
%               spatial data. DO NOT include time as the first
%               dimension, like you have to do for a plot struct. shucks.

% $Id: new_point_struct.m,v 1.2 2001/08/15 19:26:16 pskirko Exp $
% pskirko 8.15.01

function point_struct = new_point_struct(t, x, linespec, legend)

if (nargin == 0) t = []; x = []; linespec = []; legend = []; end

point_struct = struct('t', t, 'x', x, 'linespec', linespec, 'legend', ...
		      legend, 'trail', 0);
