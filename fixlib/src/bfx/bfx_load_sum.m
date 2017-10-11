function bfx_sum_struct = bfx_load_sum(filename)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bfx_load_sum.m
%
% loads parameters from baufix summary file
%
% INPUTS:
%   filname - .sum file to use
%  
% OUTPUTS: 
%
% the struct looks like this:
%    raw_data_filename - 
%    raw_data_format - 
%    vel_format - 
%    vel_thresh - 
%    vel_ceiling - 
%    median_filter_window_size -
%    time_thresh - 
%    eye_data_format - 
%    is_clumping_done - 
%    clump_time_thresh -
%    clump_space_thresh -
%    clump_invalid_frames_thresh -
%    is_eye_data_filled - 
%    fill_time_thresh -
%    fill_space_thresh -
%    fill_eye_data_format - 
%    is_look_area_filled - 
%
% pskirko 6.6.01
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f1name = 'raw_data_filename';
f1val  = [];
f2name = 'raw_data_format';
f2val  = [];
f3name = 'vel_format';
f3val  = [];
f4name = 'vel_thresh';
f4val  = [];
f5name = 'vel_ceiling';
f5val  = [];
f6name = 'median_filter_window_size';
f6val  = [];
f7name = 'time_thresh';
f7val  = [];
f8name = 'eye_data_format';
f8val  = [];
f9name = 'is_clumping_done';
f9val  = [];
f10name = 'clump_time_thresh';
f10val  = [];
f11name ='clump_space_thresh';
f11val  = [];
f12name = 'clump_invalid_frames_thresh';
f12val  = [];
f13name = 'is_eye_data_filled';
f13val  = [];
f14name = 'fill_time_thresh';
f14val  = [];
f15name = 'fill_space_thresh';
f15val  = [];
f16name = 'fill_eye_data_format';
f16val  = [];
f17name = 'is_look_area_filled';
f17val  = [];

global fid currline tok;

fid = fopen(filename, 'rt');
if(fid == -1) 
   error(['file not found:' filename]);
end

currline = [];
advance_token;

% init struct params

while(~isempty(tok))
   if(is_token('DataFile:'))
      advance_token;
      f1val = tok;
      advance_token;
   elseif(is_token('DataType:'))
      advance_token;
      f2val = tok;
      advance_token;
   elseif(is_token('Velocity:'))
      advance_token;
      f3val = tok;
      advance_token;
   elseif(is_token('Velocity'))
      advance_token;
      if(is_token('Threshold:'))
         advance_token;
         f4val = str2num(tok);
         advance_token;
      elseif(is_token('Ceiling:'))
         advance_token;
         f5val = str2num(tok);
         advance_token;
      end
   elseif(is_token('Median'))
      advance_token; % 'Filter:'
      advance_token;
      f6val = str2num(tok);
      advance_token;
   elseif(is_token('Time'))
      advance_token; % 'Threshold:'
      advance_token;
      f7val = str2num(tok);
      advance_token;
   elseif(is_token('Using_Eye_Data_Type:'))
      advance_token;
      f8val = tok;
      advance_token;
   elseif(is_token('Clumping:'))
      advance_token;
      f9val = tok;
      advance_token;
   elseif(is_token('Clumping_Time_Upper_Bound:'))
      advance_token;
      f10val = str2num(tok);
      advance_token;
   elseif(is_token('Clumping_Space_Upper_Bound:'))
      advance_token;
      f11val = str2num(tok);
      advance_token;
   elseif(is_token('Clumping_InvalidData_Lower_Bound:'))
      advance_token;
      f12val = str2num(tok);
      advance_token;
   elseif(is_token('Filling_In_Eye_data:'))
      advance_token;
      f13val = tok;
      advance_token;
   elseif(is_token('Fillin_In_Time_Threshold:'))
      advance_token;
      f14val = str2num(tok);
      advance_token;
   elseif(is_token('Filling_In_Space:'))
      advance_token;
      f15val = str2num(tok);
      advance_token;
   elseif(is_token('Fillin_In_Eye_Type:'))
      advance_token;
      f16val = tok;
      advance_token;
   elseif(is_token('Fill_Look_Area:'))
      advance_token;
      f17val = tok;
      advance_token;
   else
      advance_token;
   end

   %disp(['tok: ' tok]);
   %advance_token;
end

fclose(fid);

bfx_sum_struct = ...
   struct(f1name, f1val, f2name, f2val, f3name, f3val, f4name, f4val, ...
          f5name, f5val, f6name, f6val, f7name, f7val, f8name, f8val, ...
          f9name, f9val, f10name, f10val, f11name, f11val, f12name, f12val, ...
          f13name, f13val, f14name, f14val, f15name, f15val, ...
          f16name, f16val, f17name, f17val);
                       
 
% returns the next token, or [] when there is none

function advance_token

global fid currline tok;

keep_going = 1;

while(keep_going)

if(isempty(currline)) % grab new line
   currline = fgetl(fid);
   if(~ischar(currline)) % end-of-file
      keep_going = 0;
      tok = [];
   else % get tok
      if(~isspace(currline)) %ignore empty lines
         keep_going = 0;
         [tok, currline] = strtok(currline);
      end
   end
else % get new token
      keep_going = 0;
      [tok, currline] = strtok(currline);
end

end

% checks token for val

function bool = is_token(tok2)

global tok;

bool = strcmp(tok, tok2);
