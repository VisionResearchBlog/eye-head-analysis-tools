%CBA_LOAD_DATA load data from a change blindness ".data" file
%   ALL = CBA_LOAD_DATA(FILENAME, 'all') loads all the data from
%   FILENAME and places the result in ALL, which is a 1D cell-array
%   with 1 cell per column, in the original order.
%
%   ANS = CBA_LOAD_DATA(FILENAME, OPTION) loads one column of
%   data from FILENAME and places the result in the vector ANS
%   (ANS is a 1D cell array if the column contains string values).
%
%   FILENAME must be a ".data" file which is produced by running
%   the helper program "cba_converter" on the original ".dat" file
%
%   OPTION can be one of the following (the order is the same as in
%   the data file):
%
%          1. 'tag' (for a ".data" file, this is always "data") 
%          2. 'time'
%
%          3. 'phantom_left_x' 
%          4. 'phantom_left_y
%          5. 'phantom_left_z'
%
%          6. 'phantom_right_x'
%          7. 'phantom_right_y'
%          8. 'phantom_right_z'
%
%          9.  'fastrak_x'
%          10. 'fastrak_y'
%          11. 'fastrak_z'
%          12. 'fastrak_h'
%          13. 'fastrak_p'
%          14. 'fastrak_r'
%
%          15. 'asl_pupil'
%          16. 'asl_h'
%          17. 'asl_v'
%
%          18. 'touched_object_id'
%
%          19. 'pos_x'
%          20. 'pos_y'
%          21. 'pos_z'
%
%          22. 'size'
%          23. 'color'
%
%          24. 'phantom_left_fx' 
%          25. 'phantom_left_fy
%          26. 'phantom_left_fz'
%
%          27. 'phantom_right_fx'
%          28. 'phantom_right_fy'
%          29. 'phantom_right_fz'

% $Id: cba_load_data.m,v 1.2 2001/07/19 15:17:47 pskirko Exp $
% pskirko 6.4.01

function A = cba_load_data(filename, option)

if(strcmp(option, 'all'))
  s1 = '%s '; s2 = '%f '; s3 = '%d '; s4 = '%d '; s5 = '%d ';
  s6 = '%d '; s7 = '%d '; s8 = '%d '; s9 = '%d '; s10 = '%d ';
  s11 = '%d '; s12 = '%d '; s13 = '%d '; s14 = '%d '; s15 = '%d ';
  s16 = '%d '; s17 = '%d '; s18 = '%d '; s19 = '%d '; s20 = '%d ';
  s21 = '%d '; s22 = '%d '; s23 = '%s '; s24 = '%f '; s25 = '%f ';
  s26 = '%f '; s27 = '%f '; s28 = '%f '; s29 = '%f';
  
  format = [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 ...
	    s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 ...
	    s21 s22 s23 s24 s25 s26 s27 s28 s29];
  
  [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 ...
   s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 ...
   s21 s22 s23 s24 s25 s26 s27 s28 s29] = textread(filename, format);

  A{1} = s1; A{2} = s2; A{3} = s3; A{4} = s4; A{5} = s5;
  A{6} = s6; A{7} = s7; A{8} = s8; A{9} = s9; A{10} = s10;
  A{11} = s11; A{12} = s12; A{13} = s13; A{14} = s14; A{15} = s15;
  A{16} = s16; A{17} = s17; A{18} = s18; A{19} = s19; A{20} = s20;
  A{21} = s21; A{22} = s22; A{23} = s23; A{24} = s24; A{25} = s25;
  A{26} = s26; A{27} = s27; A{28} = s28; A{29} = s29; 

else  
  % data format:
  % column  item
  % 
  % 1     - data tag 
  s1 = '%*s ';
  % 2     - time
  s2 = '%*f ';
  % 3     - phantom left x
  s3 = '%*d ';
  % 4     - phantom left y
  s4 = '%*d ';
  % 5     - phantom left z
  s5 = '%*d ';
  % 6     - phantom right x
  s6 = '%*d ';
  % 7     - phantom right y
  s7 = '%*d ';
  % 8     - phantom right z
  s8 = '%*d ';
  % 9     - fastrak x
  s9 = '%*d ';
  % 10     - fastrak y
  s10 = '%*d ';
  % 11     - fastrak z
  s11 = '%*d ';
  % 12     - fastrak h
  s12 = '%*d ';
  % 13     - fastrak p
  s13 = '%*d ';
  % 14     - fastrak r
  s14 = '%*d ';
  % 15     - asl pupil
  s15 = '%*d ';
  % 16     - asl horz
  s16 = '%*d ';
  % 17     - asl vert
  s17 = '%*d ';
  % 18     - touched obj number
  s18 = '%*d ';

  % "optional params" -- they are always included in .data file

  % 19     - pos x
  s19 = '%*d ';
  % 20     - pos y
  s20 = '%*d ';
  % 21     - pos z
  s21 = '%*d ';
  % 22     - size
  s22 = '%*d ';
  % 23     - color
  s23 = '%*s ';

  % 24     - phantom left fx
  s24 = '%*f ';
  % 25     - phantom left fy
  s25 = '%*f ';
  % 26     - phantom left fz
  s26 = '%*f ';
  % 27     - phantom right fx
  s27 = '%*f ';
  % 28     - phantom right fy
  s28 = '%*f ';
  % 29     - phantom right fz
  s29 = '%*f ';
  
  % determine which column to grab
  if(strcmp(option, 'tag'))
    s1 = '%s ';
  elseif(strcmp(option, 'time'))
    s2 = '%f ';
  elseif(strcmp(option, 'phantom_left_x'))
    s3 = '%d ';
  elseif(strcmp(option, 'phantom_left_y'))
    s4 = '%d ';
  elseif(strcmp(option, 'phantom_left_z'))
    s5 = '%d ';  
  elseif(strcmp(option, 'phantom_right_x'))
    s6 = '%d ';   
  elseif(strcmp(option, 'phantom_right_y'))
    s7 = '%d ';
  elseif(strcmp(option, 'phantom_right_z'))
    s8 = '%d ';    
  elseif(strcmp(option, 'fastrak_x'))
    s9 = '%d ';
  elseif(strcmp(option, 'fastrak_y'))
    s10 = '%d ';
  elseif(strcmp(option, 'fastrak_z'))
    s11 = '%d ';
  elseif(strcmp(option, 'fastrak_h'))
    s12 = '%d ';
  elseif(strcmp(option, 'fastrak_p'))
    s13 = '%d ';
  elseif(strcmp(option, 'fastrak_r'))
    s14 = '%d ';
  elseif(strcmp(option, 'asl_pupil'))
    s15 = '%d ';
  elseif(strcmp(option, 'asl_h'))
    s16 = '%d ';
  elseif(strcmp(option, 'asl_v'))
    s17 = '%d ';
  elseif(strcmp(option, 'touched_object_id'))
    s18 = '%d ';
  elseif(strcmp(option, 'pos_x'))
    s19 = '%d ';
  elseif(strcmp(option, 'pos_y'))
    s20 = '%d ';
  elseif(strcmp(option, 'pos_z'))
    s21 = '%d ';
  elseif(strcmp(option, 'size'))
    s22 = '%d ';
  elseif(strcmp(option, 'color'))
    s23 = '%s ';
  elseif(strcmp(option, 'phantom_left_fx'))
    s24 = '%f ';
  elseif(strcmp(option, 'phantom_left_fy'))
    s25 = '%f ';
  elseif(strcmp(option, 'phantom_left_fz'))
    s26 = '%f ';  
  elseif(strcmp(option, 'phantom_right_fx'))
    s27 = '%f ';   
  elseif(strcmp(option, 'phantom_right_fy'))
    s28 = '%f ';
  elseif(strcmp(option, 'phantom_right_fz'))
    s29 = '%f';     
  else
    error(['unknown option: ' option]);
  end
  
  format = [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 ...
	    s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 ...
	    s21 s22 s23 s24 s25 s26 s27 s28 s29];     
  
  A =  textread(filename, format);  
end     

