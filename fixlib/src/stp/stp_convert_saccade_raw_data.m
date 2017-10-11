%STP_CONVERT_SACCADE_RAW_DATA
%   VOLTS = STP_CONVERT_SACCADE_RAW_DATA(T, RAW) takes the column of
%   variable-length, comma-delimited volt values in RAW from the stp data
%   file, and the time T, and converts them into a 2-column matrix
%   VOLTS with format: <time> <volt>.

function volts = stp_convert_saccade_raw_data(t, raw)

n = length(t);

volts = [];

for i=2:n
  clear t_new;
  curr_t = t(i);
  line = raw{i};

  volt = str2num(line);
  m = length(volt);
  
  %calculate time delta between frames to interpolate time
  t_del = t(i) - t(i-1);
  t_inc = t_del/size(volt,2);
  t_new(1,2) = t(i-1) + t_inc;
  t_new(1,1) = i;
  for j=2:size(volt,2)
    t_new(j,2) = t_new(j-1,2) + t_inc;
    t_new(j,1) = i;
  end
 
  volts = [volts; [t_new, volt']];  

end

