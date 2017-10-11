function [angle_h, angle_v] = cba_pix2angle(pix_h, pix_v)

% converts pixels to angles
% even though cba uses a fov of 60 degrees horizontal (AFAIK), 
% i think the conversion should still use 50 degrees
% since that is the true fov of a helmet (i hope)
% whoops i just learned that true horizontal fov is 
% 48 deg. for VR8 helmet.
%
% the 60 jochen used means we need different calibration
% parameters

% convert asl pixels into vga pixels using the functions:
%   VGA_v = 488 -2*ASL_v
%   VGA_h = 42.3736 + 2.1978*ASL_h

VGA_h = (42.3736 + 2.1978.*pix_h) - 320;
VGA_v = (488 - 2.*pix_v)- 243;

% convert vga pixels using formula:
%
% center pixel = 320, 243
% NOTE: this is the center pixel. however, it is the lower-right corner of the "5"
%
% 1/2 width of screen is 320 pixels, and fov_x is 48 degrees so
% distance from screen to eye is 
%      
%
%% 320 / tan(1/2*fovh)
%  7.187317676493492e+02

dist = 7.187317676493492e+02;

angle_h = -180.*atan2(VGA_h,dist)./pi;
angle_v = 180.*atan2(VGA_v,dist)./pi;

