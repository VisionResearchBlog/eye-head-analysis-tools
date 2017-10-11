%SAVE_DOT_FIX saves a .fix file
%   SAVE_DOT_FIX(FILENAME, FIX) saves the fixation information FIX
%   to the file FILENAME in the following format:
%
%   <id> <duration> <start> - <end> <comment>
%
%   This is the same format as the original fixation analysis
%   program.

% $Id: save_dot_fix.m,v 1.2 2001/08/17 15:56:08 pskirko Exp $
% pskirko 8.13.01

function save_dot_fix(filename, fix, tc, fix_frames, labels)

fid = fopen(filename, 'w');

% slow but oh well

n = size(fix, 1);

for i=1:n
  % round gets rid of exponential notation (hack)
  % might want to try %g vis %d
  t_start = round(fix(i,1));
  t_end =   round(fix(i,2));
   
  fprintf(fid, '%s %s %s %d %d %d %s\n', ...
	  num2str(i), tc{fix_frames(i,1)}, tc{fix_frames(i,2)}, ...
      t_start, t_end, t_end - t_start, labels{i} );
end

fclose(fid);
