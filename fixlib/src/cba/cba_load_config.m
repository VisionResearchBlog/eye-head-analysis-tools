%**************************************************************
%*      cba_load_config
%*
%*      loads configuration parameters for a change blindness
%*      file
%*  
%*      this file is currently very limited and volatile
%*
%*      options:
%*      'WritingDataOn' - returns the tc for this
%* 
%*      pskirko 7.5.01
%**************************************************************
function A = cba_load_config(filename, options)

fid = fopen(filename, 'r');

line = fgetl(fid);

while(line ~= -1)
  [tok, line] = strtok(line);
  if(strcmp(tok, '#'))
    [tok, line] = strtok(line);
    if(strcmp(tok, 'WritingDataOn'))
      [tc, line] = strtok(line); % this is the tc
      
      [h, tc] = strtok(tc, ':');
      [m, tc] = strtok(tc, ':'); 
      [s, tc] = strtok(tc, ':');
      [f, tc] = strtok(tc, ':');
      
      A = str2num([h, ' ', m, ' ', s, ' ', f]);
      
      break;
    end
  end
  line = fgetl(fid);
end

fclose(fid);