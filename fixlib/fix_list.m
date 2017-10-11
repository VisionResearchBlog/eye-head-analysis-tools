%fix_list generates text files of durations for entire subject sets
filelist = {

'HC_121302.control.join.1.3algs.mat' 'HC_121302_control_join_1_dat.mat';
'HC_121302.control.join.2.3algs.mat' 'HC_121302_control_join_2_dat.mat';
'HC_121302.control.join.3.3algs.mat' 'HC_121302_control_join_3_dat.mat';
'HC_121302.exp.1.3algs.mat' 'HC_121302_exp_1_dat.mat';
'HC_121302.exp.2.3algs.mat' 'HC_121302_exp_2_dat.mat';
'HC_121302.exp.3.3algs.mat' 'HC_121302_exp_3_dat.mat';
'JF_022603.control.1.3algs.mat' 'JF_022603_control_1_dat.mat';
'JF_022603.control.2.3algs.mat' 'JF_022603_control_2_dat.mat';
'JF_022603.control.3.3algs.mat' 'JF_022603_control_3_dat.mat';
'JF_022603.exp.1.3algs.mat' 'JF_022603_exp_1_dat.mat';
'JF_022603.exp.2.3algs.mat' 'JF_022603_exp_2_dat.mat';
'JF_022603.exp.3.3algs.mat' 'JF_022603_exp_3_dat.mat';
'JK_22103.control.1.3algs.mat' 'JK_22103_control_1_dat.mat';
'JK_22103.control.2.3algs.mat' 'JK_22103_control_2_dat.mat';
'JK_22103.control.3.3algs.mat' 'JK_22103_control_3_dat.mat';
'JK_22103.exp.1b.3algs.mat' 'JK_22103_exp_1b_dat.mat';
'JK_22103.exp.2.3algs.mat' 'JK_22103_exp_2_dat.mat';
'JK_22103.exp.3.3algs.mat' 'JK_22103_exp_3_dat.mat';
'JR_121702.control.join.1.3algs.mat' 'JR_121702_control_join_1_dat.mat';
'JR_121702.control.join.2.3algs.mat' 'JR_121702_control_join_2_dat.mat';
'JR_121702.control.join.3.3algs.mat' 'JR_121702_control_join_3_dat.mat';
'JR_121702.exp.1.3algs.mat' 'JR_121702_exp_1_dat.mat';
'JR_121702.exp.2.3algs.mat' 'JR_121702_exp_2_dat.mat';
'JR_121702.exp.3.3algs.mat' 'JR_121702_exp_3_dat.mat';
'JS_030503.control.1.3algs.mat' 'JS_030503_control_1_dat.mat';
'JS_030503.control.2.3algs.mat' 'JS_030503_control_2_dat.mat';
'JS_030503.exp.2.3algs.mat' 'JS_030503_exp_2_dat.mat'; 
'JS_030503.exp.3.3algs.mat' 'JS_030503_exp_3_dat.mat'; 
'KC_022403.control.1.3algs.mat' 'KC_022403_control_1_dat.mat' 
'KC_022403.control.2.3algs.mat' 'KC_022403_control_2_dat.mat'; 
'KC_022403.control.3.3algs.mat' 'KC_022403_control_3_dat.mat';
'KC_022403_exp_2_dat.mat' 'KC_022403.exp.2.3algs.mat';
'KC_022403_exp_3_dat.mat' 'KC_022403.exp.3.3algs.mat';
'KC_022403_exp_4_dat.mat' 'KC_022403.exp.4.3algs.mat';
'KD_121002.control.1.join.3algs.mat' 'KD_121002_control_1_join_dat.mat';
'KD_121002.control.2.join.3algs.mat' 'KD_121002_control_2_join_dat.mat';
'KD_121002.control.3.join.3algs.mat' 'KD_121002_control_3_join_dat.mat';
'KD_121002.exp.1.3algs.mat' 'KD_121002_exp_1_dat.mat';
'KD_121002.exp.2.3algs.mat' 'KD_121002_exp_2_dat.mat';
'KD_121002.exp.3.3algs.mat' 'KD_121002_exp_3_dat.mat';
'LK_121202.control.join.2.3algs.mat' 'LK_121202_control_join_2_dat.mat';
'LK_121202.control.join.3.3algs.mat' 'LK_121202_control_join_3_dat.mat'
'LK_121202.control.join.3algs.mat' 'LK_121202_control_join_dat.mat';
'LK_121202.exp.1.3algs.mat' 'LK_121202_exp_1_dat.mat';
'LK_121202.exp.2.3algs.mat' 'LK_121202_exp_2_dat.mat';
'LK_121202.exp.3.3algs.mat' 'LK_121202_exp_3_dat.mat';
'MA_022703.control.1.3algs.mat' 'MA_022703_control_1_dat.mat';
'MA_022703.control.2.3algs.mat' 'MA_022703_control_2_dat.mat';
'MA_022703.control.3.3algs.mat' 'MA_022703_control_3_dat.mat';
'MA_022703.exp.1.3algs.mat' 'MA_022703_exp_1_dat.mat';
'MA_022703_exp_3_dat.mat' 'MA_022703.exp.3.3algs.mat'; 
'MD_121102_control.1.join.3algs.mat' 'MD_121102_control_1_join_dat.mat';
'MD_121102_control.2.join.3algs.mat' 'MD_121102_control_2_join_dat.mat';
'MD_121102_control.3.join.3algs.mat' 'MD_121102_control_3_join_dat.mat';
'MD_121102.exp.1.3algs.mat' 'MD_121102_exp_1_dat.mat';
'MD_121102.exp.2.3algs.mat' 'MD_121102_exp_2_dat.mat';
'MD_121102.exp.3.3algs.mat' 'MD_121102_exp_3_dat.mat';
'RF_022703.control.1.3algs.mat' 'RF_022703_control_1_dat.mat';
'RF_022703.control.2.3algs.mat' 'RF_022703_control_2_dat.mat';
'RF_022703.control.3.3algs.mat' 'RF_022703_control_3_dat.mat';
'RF_022703.exp.1.3algs.mat' 'RF_022703_exp_1_dat.mat';
'RF_022703.exp.2.3algs.mat' 'RF_022703_exp_2_dat.mat';
'RF_022703.exp.3.3algs.mat' 'RF_022703_exp_3_dat.mat';    
    };


binSizeX = 330; binSizeY = 180;

for i = 1:length(filelist)
  clear fix_mid fix_hi fix_low vel_fix adap_vel_fix hmm_fix binEyeHV;
  clear label_low label_mid label_hi label_hmm label_vel label_avel;
  clear low_bin mid_bin hi_bin hmm_bin vel_bin avel_bin;
  
  filelist{i, 1}
  
  load(filelist{i, 1});  load(filelist{i, 2});
  
  [label_low low_bin]   = label_bins(binEyeHV, fix_low_frames, binSizeX, binSizeY);
  [label_mid mid_bin]   = label_bins(binEyeHV, fix_mid_frames, binSizeX, binSizeY);
  [label_hi  hi_bin ]   = label_bins(binEyeHV, fix_hi_frames,  binSizeX, binSizeY);
  [label_hmm hmm_bin]   = label_bins(binEyeHV, hmm_fix_frames, binSizeX, binSizeY);
  [label_vel vel_bin]   = label_bins(binEyeHV, vel_fix_frames, binSizeX, binSizeY);
  [label_avel avel_bin] = label_bins(binEyeHV, adap_vel_fix_frames, binSizeX, binSizeY);

  fix_low = [fix_low label_low];
  fix_mid = [fix_mid label_mid];
  fix_hi  = [fix_hi label_hi]; 
  hmm_fix = [hmm_fix label_hmm];
  vel_fix = [vel_fix label_vel];
  adap_vel_fix = [adap_vel_fix label_avel];


  if (i == 1)
  fixlist1 = fix_mid(:,2) - fix_mid(:,1); 
  fixlist2 = fix_hi(:,2) - fix_hi(:,1);  
  fixlist3 = fix_low(:,2) - fix_low(:,1); 
  fixlist4 = hmm_fix(:,2) - hmm_fix(:,1); 
  fixlist5 = adap_vel_fix(:,2) - adap_vel_fix(:,1);  
  fixlist6 = vel_fix(:,2) - vel_fix(:,1); 
  binlist1 = low_bin; 
  binlist2 = mid_bin; 
  binlist3 = hi_bin; 
  binlist4 = hmm_bin; 
  binlist5 = vel_bin; 
  binlist6 = avel_bin;
    
  else
  fixlist1 = [fixlist1; fix_mid(:,2) - fix_mid(:,1);];
  fixlist2 = [fixlist2; fix_hi(:,2) - fix_hi(:,1);];  
  fixlist3 = [fixlist3; fix_low(:,2) - fix_low(:,1);]; 
  fixlist4 = [fixlist4; hmm_fix(:,2) - hmm_fix(:,1);];
  fixlist5 = [fixlist5; adap_vel_fix(:,2) - adap_vel_fix(:,1);];  
  fixlist6 = [fixlist6; vel_fix(:,2) - vel_fix(:,1);]; 
  binlist1 = binlist1 + low_bin; 
  binlist2 = binlist2 + mid_bin; 
  binlist3 = binlist3 + hi_bin; 
  binlist4 = binlist4 + hmm_bin; 
  binlist5 = binlist5 + vel_bin; 
  binlist6 = binlist6 + avel_bin;
  end
  
  
  end

  list1 = fopen('fix_mid_list.txt', 'w');
  fprintf(list1, '%8.4f\n', fixlist1);
  
  list2 = fopen('fix_hi_list.txt', 'w');
  fprintf(list2, '%8.4f\n', fixlist2);
  
  list3 = fopen('fix_low_list.txt', 'w');
  fprintf(list3, '%8.4f\n', fixlist3);
  
  list4 = fopen('hmm_fix_list.txt', 'w');
  fprintf(list4, '%8.4f\n', fixlist4);
  
  list5 = fopen('adap_vel_fix_list.txt', 'w');
  fprintf(list5, '%8.4f\n', fixlist5); 
  
  list6 = fopen('vel_fix_list.txt', 'w');
  fprintf(list6, '%8.4f\n', fixlist6);

  
    low_bin_list = binlist1
    mid_bin_list = binlist2  
     hi_bin_list = binlist3  
    hmm_bin_list = binlist4  
    vel_bin_list = binlist5  
   avel_bin_list = binlist6
   