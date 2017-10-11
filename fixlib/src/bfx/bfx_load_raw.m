%BFX_LOAD_RAW load data from a baufix ".dat" raw data file
%   ALL = BFX_LOAD_RAW(FILENAME, 'all') loads all the data from
%   FILENAME and places the result in ALL, which is a 1D cell-array
%   with 1 cell per column, in the original order.
%
%   ANS = BFX_LOAD_RAW(FILENAME, OPTION) loads one column of
%   data from FILENAME and places the result in the vector ANS
%   (ANS is a 1D cell array if the column contains string values).
%
%   FILENAME is assumed to be a corrected raw ".dat" raw data file,   
%   that is, to have the correct head_h and eye/gaze angles. If
%   not, run bfx_anglefix to correct the data.  
%
%   The first line is discarded as a header line.
%
%   OPTION can be one of the following (the order is the same as in
%   the data file):
%
%          1. 'time'
%
%          2. 'head_x'
%          3. 'head_y'
%          4. 'head_z'
%          5. 'head_h'
%          6. 'head_p'
%          7. 'head_r'
%
%          8.  'hand_x'
%          9.  'hand_y'
%          10. 'hand_z'
%          11. 'hand_h'
%          12. 'hand_p'
%          13. 'hand_r'
%
%          14. 'asl_h'
%          15. 'asl_v'
%          16. 'asl_pupil'
%
%          17. 'eih_h'
%          18. 'eih_v'
%
%          19. 'gaze_h'
%          20. 'gaze_v'
%
%          21. 'look_area' 
%          22. 'event'
%          23. 'event_param'

%  $Id: bfx_load_raw.m,v 1.2 2001/07/19 15:11:32 pskirko Exp $
%  pskirko 6.4.01

function A = bfx_load_raw(filename, option)

if(strcmp(option, 'all')) % take all columns
  s1 = '%d '; s2 = '%f '; s3 = '%f '; s4 = '%f '; s5 = '%f ';
  s6 = '%f '; s7 = '%f '; s8 = '%f '; s9 = '%f '; s10 = '%f ';
  s11 = '%f '; s12 = '%f '; s13 = '%f '; s14 = '%d '; s15 = '%d ';
  s16 = '%d '; s17 = '%f '; s18 = '%f '; s19 = '%f '; s20 = '%f ';
  s21 = '%s '; s22 = '%s '; s23 = '%s';
  
  format = [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 ...
	    s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 ...
	    s21 s22 s23];
  
  [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 ...
   s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 ...
   s21 s22 s23] = textread(filename, format, 'headerlines', 1);

  A{1} = s1; A{2} = s2; A{3} = s3; A{4} = s4; A{5} = s5;
  A{6} = s6; A{7} = s7; A{8} = s8; A{9} = s9; A{10} = s10;
  A{11} = s11; A{12} = s12; A{13} = s13; A{14} = s14; A{15} = s15;
  A{16} = s16; A{17} = s17; A{18} = s18; A{19} = s19; A{20} = s20;
  A{21} = s21; A{22} = s22; A{23} = s23;

else
  % data format:
  % column   item
  % 
  % 1     - time 
  s1 = '%*d ';
  % 2     - xhel
  s2 = '%*f ';
  % 3     - yhel
  s3 = '%*f ';
  % 4     - zhel
  s4 = '%*f ';
  % 5     - hhel
  s5 = '%*f ';
  % 6     - phel
  s6 = '%*f ';
  % 7     - rhel
  s7 = '%*f ';
  % 8     - xhan
  s8 = '%*f ';
  % 9     - yhan
  s9 = '%*f ';
  % 10    - zhan
  s10 = '%*f ';
  % 11    - hhan 
  s11 = '%*f ';
  % 12    - phan
  s12 = '%*f ';
  % 13    - rhan
  s13 = '%*f ';
  % 14    - eye-H
  s14 = '%*d ';
  % 15    - eye-V
  s15 = '%*d ';
  % 16    - eye-pupil
  s16 = '%*d ';
  % 17    - hor_angle
  s17 = '%*f ';
  % 18    - vert_angle
  s18 = '%*f ';
  % 19    - gaze_h
  s19 = '%*f '; 
  % 20    - gaze_v
  s20 = '%*f ';
  % 21    - Look Area string
  s21 = '%*s ';
  % 22    - Event string
  s22 = '%*s ';
  % 23    - Event Param string
  s23 = '%*s';
   
  if(strcmp(option, 'time'))
    s1 = '%d ';
  elseif(strcmp(option, 'head_x'))
    s2 = '%f ';
  elseif(strcmp(option, 'head_y'))
    s3 = '%f ';
  elseif(strcmp(option, 'head_z'))
    s4 = '%f ';
  elseif(strcmp(option, 'head_h'))
    s5 = '%f ';
  elseif(strcmp(option, 'head_p'))
    s6 = '%f ';
  elseif(strcmp(option, 'head_r'))
    s7 = '%f ';
  elseif(strcmp(option, 'hand_x'))
    s8 = '%f ';
  elseif(strcmp(option, 'hand_y'))
    s9 = '%f ';
  elseif(strcmp(option, 'hand_z'))
    s10 = '%f ';
  elseif(strcmp(option, 'hand_h'))
    s11 = '%f ';
  elseif(strcmp(option, 'hand_p'))
    s12 = '%f ';
  elseif(strcmp(option, 'hand_r'))
    s13 = '%f ';
  elseif(strcmp(option, 'asl_h'))
    s14 = '%d '; 
  elseif(strcmp(option, 'asl_v'))
    s15 = '%d ';
  elseif(strcmp(option, 'asl_pupil'))
    s16 = '%d ';
  elseif(strcmp(option, 'eih_h'))
    s17 = '%f ';
  elseif(strcmp(option, 'eih_v'))
    s18 = '%f ';
  elseif(strcmp(option, 'gaze_h'))
    s19 = '%f ';
  elseif(strcmp(option, 'gaze_v'))
    s20 = '%f ';
  elseif(strcmp(option, 'look_area'))
    s21 = '%s ';
  elseif(strcmp(option, 'event'))
    s22 = '%s '; 
  elseif(strcmp(option, 'event_param'))
    s23 = '%s ';    
  else
    error(['unknown option: ' option]);
  end
  
  format = [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 ...
	    s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 ...
	    s21 s22 s23];     
  
  A =  textread(filename, format, 'headerlines', 1);
end



       

         

