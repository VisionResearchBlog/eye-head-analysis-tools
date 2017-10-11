function [angle_h, angle_v] = baufix_pix2angle(pix_h, pix_v)

% converts ASL pixels to angles
% note this is from my rough estimates and needs to be verified
% by Neil Mennie to be sure this conversion seems plausible

angle_h = pix_h/5.5; 
angle_v = pix_v/6.5;
% well these are most definitely wrong 

