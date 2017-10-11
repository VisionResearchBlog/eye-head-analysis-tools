%batch_fix_finder.m - Allows one to run a group of
%data files in the fixation finder simply edit
%batch_fix_finder.m adding the files you want to
%analyze by following the template listed above the
%the filename cell array:


%fix_finder.m Matlab Command line invocation: 
%fix_finder('experiment_type', method, vel_thresh, t_thresh, clump_space_thresh, clump_t_thresh, viz_results, 'datafilename')

function h = batch_fix_finder2 
 
%specify parameters for sexperiment type:
  exp_type = 'bricks';
  method = 11;
  vel_thresh = 50; 
  t_thresh = 50;
  clump_space_thresh = 1.5;
  clump_t_thresh = 50;
  viz_results = 0;%Multiple files will overwrite each others graphs
                  %if turned  
  

 filelist = {       % 'MK_111202_ww_wh.dat.data';
                    % 'ANR_110102.dat.data';          
                    % 'SCF_111202_ww_wh.dat.data';
                    %'SD_110502_cc_2.dat.data';

'LFG_111402_hh_ht.dat.data';        
'LJK_121602_tt_tc.dat.data';        'TR_120402_ww_wt.dat.data';
'EB_121102_tt_tc.dat.data';         'MDD_121302_ww_wt.dat.data';        'TSW_111302_cc_ch.dat.data';
'MD_120302_cc_ct.dat.data';         'VR_121002_hh_hw.dat.data';
	       %data files go here!
	    };
	      
 
%this for loop feeds the parameters to fix_finder.m
for i = 1:length(filelist),
  
  fix_finder(exp_type, method, vel_thresh, t_thresh,  clump_space_thresh,...
	     clump_t_thresh, viz_results, filelist{i,1});
end
