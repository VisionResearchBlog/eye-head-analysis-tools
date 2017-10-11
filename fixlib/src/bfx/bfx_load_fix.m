function fix = bfx_load_fix(filename)

% bfx_load_fix.m
% load fixations from baufix file

% data format:
% row   item
% 
% 1     - fixation number, string, ignore
% 2     - fixation duration, time, ignore
% 3     - fixation begin, time
% 4     - hyphen, ignore
% 5     - fixation end, time
% 6     - baufix area, string, ignore 

% only interested in 3 and 5

format = '%*s %*d %d %*s %d %*s';
[c3, c5] =  textread(filename, format);
         
fix = [c3, c5];
