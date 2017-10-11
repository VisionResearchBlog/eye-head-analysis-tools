% loads data from the ALL matrix  

function ans = baufix_read_ALL(ALL, option)

num = [];

if(strcmp(option, 'time'))
  num = 1;
  
elseif(strcmp(option, 'RightHand_FT_X'))
  num = 2;
elseif(strcmp(option, 'RightHand_FT_Y'))
  num = 3;    
elseif(strcmp(option, 'RightHand_FT_Z'))
  num = 4;    
elseif(strcmp(option, 'RightHand_FT_H'))
  num = 5;        
elseif(strcmp(option, 'RightHand_FT_P'))
  num = 6;    
elseif(strcmp(option, 'RightHand_FT_R'))
  num = 7;
  
  
elseif(strcmp(option, 'LeftHand_FT_X'))
  num = 8;
elseif(strcmp(option, 'LeftHand_FT_Y'))
  num = 9;
elseif(strcmp(option, 'LeftHand_FT_Z'))
  num = 10;
elseif(strcmp(option, 'LeftHand_FT_H'))
  num = 11;
elseif(strcmp(option, 'LeftHand_FT_P'))
  num = 12;
elseif(strcmp(option, 'LeftHand_FT_R'))
  num = 13;
  
 
elseif(strcmp(option, 'scene_plane_x'))
  num = 14;
elseif(strcmp(option, 'scene_plane_y'))
  num = 15;
elseif(strcmp(option, 'asl_pupil'))
  num = 16;
elseif(strcmp(option, 'asl_scene_plane'))
  num = 17;

  
elseif(strcmp(option, 'fastrak_x'))
  num = 18;
elseif(strcmp(option, 'fastrak_y'))
  num = 19;
elseif(strcmp(option, 'fastrak_z'))
  num = 20;
elseif(strcmp(option, 'fastrak_h'))
  num = 21;
elseif(strcmp(option, 'fastrak_p'))
  num = 22;
elseif(strcmp(option, 'fastrak_r'))
  num = 23;
  
elseif(strcmp(option, 'asl_h'))
  num = 24; 
elseif(strcmp(option, 'asl_v'))
  num = 25; 

else
  error(['unknown option: ' option]);
end

ans = ALL{num};