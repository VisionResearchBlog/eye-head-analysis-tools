%BAUFIX_LOAD_DATA load data from a buidling_baufix(N. Mennie) ".data" file
%   ALL = BAUFIX_LOAD_DATA(FILENAME, 'all') loads all the data from
%   FILENAME and places the result in ALL, which is a 1D cell-array
%   with 1 cell per column, in the original order.
%
%   ANS = BAUFIX_LOAD_DATA(FILENAME, OPTION) loads one column of
%   data from FILENAME and places the result in the vector ANS
%   (ANS is a 1D cell array if the column contains string values).
%
%   FILENAME must be a ".data" file which is produced by running
%   the helper program "cba_converter" on the original ".dat" file
%
%   OPTION can be one of the following (the order is the same as in
%   the data file):
%
%          1.  'time' 
%
%          2.  'RightHand_FT_X'
%          3.  'RightHand_FT_Y' 
%          4.  'RightHand_FT_Z'
%          5.  'RightHand_FT_H'
%          6.  'RightHand_FT_P'
%          7.  'RightHand_FT_R'
%
%          8.  'LeftHand_FT_X'
%          9.  'LeftHand_FT_Y' 
%          10. 'LeftHand_FT_Z'
%          11. 'LeftHand_FT_H'
%          12. 'LeftHand_FT_P'
%          13. 'LeftHand_FT_R'
%
%          14. 'ScenePlane_X'
%          15. 'ScenePlane_Y'
%          16. 'asl_pupil'
%          17. 'asl_scene_plane'
%
%          These fastrak values are for the head: 
%          18. 'fastrak_x'
%          19. 'fastrak_y'
%          20. 'fastrak_z'
%          21. 'fastrak_heading/azimuth'
%          22. 'fastrak_pitch/elevation'
%          23. 'fastrak_r'
%
%          Raw eye data:
%          24. 'asl_h'
%          25. 'asl_v'

function A = baufix_load_data(filename, option)
 
if(strcmp(option, 'all'))
  s1 = '%f '; s2 = '%f '; s3 = '%f '; s4 = '%f '; s5 = '%f ';
  s6 = '%f '; s7 = '%f '; s8 = '%f '; s9 = '%f '; s10 = '%f ';
  s11 = '%f '; s12 = '%f '; s13 = '%f '; s14 = '%f '; s15 = '%f ';
  s16 = '%d '; s17 = '%d '; s18 = '%f '; s19 = '%f '; s20 = '%f ';
  s21 = '%f '; s22 = '%f '; s23 = '%f '; s24 = '%d '; s25 = '%d ';
  
  format = [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 ...
	    s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 ...
	    s21 s22 s23 s24 s25 ];
  
  [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 ...
   s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 ...
   s21 s22 s23 s24 s25] = textread(filename, format);

  A{1} = s1; A{2} = s2; A{3} = s3; A{4} = s4; A{5} = s5;
  A{6} = s6; A{7} = s7; A{8} = s8; A{9} = s9; A{10} = s10;
  A{11} = s11; A{12} = s12; A{13} = s13; A{14} = s14; A{15} = s15;
  A{16} = s16; A{17} = s17; A{18} = s18; A{19} = s19; A{20} = s20;
  A{21} = s21; A{22} = s22; A{23} = s23; A{24} = s24; A{25} = s25;
  
 else  
  % data format:
  % column  item
  % 
  % 1     - 'time' 
  s1 = '%*f ';
  
  % 2     - 'RightHand_FT_X'
  s2 = '%*f ';
  % 3     - 'RightHand_FT_Y'
  s3 = '%*f ';
  % 4     - 'RightHand_FT_Z'
  s4 = '%*f ';
  % 5     - 'RightHand_FT_H'
  s5 = '%*f ';
  % 6     - 'RightHand_FT_P'
  s6 = '%*f ';
  % 7     - 'RightHand_FT_R'
  s7 = '%*f '; 
 
  
  % 8     - 'LeftHand_FT_X'
  s8 = '%*f ';
  % 9     - 'LeftHand_FT_Y'
  s9 = '%*f ';
  % 10    - 'LeftHand_FT_Z'
  s10 = '%*f ';
  % 11    - 'LeftHand_FT_H'
  s11 = '%*f ';
  % 12    - 'LeftHand_FT_P'
  s12 = '%*f ';
  % 13     - 'LeftHand_FT_R'
  s13 = '%*f '; 
 
  % 14     - 'ScenePlane_X'
  s14 = '%*f ';
  % 15     - 'ScenePlane_Y'
  s15 = '%*f ';
  % 16     - 'asl_pupil'
  s16 = '%*d ';
  % 17     - 'asl_scene_plane'
  s17 = '%*d ';
  
  % 18     - 'fastrak_x'
  s18 = '%*f ';
  % 19     - 'fastrak_y'
  s19 = '%*f ';
  % 20     - 'fastrak_z'
  s20 = '%*f ';
  % 21     - 'fastrak_h'
  s21 = '%*f ';
  % 22     - 'fastrak_p'
  s22 = '%*f ';
  % 23     - 'fastrak_r'
  s23 = '%*f ';

  % 24     - 'asl_h'
  s24 = '%*d ';
  % 25     - 'asl_v'
  s25 = '%*d ';
 
  
  % determine which column to grab
  if(strcmp(option, 'time'))
    s1 = '%f ';
    
  elseif(strcmp(option, 'RightHand_FT_X'))
    s2 = '%f ';
  elseif(strcmp(option, 'RightHand_FT_Y'))
    s3 = '%f ';
  elseif(strcmp(option, 'RightHand_FT_Z'))
    s4 = '%f ';
  elseif(strcmp(option, 'RightHand_FT_H'))
    s5 = '%f ';  
  elseif(strcmp(option, 'RightHand_FT_P'))
    s6 = '%f ';   
  elseif(strcmp(option, 'RightHand_FT_R'))
    s7 = '%f ';
    
  elseif(strcmp(option, 'LeftHand_FT_X'))
    s8 = '%f ';    
  elseif(strcmp(option, 'LeftHand_FT_Y'))
    s9 = '%f ';
  elseif(strcmp(option, 'LeftHand_FT_Z'))
    s10 = '%f ';
  elseif(strcmp(option, 'LeftHand_FT_H'))
    s11 = '%f ';
  elseif(strcmp(option, 'LeftHand_FT_P'))
    s12 = '%f ';
  elseif(strcmp(option, 'LeftHand_FT_R'))
    s13 = '%f ';
    
  elseif(strcmp(option, 'ScenePlane_X'))
    s14 = '%f ';
  elseif(strcmp(option, 'ScenePlane_Y'))
    s15 = '%f ';
  elseif(strcmp(option, 'asl_pupil'))
    s16 = '%d ';
  elseif(strcmp(option, 'asl_scene_plane'))
    s17 = '%d ';
    
  elseif(strcmp(option, 'fastrak_x'))
    s18 = '%f ';
  elseif(strcmp(option, 'fastrak_y'))
    s19 = '%f ';
  elseif(strcmp(option, 'fastrak_z'))
    s20 = '%f ';
  elseif(strcmp(option, 'fastrak_h'))
    s21 = '%f ';
  elseif(strcmp(option, 'fastrak_p'))
    s22 = '%f ';
  elseif(strcmp(option, 'fastrak_r'))
    s23 = '%f ';
    
  elseif(strcmp(option, 'asl_h'))
    s24 = '%f ';
  elseif(strcmp(option, 'asl_v'))
    s25 = '%f ';

  else
    error(['unknown option: ' option]);
  end
  
  format = [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 ...
	    s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 ...
	    s21 s22 s23 s24 s25 s26 s27 s28 s29];     
  
  A =  textread(filename, format);  
end     

 
  