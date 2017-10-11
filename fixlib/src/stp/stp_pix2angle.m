%STP_PIX2ANGLE converts pixels into visual angles

% $Id: stp_pix2angle.m,v 1.1 2001/08/15 16:36:00 pskirko Exp $
% pskirko 8.15.01

% same fov as baufix so we'll use same conversion

function [angle_h, angle_v] = stp_pix2angle(pix_h, pix_v)

% converts pixels to angles

% convert asl pixels into vga pixels using the functions:
%   VGA_v = 488 -2*ASL_v
%   VGA_h = 41.8716 + 2.2018*ASL_h

VGA_h = (41.8716 + 2.2018.*pix_h) - 320;
VGA_v = (488 - 2.*pix_v)- 243;

% convert vga pixels using formula:
%
% center pixel = 320, 243
% NOTE: this is the center pixel. however, it is the lower-right corner of the "5"
%
% 1/2 width of screen is 320 pixels, and fov_x is 50 degrees so
% distance from screen to eye is 
%      686.2422145630587
%dist =     6.862422145630587e+02;
% need to use 48 degrees 
%% 320 / tan(1/2*fovh)
%  7.187317676493492e+02

dist = 7.187317676493492e+02;


angle_h = 180.*atan2(VGA_h,dist)./pi;
angle_v = 180.*atan2(VGA_v,dist)./pi;

