%batch_fix_finder.m - Allows one to run a group of
%data files in the fixation finder simply edit
%batch_fix_finder.m adding the files you want to
%analyze by following the template listed above the
%the filename cell array:


%fix_finder.m Matlab Command line invocation: 
%fix_finder('experiment_type', method, vel_thresh, t_thresh, clump_space_thresh, clump_t_thresh, viz_results, 'datafilename')

function h = batch_fix_finder 

  
%specify parameters for experiment type:
  exp_type = 'baufix';
  method = 11;
  vel_thresh = 40; 
  t_thresh = 45;
  clump_space_thresh = .75;
  clump_t_thresh = 50;
  viz_results = 0; %Multiple files will overwrite each others graphs
                   %if turned  
  

 filelist = {  %Example: 'datafile.dat';  
      
%third /current version	       
%'JR_121702.exp.1.dat.data';           'MA_022703.control.1.dat.data'; 
%'HC_121302.control.join.1.dat.data';  'JR_121702.exp.2.dat.data';           'MA_022703.control.2.dat.data'; 
%'HC_121302.control.join.2.dat.data';  'JR_121702.exp.3.dat.data';           'MA_022703.control.3.dat.data'; 
%'HC_121302.control.join.3.dat.data';  'KC_022403.control.1.dat.data';       'MA_022703.exp.1.dat.data'; 
%'HC_121302.exp.1.dat.data';           'KC_022403.control.2.dat.data';       %'MA_022703.exp.2.dat.data'; <-check
%'HC_121302.exp.2.dat.data';           'KC_022403.control.3.dat.data';       'MA_022703.exp.3.dat.data'; 
%'HC_121302.exp.3.dat.data';           'KC_022403.exp.1.dat.data';           'MD_121102_control.1.join.dat.data'; 
%'JF_022603.control.1.dat.data';       'KC_022403.exp.2.dat.data';           'MD_121102_control.2.join.dat.data'; 
%'JF_022603.control.2.dat.data';       'KC_022403.exp.3.dat.data';           'MD_121102_control.3.join.dat.data'; 
%'JF_022603.control.3.dat.data';       'KC_022403.exp.4.dat.data';           'MD_121102.exp.1.dat.data'; 
%'JF_022603.exp.1.dat.data';           'KD_121002.control.1.join.dat.data';  'MD_121102.exp.2.dat.data'; 
%'JF_022603.exp.2.dat.data';           'KD_121002.control.2.join.dat.data';  'MD_121102.exp.3.dat.data'; 
%'JF_022603.exp.3.dat.data';           'KD_121002.control.3.join.dat.data'; 
%'JK_22103.control.1.dat.data';        'KD_121002.exp.1.dat.data';           
%'JK_22103.control.2.dat.data';        'KD_121002.exp.2.dat.data';         
%'JK_22103.control.3.dat.data';        'KD_121002.exp.3.dat.data';          
%'JK_22103.exp.1b.dat.data';           'LK_121202.control.join.2.dat.data';  'RF_022703.control.1.dat.data'; 
%'JK_22103.exp.2.dat.data';            'LK_121202.control.join.3.dat.data';  'RF_022703.control.2.dat.data'; 
%'JK_22103.exp.3.dat.data';            'LK_121202.control.join.dat.data';    'RF_022703.control.3.dat.data'; 
%'JR_121702.control.join.1.dat.data';  'LK_121202.exp.1.dat.data';           'RF_022703.exp.1.dat.data'; 
%'JR_121702.control.join.2.dat.data';  'LK_121202.exp.2.dat.data';           'RF_022703.exp.2.dat.data'; 
%'JR_121702.control.join.3.dat.data';  'LK_121202.exp.3.dat.data';
%'RF_022703.exp.3.dat.data';  
%'JS_030503.control.1.dat.data';  'JS_030503.exp.2.dat.data';
%'JS_030503.control.2.dat.data';  'JS_030503.exp.3.dat.data';

'JE_042103_control.1.dat.data'; 'JE_042103_exp_1.dat.data';  'JE_042103_exp_4.dat.data';
'JE_042103_control.2.dat.data'; 'JE_042103_exp_2.dat.data';
'JE_042103_control.3.dat.data'; 'JE_042103_exp_3.dat.data';
	       
	       
 %data files go here!
	    };
	      
 
%this for loop feeds the parameters to fix_finder.m
for i = 1:length(filelist),

filelist{i,1}
disp 'files to go:'
length(filelist) - i

%depending on what you want to do you can rearrange the for cell
%array so that each datafile can have individual parameters that
%will be referenced in the for loop
   
  fix_finder(exp_type, method, vel_thresh, t_thresh,  clump_space_thresh, ...
	     clump_t_thresh, viz_results, filelist{i,1});
end
