function [headp_x, headp_y, headp_z] = bfx_head2perf(head_x, head_y, head_z)

% translation from baufix data file format to performer coordinate system
% and units (mm)
%
% 1000*x_datafile = - y_baufix_world
% 1000*y_datafile = - z_baufix_world
% 1000*z_datafile =   x_baufix_world

headp_x =  1000.*head_z;
headp_y = -1000.*head_x;
headp_z = -1000.*head_y;
