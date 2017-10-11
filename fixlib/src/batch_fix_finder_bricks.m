%batch_fix_finder.m - Allows one to run a group of
%data files in the fixation finder simply edit
%batch_fix_finder.m adding the files you want to
%analyze by following the template listed above the
%the filename cell array:


%fix_finder.m Matlab Command line invocation: 
%fix_finder('experiment_type', method, vel_thresh, t_thresh, clump_space_thresh, clump_t_thresh, viz_results, 'datafilename')

function h = batch_fix_finder_bricks 
 
%specify parameters for experiment type:
  exp_type = 'bricks';
  method = 11;
  vel_thresh = 50; 
  t_thresh = 50;
  clump_space_thresh = 1.5;
  clump_t_thresh = 50;
  viz_results = 0;%Multiple files will overwrite each others graphs
                  %if turned  
  

 filelist = { 
     
     'VR_100604_hx.dat.data';
     'DG_100604_cx.dat.data';
     
%'PS_100804_hx.dat.data';
%'KN_100804_wx.dat.data';
%'AB_093004_cx.dat.data';
%'BW_100704_wx.dat.data';
%'CP_100604_tx.dat.data';
%'JL_100804_wx.dat.data';
%'JM_100704_hx.dat.data';
     
% 'AB_093004_cx.dat.data';
%'AR_100204_wx_12Xtrls.dat.data';
%'DC_093004_cx.dat.data';
%'DJM_100204_cx.dat.data';  
%'EK_100404_hx.dat.data';
%'FE_100104_tx.dat.data';
%'GM_100304_wx.dat.data';
%'KR_100104_wx.dat.data';
%'MMS_100404_tx.dat.data';
%'MS_100404_cx.dat.data';
%'PH_100204_hx.dat.data';
%'RM_100404_tx.dat.data';
%'SN_100204_hx.dat.data';
%'VD_100104_tx.dat.data';
 
 
 % 'MK_111202_ww_wh.dat.data';                  % 'ANR_110102.dat.data';          
                    % 'SCF_111202_ww_wh.dat.data';
                    %'SD_110502_cc_2.dat.data';

%'LFG_111402_hh_ht.dat.data';        
%'LJK_121602_tt_tc.dat.data';        'TR_120402_ww_wt.dat.data';
%'EB_121102_tt_tc.dat.data';         'MDD_121302_ww_wt.dat.data';        'TSW_111302_cc_ch.dat.data';
%'MD_120302_cc_ct.dat.data';         'VR_121002_hh_hw.dat.data';
	       %data files go here
		    		    
	    };
	      
 
%this for loop feeds the parameters to fix_finder.m
for i = 1:length(filelist),
  
  files_2_go = size(filelist,1)-i
  fix_finder_NEW(exp_type, method, vel_thresh, t_thresh,  clump_space_thresh,...
	     clump_t_thresh, viz_results, filelist{i,1});
end

