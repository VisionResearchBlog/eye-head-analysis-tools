%COMPUTE_GAZE_BB computes bounding box for eye data
%   BB = COMPUTE_GAZE_BB(GAZE_H, GAZE_V) computes a bounding box BB 
%   for the eye data GAZE_H, GAZE_V.  used by high-level scripts
%   that run eyeviz.
%
%   formula:
%
%   TMP = MAX(ABS([GAZE_H; GAZE_V]))
%   BB  = [-TMP, TMP]

% $Id: compute_gaze_bb.m,v 1.2 2001/08/16 19:04:54 pskirko Exp $
% pskirko 7.10.01

function bb = compute_gaze_bb(gaze_h, gaze_v)

tmp = abs([gaze_h; gaze_v]);
tmp = max(tmp);
bb = [-tmp, tmp];