function [vel, t] = bfx_load_vel(filename)

% bfx_load_vel.m
% load velocity from baufix file

% time is passed 2nd in case you don't want it

% data format:
% row   item
% 
% 1     - time (ms?)
% 2     - asl hpos (asl units?)
% 3     - asl vpos (asl units?)
% 4     - horizontal velocity (using mask) 
% 5     - vertical velocity (using mask)
% 6     - combined velocity (using mask)
% 7     - horizontal velocity (no mask)
% 8     - vertical velocity (no mask)
% 9     - combined velocity (no mask)
% 10    - scmsk (?)
% 11    - R/M (?)
% 12    - thresh (?)
% 13    - text (ignore)
% 14    - text (ignore)
% 15    - text (ignore)

% only interested in time 1 and total raw velocity 9

% NOTE: field 11 has garbled entries, so we treat it as
%       a string rather than a number

format = '%d %*f %*f %*f %*f %*f %*f %*f %f %*f %*s %*f %*s %*s %*s';

[t, vel] =  textread(filename, format, ...
                     'headerlines', 3); % discard headers
         
