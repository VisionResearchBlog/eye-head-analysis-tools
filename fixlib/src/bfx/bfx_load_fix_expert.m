function fix = bfx_load_fix_expert(filename)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bfx_load_fix_expert.m
%
% loads fixations from "expert" file
% the only such files i know of are in the folder
%    Baufix - Fixation Duration Summer 2000
% on the blue mac in the piano room.
%
% the excel files must be converted to 
% tab-delimited text files to work here.
%  
% these files are not parser-friendly, so
% my method below is a bit hacked at best.
% i ll comment what i m doing below.
%
% INPUTS:
%   filname - expert file to use
%  
% OUTPUTS: 
%    fixations
%
%
% pskirko 6.6.01
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global fid currline tok;

fid = fopen(filename, 'rt');
if(fid == -1) 
   error(['file not found:' filename]);
end

% discard the first 8 lines as header

for i=1:9
   fgetl(fid);
end

fix = []; idx = 1;

% for each line
advance_line;

while(~isempty(currline))
   advance_token; % skip the trial #
   t_start = [];
   t_end = [];

   % spin until we hit another number
   keep_going = 1;
   look_for_fix = 0;
   while(keep_going)
      advance_token;
   
      if(isempty(tok)) %end of line, continue
         keep_going = 0;
      else
         tmp = str2num(tok);
         if(~isempty(tmp))
            keep_going = 0;
            look_for_fix = 1;
            t_end = tmp;
         end
      end
   end

if(look_for_fix)
   advance_token; % skip the timecode
   advance_token;
   % if next field is a number, grab fixation
   if(isempty(tok))
      tmp = [];
   else
      tmp = str2num(tok);
   end
   if(~isempty(tmp)) % this is duration
      t_start = t_end - tmp;
      fix(idx, :) = [t_start t_end]; idx = idx + 1;
   else % skip this line
      advance_line;
   end
else % goto next line
   advance_line;
end

end

fclose(fid);

% advances the token, stops at a line (returns [])

function advance_token

global tok currline;

[tok, currline] = strtok(currline);

% advances the line (returns [] when done)

function advance_line

global fid currline;

keep_going = 1;

while(keep_going)
   currline = fgetl(fid);
   if(~ischar(currline)) % end-of-file
      keep_going = 0;
      currline = [];
   elseif(sum(isspace(currline))) % spin thru newlines
      keep_going = 0;      
   end
end








