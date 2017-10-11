function h = save_summary(dataFile, single_model, five_model_summary, model_bins, ...
			  model_1_rReach_fixation_summary, model_1_lReach_fixation_summary,...
			  model_2_rReach_fixation_summary, model_2_lReach_fixation_summary,...
			  model_3_rReach_fixation_summary, model_3_lReach_fixation_summary,...
			  model_4_rReach_fixation_summary, model_4_lReach_fixation_summary,...
			  model_5_rReach_fixation_summary, model_5_lReach_fixation_summary,...
			  eye_hand_data, non_action_fix, segment, ...
			  piece1_data, piece2_data, piece3_data, ...
			  piece4_data, area9_data, area10_data, ...
			  head3Mov, head4Mov, filename, head_lah, ...
			  head_norm3, head_norm4, p34_acc)
  
 
  
  %define string on command line?   
  dataFile3 = fopen([dataFile, '.sum3'], 'w'); %list of non-action
                                               %fixation ares  
  dataFile2 = fopen([dataFile, '.sum2'], 'w'); %spss ready format
  acc = fopen([dataFile, '.accuracy'], 'w');
  piece1 = fopen([dataFile, '.piece1'], 'w');
  piece2 = fopen([dataFile, '.piece2'], 'w');
  piece3 = fopen([dataFile, '.piece3'], 'w');
  piece4 = fopen([dataFile, '.piece4'], 'w');
  bolt = fopen([dataFile, '.bolt'], 'w');
  nut = fopen([dataFile, '.nut'], 'w');
  p3head = fopen([dataFile, '.p3.head'], 'w');
  p4head = fopen([dataFile, '.p4.head'], 'w');
  lah_head = fopen([dataFile, '.lah.head'], 'w');
  norm_head3 = fopen([dataFile, '.norm.3.head'], 'w');
  norm_head4 = fopen([dataFile, '.norm.4.head'], 'w');
  dataFile = fopen([dataFile, '.sum'], 'w'); % general summary
  
  fprintf(dataFile, 'Summary of All five models\n');
  fprintf(dataFile, 'Total  LAH  Guiding LB Empty1 Empty2 Full1 Full2\n');
  fprintf(dataFile, '%d %d %d %d %d %d %d %d\n', five_model_summary);

  fprintf(dataFile, '\n\nSummary for each individual model\n');
  fprintf(dataFile, 'Total  LAH  Guiding LB Empty1 Empty2 Full1 Full2\n');
  fprintf(dataFile, '%d %d %d %d %d %d %d %d\n', single_model');

  fprintf(dataFile, '\n\nWork bin and distractor fixations for each individual model\n');
  fprintf(dataFile, 'Look-Aheads Guiding/Grab/Return Look-Backs\n');
  fprintf(dataFile, 'Hand 1 2 3 4 9 10 1 2 3 4 9 10 1 2 3 4 9 10\n');
  fprintf(dataFile, '%c %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n', model_bins');

  %should be a Function!
  fprintf(dataFile, '\n\nSummary of each model for Right/Left Reach fixation Associations\n');
  fprintf(dataFile, 'Model#1_Right\n');
  fprintf(dataFile, 'fix_i fix_f reach# reach_i reach_f bin_i bin_f fix_type grab_time fix#\n');
  fprintf(dataFile, '%8.3f %8.3f %d %8.3f %8.3f %d %d %d %8.3f %d\n', model_1_rReach_fixation_summary');
  fprintf(dataFile, '\n\nModel#1_Left\n');
  fprintf(dataFile, 'fix_i fix_f reach# reach_i reach_f bin_i bin_f fix_type grab_time fix#\n');
  fprintf(dataFile, '%8.3f %8.3f %d %8.3f %8.3f %d %d %d %8.3f %d\n', model_1_lReach_fixation_summary');
 
  fprintf(dataFile, '\n\nModel#2_Right\n');
  fprintf(dataFile, 'fix_i fix_f reach# reach_i reach_f bin_i bin_f fix_type grab_time fix#\n');
   fprintf(dataFile, '%8.3f %8.3f %d %8.3f %8.3f %d %d %d %8.3f %d\n', model_2_rReach_fixation_summary');
   fprintf(dataFile, '\n\nModel#2_Left\n');
   fprintf(dataFile, 'fix_i fix_f reach# reach_i reach_f bin_i bin_f fix_type grab_time fix#\n');
   fprintf(dataFile, '%8.3f %8.3f %d %8.3f %8.3f %d %d %d %8.3f %d\n', model_2_lReach_fixation_summary');
 
   fprintf(dataFile, '\n\nModel#3_Right\n');
   fprintf(dataFile, 'fix_i fix_f reach# reach_i reach_f bin_i bin_f fix_type grab_time fix#\n');
   fprintf(dataFile, '%8.3f %8.3f %d %8.3f %8.3f %d %d %d %8.3f %d\n', model_3_rReach_fixation_summary');
   fprintf(dataFile, '\n\nModel#3_Left\n');
   fprintf(dataFile, 'fix_i fix_f reach# reach_i reach_f bin_i bin_f fix_type grab_time fix#\n');
   fprintf(dataFile, '%8.3f %8.3f %d %8.3f %8.3f %d %d %d %8.3f %d\n', model_3_lReach_fixation_summary');
 
   fprintf(dataFile, '\n\nModel#4_Right\n');
   fprintf(dataFile, 'fix_i fix_f reach# reach_i reach_f bin_i bin_f fix_type grab_time fix#\n');
   fprintf(dataFile, '%8.3f %8.3f %d %8.3f %8.3f %d %d %d %8.3f %d\n', model_4_rReach_fixation_summary');
   fprintf(dataFile, '\n\nModel#4_Left\n');
   fprintf(dataFile, 'fix_i fix_f reach# reach_i reach_f bin_i bin_f fix_type grab_time fix#\n');
   fprintf(dataFile, '%8.3f %8.3f %d %8.3f %8.3f %d %d %d %8.3f %d\n', model_4_lReach_fixation_summary');
 
   fprintf(dataFile, '\n\nModel#5_Right\n');
   fprintf(dataFile, 'fix_i fix_f reach# reach_i reach_f bin_i bin_f fix_type grab_time fix#\n');
   fprintf(dataFile, '%8.3f %8.3f %d %8.3f %8.3f %d %d %d %8.3f %d\n', model_5_rReach_fixation_summary');
   fprintf(dataFile, '\n\nModel#5_Left\n');
   fprintf(dataFile, 'fix_i fix_f reach# reach_i reach_f bin_i bin_f fix_type grab_time fix#\n');
   fprintf(dataFile, '%8.3f %8.3f %d %8.3f %8.3f %d %d %d %8.3f %d\n', model_5_lReach_fixation_summary');
 
   %keyboard
   
   %datafile one contains the majority of the data in several forms
    fprintf(dataFile, 'Mod_Num Hand Area_I Area_f Reach_Num Reach_I Reach_F Reach_Dur Num_Guiding Saccade_I Guiding_I Guiding_F Num_Irrelevant Guide_Dur GuidSac_DUR Irrel_FixDur Irrel_SacDur D D2 Num_Lah Lah_I Lah_F Lah_Dur T plah_i plah_f plah_dur T2 pu_connect\n');      
 	%                   1  2  3  4  5     6     7     8  9   10    11   12  13   14   15   16        17   18     19  20   21   22   23      24   25   26    27   28   29
	fprintf(dataFile,'%d %c %d %d %d %8.3f %8.3f %8.3f %d %8.3f %8.3f %8.3f %d %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %d %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %d\n', eye_hand_data');
   segment2 = [segment segment(:,2) - segment(:,1)];
   fprintf(dataFile, '\nMod_Begin Mod_End Mod_Dur\n');
   fprintf(dataFile, '%8.3f %8.3f %8.3f\n', segment2');
   
   
  
  %this contains a list of where the eyes fixated during guiding looks
  fprintf(dataFile3, 'Mod# Hand Reach# Area #RelFix #IrrelFix\n');
  fprintf(dataFile3, '%d %c %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n', non_action_fix');
  
  
  %this has the same last part as the main sum file but is in a
  %consistent format for a spreadsheet program
  fprintf(dataFile2, 'Mod_Num Hand Area_I Area_f Reach_Num Reach_I Reach_F Reach_Dur Num_Guiding Saccade_I Guiding_I Guiding_F Num_Irrelevant Guide_Dur GuidSac_Dur Irrel_FixDur Irrel_SacDur D D2 Num_Lah Lah_I Lah_F Lah_Dur T plah_i plah_f plah_dur T2 pu_connect\n');      
	
  fprintf(dataFile2, '%d %c %d %d %d %8.3f %8.3f %8.3f %d %8.3f %8.3f %8.3f %d %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %d %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %d\n', eye_hand_data');  
		    
  

  %filter out pieces so that zero entries aren't so populous
  piece1_data = piece1_data(find(piece1_data(:,5)), :);
  piece2_data = piece2_data(find(piece2_data(:,5)), :);
  piece3_data = piece3_data(find(piece3_data(:,5)), :);
  piece4_data = piece4_data(find(piece4_data(:,5)), :);
  area10_data = area10_data(find(area10_data(:,5)), :);
  area9_data = area9_data(find(area9_data(:,5)), :);
  
 
  fprintf(piece1, 'Mod# Hand LAH Guide Reach_dur T maxVel meanVel maxAccel\n');
  fprintf(piece1, '%d %c %d %d %8.3f %8.3f %8.3f %8.3f %8.3f\n', ...
	  piece1_data');
  
  fprintf(piece2, 'Mod# Hand LAH Guide Reach_dur T maxVel meanVel maxAccel\n');
  fprintf(piece2, '%d %c %d %d %8.3f %8.3f %8.3f %8.3f %8.3f\n', piece2_data');
 
  fprintf(piece3, 'Mod# Hand LAH Guide Reach_dur T maxVel meanVel maxAccel\n');
  fprintf(piece3, '%d %c %d %d %8.3f %8.3f %8.3f %8.3f %8.3f\n', piece3_data');
  
  fprintf(piece4, 'Mod# Hand LAH Guide Reach_dur T maxVel meanVel maxAccel\n');
  fprintf(piece4, '%d %c %d %d %8.3f %8.3f %8.3f %8.3f %8.3f\n', piece4_data');
  
  fprintf(nut, 'Mod# Hand LAH Guide Reach_dur T maxVel meanVel maxAccel\n');
  fprintf(nut,    '%d %c %d %d %8.3f %8.3f %8.3f %8.3f %8.3f\n', area10_data');
  
  fprintf(bolt, 'Mod# Hand LAH Guide Reach_dur T maxVel meanVel maxAccel\n');
  fprintf(bolt,   '%d %c %d %d %8.3f %8.3f %8.3f %8.3f %8.3f\n', area9_data');
  
  %print out list with head movements
  fprintf(p4head, 'name mod_num hand reach_i reach_f lah T saccade_i guide_f head_i head_f hand_eye_T hand_head_T head_eye_T lah_head_i lah_head_f lah_i lah_f lah_head_eye_T \n');
		   
for i = 1:size(head4Mov,1)
  fprintf(p4head,'%s %d %c %8.3f %8.3f %d %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f\n', filename,head4Mov(i,:)');
end
		   
fprintf(p3head, 'name mod_num hand reach_i reach_f lah T saccade_i guide_f head_i head_f hand_eye_T hand_head_T head_eye_T lah_head_i lah_head_f lah_i lah_f lah_head_eye_T \n');
				    
for i = 1:size(head3Mov,1)    
		   fprintf(p3head,'%s %d %c %8.3f %8.3f %d %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f\n', filename,head3Mov(i,:)');
end

for i = 1:size(head_lah,1)    
		   fprintf(lah_head,'%s %d %d %c %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f\n', filename, head_lah(i,:)');
end


head_norm3 = head_norm3(find(head_norm3(:,1)), :);
head_norm4 = head_norm4(find(head_norm4(:,1)), :);


for i = 1:size(head_norm3,1)    
		   fprintf(norm_head3,'%s %d %d %c %8.3f %8.3f %8.3f\n', filename, head_norm3(i,:)');
end

for i = 1:size(head_norm4,1)    
		   fprintf(norm_head4,'%s %d %d %c %8.3f %8.3f %8.3f\n', filename, head_norm4(i,:)');
end


for i = 1:size(p34_acc,1)    
		   fprintf(acc,'%s %d %d %c %8.3f %d %d %8.3f %8.3f %8.3f %d %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f\n', filename, p34_acc(i,:)');
end


% keyboard

  piece1 = fclose(piece1);
  piece2 = fclose(piece2);
  piece3 = fclose(piece3);
  piece4 = fclose(piece4);
  acc = fclose(acc);
  nut = fclose(nut);
  bolt = fclose(bolt);
  p4head = fclose(p4head);
  p3head = fclose(p3head);
  lah_head = fclose(lah_head);
  norm_head3 = fclose(norm_head3);
  norm_head4 = fclose(norm_head4);
  dataFile = fclose(dataFile);
  dataFile2 = fclose(dataFile2);
  dataFile3 = fclose(dataFile3);
  
  











