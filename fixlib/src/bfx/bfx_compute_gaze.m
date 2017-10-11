%BFX_COMPUTE_GAZE computes gaze angles from baufix data
%   this function is unused, caveat emptor

% $Id: bfx_compute_gaze.m,v 1.2 2001/07/19 15:14:13 pskirko Exp $
% pskirko 7.17.01

function [gaze_h, gaze_v] = bfx_compute_gaze(head_h, head_p, ...
                                             eih_h, eih_v, ...
                                             headp_x, headp_y, headp_z)

% headp means head data already converted to performer units
% computes gaze for baufix data

% gaze formulas:
% gaze_h = head_h + eih_h + HEAD_TRANS_h
% gaze_v = head_p + eih_v + HEAD_TRANS_v

% where head trans represent the angle formed by the translation, which 
% is computed from consecutive position points, with the angle taken
% about the point (0, -155, -550);

pt = [0 -155 -550];
[htrans_h, htrans_v] = trans2angle(headp_x, headp_y, headp_z, pt);

%gaze_h = htrans_h;
%gaze_v = htrans_v;

gaze_h = head_h + eih_h + htrans_h;
gaze_v = head_p + eih_v + htrans_v;
