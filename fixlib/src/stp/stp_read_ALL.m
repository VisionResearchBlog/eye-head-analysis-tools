%STP_READ_ALL extract column from ALL matrix
%   ANS = STP_READ_ALL(ALL, OPTION) extracts the column specified
%   by OPTION from the ALL matrix produced by STP_LOAD_RAW; the 
%   result is put in ANS.
%   
%   OPTION can take any value listed in STP_LOAD_RAW.
%
%   This function provides an abstraction of ALL, so individual 
%   column numbers need not be remembered (cleaner code too).

%  $Id: stp_read_ALL.m,v 1.1 2001/08/15 16:36:02 pskirko Exp $
%  pskirko 8.13.01

function ans = stp_read_ALL(ALL, option)

if(strcmp(option, 'time'))
  num = 1; 
elseif(strcmp(option, 'head_h'))
  num = 2:
elseif(strcmp(option, 'head_p'))
  num = 3;
elseif(strcmp(option, 'head_r'))
  num = 4;
elseif(strcmp(option, 'asl_h'))
  num = 5;
elseif(strcmp(option, 'asl_v'))
  num = 6;
elseif(strcmp(option, 'asl_pupil'))
  num = 7;
elseif(strcmp(option, 'Saccade'))
  num = 8;
elseif(strcmp(option, 'Mark'))
  num = 9;
elseif(strcmp(option, 'saccade_raw_data'))
  num = 10;
%elseif(strcmp(option, 'vel'))
%  num = 11;
else
  error(['unknown option: ' option]);
end

ans = ALL{num};



