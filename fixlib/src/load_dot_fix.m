%LOAD_DOT_FIX loads a .fix file
%   FIX = LOAD_DOT_FIX(FILENAME) loads the fixation information
%   into FIX from the .fix file FILENAME in the following format:
%
%   <id> <duration> <start> - <end> <comment>
%
%   This is the same format as the original fixation analysis
%   program.

% $Id: load_dot_fix.m,v 1.1 2001/08/16 17:26:42 pskirko Exp $
% pskirko 8.13.01

function fix = load_dot_fix(filename)

[a, b] = textread(filename, '%*s %*d %d %*s %d %*s');

fix = [a, b];