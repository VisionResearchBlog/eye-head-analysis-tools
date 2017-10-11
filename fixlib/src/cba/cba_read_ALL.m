% loads data from the ALL matrix  

function ans = cba_read_ALL(ALL, option)

num = [];

if(strcmp(option, 'tag'))
  num = 1;
elseif(strcmp(option, 'time'))
  num = 2;
elseif(strcmp(option, 'phantom_left_x'))
  num = 3;
elseif(strcmp(option, 'phantom_left_y'))
  num = 4;    
elseif(strcmp(option, 'phantom_left_z'))
  num = 5;    
elseif(strcmp(option, 'phantom_right_x'))
  num = 6;        
elseif(strcmp(option, 'phantom_right_y'))
  num = 7;    
elseif(strcmp(option, 'phantom_right_z'))
  num = 8;    
elseif(strcmp(option, 'fastrak_x'))
  num = 9;
elseif(strcmp(option, 'fastrak_y'))
  num = 10;
elseif(strcmp(option, 'fastrak_z'))
  num = 11;
elseif(strcmp(option, 'fastrak_h'))
  num = 12;
elseif(strcmp(option, 'fastrak_p'))
  num = 13;
elseif(strcmp(option, 'fastrak_r'))
  num = 14;
elseif(strcmp(option, 'asl_pupil'))
  num = 15;
elseif(strcmp(option, 'asl_h'))
  num = 16;
elseif(strcmp(option, 'asl_v'))
  num = 17;
elseif(strcmp(option, 'touched_object_id'))
  num = 18;
elseif(strcmp(option, 'pos_x'))
  num = 19;
elseif(strcmp(option, 'pos_y'))
  num = 20;
elseif(strcmp(option, 'pos_z'))
  num = 21;
elseif(strcmp(option, 'size'))
  num = 22;
elseif(strcmp(option, 'color'))
  num = 23;
elseif(strcmp(option, 'phantom_left_fx'))
  num = 24;
elseif(strcmp(option, 'phantom_left_fy'))
  num = 25;
elseif(strcmp(option, 'phantom_left_fz'))
  num = 26;
elseif(strcmp(option, 'phantom_right_fx'))
  num = 27;
elseif(strcmp(option, 'phantom_right_fy'))
  num = 28;
elseif(strcmp(option, 'phantom_right_fz'))
  num = 29;
else
  error(['unknown option: ' option]);
end

ans = ALL{num};