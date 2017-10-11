%COMPUTE_TRACK_LOSS identifies track losses in pupil data
%   [GOOD, BAD] = COMPUTE_TRACK_LOSS(PUPIL, PUPIL_THRESH) uses the 
%   pupil data PUPIL and pupil diameter threshold PUPIL_THRESH
%   to identify track losses.  It returns GOOD and BAD, the indices
%   of the good (no track loss) and bad (track loss) pupil values 
%   respectively.  GOOD and BAD can then be used to index into
%   velocity or some other value.
%
%   WARNING! using positions isn't very good.  Pupil velocities 
%   (rate of change of diameter) can have big and small peaks, so
%   you miss the small ones.  Not to mention that people have
%   different working diameters.

% $Id: compute_track_loss.m,v 1.2 2001/08/15 18:06:44 pskirko Exp $
% pskirko 8.15.01

function [good, bad] = compute_track_loss(pupil, pupil_thresh)

cond = pupil > pupil_thresh;

good = find(cond);
bad  = find(~cond);