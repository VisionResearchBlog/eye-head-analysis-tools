%CBA_LOAD_EXPERT loads data from expert file into ALL-style matrix

% $Id: cba_load_expert.m,v 1.1 2001/08/15 16:52:14 pskirko Exp $
% pskirko 8.15.01

function ALL = cba_load_expert(filename)

fid = fopen(filename, 'r');

line = fgetl(fid);

A = {}; idx = 1;

while(line ~= -1)
 [a, count] = sscanf(line, '%d %d %d %s %s %s %s %s %s %d %s %d');
   
 if(count == 12)
   [c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12] = ...
       strread(line, '%d %d %d %s %s %s %s %s %s %d %s %d');
   
   A(idx, :) = {c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12};
   idx = idx + 1;
   
 elseif(count == 11) % no duration number
   [c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11] = ...
       strread(line, '%d %d %d %s %s %s %s %s %s %d %s');
   
   A(idx, :) = {c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, -1}; 
   idx = idx + 1;
 end
 
 line = fgetl(fid);
end

fclose(fid);

ALL = {cat(1,A{:,1}), cat(1,A{:,2}), cat(1,A{:,3}), cat(1,A{:,4}), ...
       cat(1,A{:,5}), cat(1,A{:,6}), cat(1,A{:,7}), cat(1,A{:,8}), ...
       cat(1,A{:,9}), cat(1,A{:,10}), cat(1,A{:,11}), cat(1,A{:,12})};