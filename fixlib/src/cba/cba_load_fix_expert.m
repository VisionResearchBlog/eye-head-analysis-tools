function fix = cba_load_fix_expert(filename)

%loads in expert data
% the ms in these files are all screwed up, so need to use tc
% instead, slower, ack

fid = fopen(filename, 'r');

% skip first 8 lines

%for i=1:8
%  fgetl(fid);
%end

fix = []; idx = 1;

line = fgetl(fid);

while(line ~= -1)
 [a, count] = sscanf(line, '%d %d %d %s %s %s %s %s %s %d %s %d');
   
 if(count == 12)
   [fix_tc, fix_dur] = strread(line, ...
			'%*d %*d %*d %*s %*s %*s %*s %*s %*s %*d %s %d');

  
   fix_end = str2tc2ms(fix_tc{1});
   
   fix_start = fix_end - fix_dur;
   fix(idx, :) = [fix_start fix_end]; idx = idx + 1;
 end
 
 line = fgetl(fid);
end

fclose(fid);

% %%
function ms = str2tc2ms(str)

[h, str] = strtok(str, ':');
[m, str] = strtok(str, ':');
[s, str] = strtok(str, ':');
[f, str] = strtok(str, ':');

tc = str2num([h, ' ', m, ' ', s, ' ', f]);

if(length(tc) ~= 4)
  foo =a;
  jar = b;
end

%tc = str2num([str(1:2), ' ', str(4:5), ' ', str(7:8), ' ', ...
%	       str(10:11)]);

ms = compute_tc2ms(tc);
