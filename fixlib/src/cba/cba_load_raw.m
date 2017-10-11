function A = cba_load_raw(filename, options)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cba_load_raw.m
%
% loads data from "change blindness 
% application" raw data file
%
% do not use these files when possible.
% they are too slow. use instead the 
% "variant" files i'll eventually make
%
% INPUTS:
%   filname - file to load from
%   options - one of the following:
%     'asl_h' - asl horizontal "pixels"
%     'asl_v' - asl vertical "pixels"
%     'time' - time
%  
%   hmm, also going to try 
%   comma-separated list
%
% OUTPUTS: 
%   the corresponding column; if it is
%   a string, then its returned as cell
%   array, not as a data array
%
%   if you input a comma-separated list,
%   i return a cell-array of columns 
%   in the order you requested them
%
%   i'm also going to al
% pskirko 6.12.01
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% we need to use strtok b/c sscanf gives us chars not tokens!
% also cannot use textread b/c lines have variable format

% columns numbered starting w/ 1 for "data"

%target_idx = 1;
%do_str2num = 1; % off by default

results = parse_input(options);

if 0
if(strcmp(options, 'time'))
   target_idx = 2;
elseif(strcmp(options, 'asl_h'))
   target_idx = 16;
elseif(strcmp(options, 'asl_v'))
   target_idx = 17;
else 
   error(['bad option:' options]);
end
end

global fid currline tok;

fid = fopen(filename, 'rt');
if(fid == -1) 
   error(['file not found:' filename]);
end

if 0
if(do_str2num)
A = []; 
else
A = {};
end
end

B = {};

idx = 1;
data_begun = 0;

% for each line
advance_line;

while(~isempty(currline))
   advance_token;

   if(data_begun) % parse data
      if(is_token('data')) % parse data
         advance_token;
         curr_idx = 2;
         while(~isempty(tok))
            found_data = find(results(:,2) == curr_idx);

            if(~isempty(found_data)) % add to appropriate spot in output
               tmp = tok;

               if(results(found_data, 3)) % convert to num
                  tmp = str2num(tok);
               end

               B{idx, results(found_data, 1)} = tmp;             
            else

            end
            advance_token;
            curr_idx = curr_idx + 1;
         end
         idx = idx + 1;
         advance_line;
      elseif(is_token('#')) % do something else
         advance_line;
      end

if 0 % COMMENTED OUT
         for i=1:(target_idx-1) % spin thru columns
            advance_token;
         end
         tmp = tok;
         if(do_str2num)
            tmp = str2num(tmp);
	    A(idx, 1) = tmp;
	 else
            A{idx, 1} = tmp;
         end
         
         idx = idx+1;
         advance_line;
end

 
   else % look for start of data
      if(is_token('#')) % look for 'Time'
         advance_token;
         if(is_token('Time')) % look for LPX
            advance_token;
            if(is_token('LPX')) % found it
               data_begun = 1;
               advance_line;
            else % skip
               advance_line;
            end
         else % skip
            advance_line;
         end
      else % skip
         advance_line;
      end
   end
end

% convert data to column format for output

A = {};
n = size(results, 1);
for i=1:n
   if(results(i, 3)) % is num, so make an array
      A{i} = cat(B{:, i});
   else % keep as cell array
      A(i) = B(:,i);
   end
end

fclose(fid);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% advances the token, stops at a line (returns [])

function advance_token

global tok currline;

[tok, currline] = strtok(currline);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bool = is_token(tok2)

global tok;

bool = strcmp(tok, tok2);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% construct table of following format:
%
% output column | input target_idx | do_str2num

function result = parse_input(options)

line = options; idx = 1;
[tok, line] = strtok(line, ','); 

while(~isempty(tok))

target_idx = -1;
do_str2num = 1;
   
if(strcmp(tok, 'time'))
   target_idx = 2;
elseif(strcmp(tok, 'asl_h'))
   target_idx = 16;
elseif(strcmp(tok, 'asl_v'))
   target_idx = 17;
end

if(target_idx ~= -1)
  result(idx, :) = [idx target_idx do_str2num];
  idx = idx + 1;
else 
   error(['bad option:' options]);
end

   [tok, line] = strtok(line, ','); 
end
