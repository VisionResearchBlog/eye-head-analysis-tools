function fix = baufix_load_fix(filename)

%loads in expert data
% the ms in these files are all screwed up, so need to use tc
% instead, slower, ack

fid = fopen(filename, 'r');

fix = []; idx = 1;

line = fgetl(fid);

while(line ~= -1)
 [a, count]  = sscanf(line, '%d %s %s %d %s %d');
 
 if(count == 6)
 [fix_tc, fix_dur] = strread(line, '%*d %*c %*s %*d %s %d');

   fix_end = str2tc2ms(fix_tc{1});
   fix_start = fix_end - fix_dur;
   fix(idx, :) = [fix_start fix_end]; idx = idx + 1;
 
 end
 
 line = fgetl(fid);
end

fclose(fid);

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

ms = compute_tc2ms(tc);
