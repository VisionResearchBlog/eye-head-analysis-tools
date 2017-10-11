function fix = stp_load_fix_expert(filename)

%loads in expert data, all times offset from the first timecode in file.
% the ms in these files are all screwed up, so need to use tc
% instead, slower, ack

% we need to get first tc too.

fid = fopen(filename, 'r');


fix = []; idx = 1; first_time = 1; first_ms = 0;

line = fgetl(fid);

while(line ~= -1)
  if(first_time)
    [a, count] = sscanf(line, '%d %s %s %s %d %s');
    
    if(count == 6)
      first_time = 0;
      [fix_tc] = strread(line, ...
			 '%*d %*s %*s %*s %*d %s');
      first_ms = str2tc2ms(fix_tc{1});
    end
  end
  
  
 [a, count] = sscanf(line, '%d %s %s %s %d %s %d');
   
 if(count == 7)
   [fix_tc, fix_dur] = strread(line, ...
			'%*d %*s %*s %*s %*d %s %d');

  
   fix_end = str2tc2ms(fix_tc{1});
   
   fix_start = fix_end - fix_dur;
   fix(idx, :) = [fix_start fix_end]; idx = idx + 1;
 end
 
 line = fgetl(fid);
end

fclose(fid);

fix = fix - first_ms; 

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
