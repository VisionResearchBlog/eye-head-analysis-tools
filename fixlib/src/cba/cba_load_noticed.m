%CBA_LOAD_NOTICED loads "Noticed" tags from file
%  A = CBA_LOAD_NOTICED(filename) ... blah ...
%  each column of A is the time in millis of a noticed change relative to
%  the beginning of writeData

% $Id: cba_load_noticed.m,v 1.2 2002/05/03 17:32:24 pilardi Exp $
% pskirko 8.15.01

% Changed to use sgi clock instead of timecode (pilardi 05/02)

function A = cba_load_noticed(filename)

fid = fopen(filename, 'r');

line = fgetl(fid);

idx = 1;

firstTime=-1;

while(line ~= -1)
  if(strncmp(line, 'data',4))
    lastDataLine=line;
    if(firstTime==-1)
      firstTime=extractTime(lastDataLine);
    end
  elseif(strncmp(line, '# size change',13))
    lastChange=extractTime(lastDataLine)-firstTime;
  elseif(strncmp(line, '# NoticedChange',15))
    A(idx) = lastChange;
    idx=idx+1;
  end
  line = fgetl(fid);
end

fclose(fid);

A = A';


function time=extractTime(line)
%extracts time from 'data' line in file in millis

[tok, line] = strtok(line); %remove 'data'
time=str2double(strtok(line))*1000;
