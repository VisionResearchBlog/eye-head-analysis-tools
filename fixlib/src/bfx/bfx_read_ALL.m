%BFX_READ_ALL extract column from ALL matrix
%   ANS = BFX_READ_ALL(ALL, OPTION) extracts the column specified
%   by OPTION from the ALL matrix produced by BFX_LOAD_RAW; the 
%   result is put in ANS.
%   
%   OPTION can take any value listed in BFX_LOAD_RAW.
%
%   This function provides an abstraction of ALL, so individual 
%   column numbers need not be remembered (cleaner code too).

%  $Id: bfx_read_ALL.m,v 1.1 2001/07/20 12:42:13 pskirko Exp $
%  pskirko 7.17.01

function ans = bfx_read_ALL(ALL, option)

if(strcmp(option, 'time'))
  num = 1; 
elseif(strcmp(option, 'head_x'))
  num = 2; 
elseif(strcmp(option, 'head_y'))
  num = 3; 
elseif(strcmp(option, 'head_z'))
   num = 4;  
elseif(strcmp(option, 'head_h'))
  num = 5;   
elseif(strcmp(option, 'head_p'))
  num = 6;   
elseif(strcmp(option, 'head_r'))
  num = 7;   
elseif(strcmp(option, 'hand_x'))
  num = 8;   
elseif(strcmp(option, 'hand_y'))
  num = 9;   
elseif(strcmp(option, 'hand_z'))
  num = 10;   
elseif(strcmp(option, 'hand_h'))
  num = 11;   
elseif(strcmp(option, 'hand_p'))
  num = 12;   
elseif(strcmp(option, 'hand_r'))
  num = 13;   
elseif(strcmp(option, 'asl_h'))
  num = 14;   
elseif(strcmp(option, 'asl_v'))
  num = 15;   
elseif(strcmp(option, 'asl_pupil'))
  num = 16;   
elseif(strcmp(option, 'eih_h'))
  num = 17;   
elseif(strcmp(option, 'eih_v'))
  num = 18;   
elseif(strcmp(option, 'gaze_h'))
  num = 19;   
elseif(strcmp(option, 'gaze_v'))
  num = 20;   
elseif(strcmp(option, 'look_area'))
   num = 21;  
elseif(strcmp(option, 'event'))
  num = 22;   
elseif(strcmp(option, 'event_param'))
  num = 23;   
else
  error(['unknown option: ' option]);
end

ans = ALL{num};