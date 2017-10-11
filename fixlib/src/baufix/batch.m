 
%batch_fix_finder.m - Allows one to run a group of
%data files in the fixation finder simply edit
%batch_fix_finder.m adding the files you want to
%analyze by following the template listed above the
%the filename cell array:


%fix_finder.m Matlab Command line invocation: 
%fix_finder('experiment_type', method, vel_thresh, t_thresh, clump_space_thresh, clump_t_thresh, viz_results, 'datafilename')

function h = batch 
 
 filelist = { 

%     'HC_121302_control_join_1_dat.mat', 'HC_121302.control.join.1.3algs.mat'...    
   'HC_121302_control_join_2_dat.mat', 'HC_121302.control.join.2.3algs.mat'...
%   'HC_121302_control_join_3_dat.mat', 'HC_121302.control.join.3.3algs.mat';
%   
%      'HC_121302_exp_1_dat.mat', 'HC_121302.exp.1.3algs.mat'...
%         'HC_121302_exp_2_dat.mat', 'HC_121302.exp.2.3algs.mat'... 
%         'HC_121302_exp_3_dat.mat', 'HC_121302.exp.3.3algs.mat';
%   
%          'JR_121702_control_join_1_dat.mat', 'JR_121702.control.join.1.3algs.mat'...    
      'JR_121702_control_join_2_dat.mat','JR_121702.control.join.2.3algs.mat'... 
%      'JR_121702_control_join_3_dat.mat', 'JR_121702.control.join.3.3algs.mat';
%   
%       'JR_121702_exp_1_dat.mat', 'JR_121702.exp.1.3algs.mat'...
%      'JR_121702_exp_2_dat.mat', 'JR_121702.exp.2.3algs.mat'... 
%      'JR_121702_exp_3_dat.mat', 'JR_121702.exp.3.3algs.mat'; 
%   
%       'KD_121002_control_1_join_dat.mat', 'KD_121002.control.1.join.3algs.mat'...
      'KD_121002_control_2_join_dat.mat', 'KD_121002.control.2.join.3algs.mat'... %145
%      'KD_121002_control_3_join_dat.mat', 'KD_121002.control.3.join.3algs.mat'; %180
%   
%       'KD_121002_exp_1_dat.mat', 'KD_121002.exp.1.3algs.mat'...
%      'KD_121002_exp_2_dat.mat', 'KD_121002.exp.2.3algs.mat'...
%      'KD_121002_exp_3_dat.mat', 'KD_121002.exp.3.3algs.mat'; %180
%   
%       'LK_121202_control_join_2_dat.mat', 'LK_121202.control.join.2.3algs.mat'...
       'LK_121202_control_join_3_dat.mat','LK_121202.control.join.3.3algs.mat'...
%       'LK_121202_control_join_dat.mat','LK_121202.control.join.3algs.mat'; %140
%   
%       'LK_121202_exp_1_dat.mat', 'LK_121202.exp.1.3algs.mat'...
%      'LK_121202_exp_2_dat.mat', 'LK_121202.exp.2.3algs.mat'...
%      'LK_121202_exp_3_dat.mat', 'LK_121202.exp.3.3algs.mat';
%   
%       'MD_121102_control_1_join_dat.mat', 'MD_121102_control.1.join.3algs.mat'...
      'MD_121102_control_2_join_dat.mat', 'MD_121102_control.2.join.3algs.mat'...
%      'MD_121102_control_3_join_dat.mat','MD_121102_control.3.join.3algs.mat';
%   
%       'MD_121102_exp_1_dat.mat', 'MD_121102.exp.1.3algs.mat'...
%      'MD_121102_exp_2_dat.mat', 'MD_121102.exp.2.3algs.mat'...
%      'MD_121102_exp_3_dat.mat', 'MD_121102.exp.3.3algs.mat'; %150    
%   
%       'JF_022603_control_1_dat.mat', 'JF_022603.control.1.3algs.mat'...  
      'JF_022603_control_2_dat.mat',  'JF_022603.control.2.3algs.mat'...  
%      'JF_022603_control_3_dat.mat',  'JF_022603.control.3.3algs.mat';  
%   
%       'JF_022603_exp_1_dat.mat',      'JF_022603.exp.1.3algs.mat'...  
%      'JF_022603_exp_2_dat.mat',      'JF_022603.exp.2.3algs.mat'...  %150
%      'JF_022603_exp_3_dat.mat',      'JF_022603.exp.3.3algs.mat';    
%   
%       'KC_022403_control_1_dat.mat',  'KC_022403.control.1.3algs.mat'...  
      'KC_022403_control_2_dat.mat',  'KC_022403.control.2.3algs.mat'...  
%      'KC_022403_control_3_dat.mat',  'KC_022403.control.3.3algs.mat';  
%   
%    %%%   'KC_022403_exp_1_dat.mat',      'KC_022403.exp.1.3algs.mat'...  
%     'KC_022403_exp_2_dat.mat',      'KC_022403.exp.2.3algs.mat'...  
%      'KC_022403_exp_3_dat.mat',      'KC_022403.exp.3.3algs.mat'... 
%      'KC_022403_exp_4_dat.mat',      'KC_022403.exp.4.3algs.mat';
%        
%      'RF_022703_control_1_dat.mat',   'RF_022703.control.1.3algs.mat'...   
%      'RF_022703_control_2_dat.mat',   'RF_022703.control.2.3algs.mat'...  
%      'RF_022703_control_3_dat.mat',   'RF_022703.control.3.3algs.mat';
%   
%      'RF_022703_exp_1_dat.mat',       'RF_022703.exp.1.3algs.mat'... 
%      'RF_022703_exp_2_dat.mat',       'RF_022703.exp.2.3algs.mat'...     
%      'RF_022703_exp_3_dat.mat',       'RF_022703.exp.3.3algs.mat';
%   
%       'MA_022703_control_1_dat.mat',     'MA_022703.control.1.3algs.mat'...
      'MA_022703_control_2_dat.mat',     'MA_022703.control.2.3algs.mat'...     
%      'MA_022703_control_3_dat.mat',     'MA_022703.control.3.3algs.mat'; % 

%  'MA_022703_exp_1_dat.mat',         'MA_022703.exp.1.3algs.mat'... 
%  'MA_022703_exp_3_dat.mat',         'MA_022703.exp.3.3algs.mat';

%  'JS_030503_control_1_dat.mat',  'JS_030503.control.1.3algs.mat'...
   'JS_030503_control_2_dat.mat',  'JS_030503.control.2.3algs.mat'; 

%      'JS_030503_exp_2_dat.mat',   'JS_030503.exp.2.3algs.mat'... 
%   'JS_030503_exp_3_dat.mat', 'JS_030503.exp.3.3algs.mat';         

%    'JK_22103_control_1_dat.mat',   'JK_22103.control.1.3algs.mat'...
   'JK_22103_control_2_dat.mat',   'JK_22103.control.2.3algs.mat'... 
%   'JK_22103_control_3_dat.mat',  'JK_22103.control.3.3algs.mat'; 
     
%   'JK_22103_exp_1b_dat.mat',     'JK_22103.exp.1b.3algs.mat'...
%   'JK_22103_exp_2_dat.mat',    'JK_22103.exp.2.3algs.mat'... 
%   'JK_22103_exp_3_dat.mat',    'JK_22103.exp.3.3algs.mat';
     
%  'JE_042103_control_1_dat.mat', 'JE_042103_control.1.3algs.mat'...
  'JE_042103_control_2_dat.mat', 'JE_042103_control.2.3algs.mat'...
%  'JE_042103_control_3_dat.mat', 'JE_042103_control.3.3algs.mat';
     
% 'JE_042103_exp_2_dat.mat', 'JE_042103_exp_2.3algs.mat'...  no break?
%  'JE_042103_exp_3_dat.mat', 'JE_042103_exp_3.3algs.mat'...
%  'JE_042103_exp_4_dat.mat', 'JE_042103_exp_4.3algs.mat';
   
             %data files go here!
	    };
	      
 
%this for loop feeds the parameters to fix_finder.m

AllFix = []; FixTypes = [];

for i = 1:size(filelist,1),

 for j = 1:2:size(filelist,2),
   
   %[A, B] = analyze_baufix(filelist{i,j} , filelist{i,j+1} , 140);
   analyze_baufix(filelist{i,j} , filelist{i,j+1} , 140);
   
 end
end
keyboard

% 
% 
% %   keyboard
%    AllFix = [AllFix; A;];
%    FixTypes = [FixTypes; B;];
%    
%    AllFix = AllFix(find(AllFix(:,1)>0),:);
%    FixTypes = FixTypes(find(FixTypes(:,2)>0),:);
%     
%  end
% 
% a = cell2mat(filelist(i,1));
% fid = fopen([a(1,1:13) '.all'], 'w');
% fprintf(fid, 'Duration Area\n');
% fprintf(fid, '%8.3f %d\n', AllFix');
% fclose(fid);
% 
% fid = fopen([a(1,1:13) '.type'], 'w');
% fprintf(fid, 'Duration Arta Type\n');
% fprintf(fid, '%8.3f %d %d\n', FixTypes');
% fclose(fid);
% %keyboard
% end
% 
 return
