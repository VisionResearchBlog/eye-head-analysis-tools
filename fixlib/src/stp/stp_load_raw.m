function A = stp_load_raw(filename)

% take all columns
  s1 = '%s '; s2 = '%d '; s3 = '%d '; s4 = '%d '; s5 = '%f ';
  
  format = [s1 s2 s3 s4 s5];
  
  [s1 s2 s3 s4 s5] = textread(filename, format, 'headerlines', 1);

  A{1} = s1; A{2} = s2; A{3} = s3; A{4} = s4; A{5} = s5;

  
  format = [s1 s2 s3 s4 s5 ];
  A =  textread(filename, format, 'headerlines', 1);
end



       

         

