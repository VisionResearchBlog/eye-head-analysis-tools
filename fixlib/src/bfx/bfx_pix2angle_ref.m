function [angle_h, angle_v] = bfx_pix2angle_ref(pix_h, pix_v)

% converts pixels to angles -- reference version, uses the
% "incorrect" method found in the baufix code

% convert asl pixels into vga pixels using the functions:
%   VGA_v = 488 -2*ASL_v
%   VGA_h = 41.8716 + 2.2018*ASL_h

pix_v = 240 - pix_v;

VGA_h = pix_h.*2.46153846153846 - 320; % horz
VGA_v = pix_v.*2.02500000000000 - 243; % vert


%VGA_h = (41.8716 + 2.2018.*pix_h) - 320;
%VGA_v = (488 - 2.*pix_v)- 243;

% convert vga pixels using formula:
%
% center pixel = 320, 243
% NOTE: this is the center pixel. however, it is the lower-right corner of the "5"
%
% 1/2 width of screen is 320 pixels, and fov_x is 50 degrees so
% distance from screen to eye is 
%      686.2422145630587
dist =     6.862422145630587e+02;

angle_h = -180.*atan2(VGA_h,dist)./pi;
angle_v = 180.*atan2(VGA_v,dist)./pi;

