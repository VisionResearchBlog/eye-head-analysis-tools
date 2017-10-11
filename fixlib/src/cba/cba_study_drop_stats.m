%CBA_STUDY_DROP_STATS analyze CBA data based on drops
%   the comments in this file explain how to use and modify it
%
%   WARNING! This file takes a long time to run (REALLY long if you 
%   do batch) because it takes ~ 60 seconds to retrieve the
%   Notified information from a raw data file.

% $Id: cba_study_drop_stats.m,v 1.3 2001/08/17 15:10:00 pskirko Exp $
% pskirko 7.20.01

clear all;

% 1. choose source of data files
%    - you can either use a list of files, given below, or a
%      directory containing ".dat" files
%    - the list should look like this:
%      filename = {'file1.dat', 'file2.dat', 'file3.dat'};
%    - in both cases, make sure a ".data" file exists for each 
%      ".dat" file (see the cba_converter helper program) 

%  cba_data_dir = 'data/cba'; 
%  filenames = cba_get_filenames(cba_data_dir);

filenames = {'KN_G1_051101.dat'};

% 2. set the fast flag
%    - these files take a while to load.  setting the fast_flag to 1
%      speeds up the process by saving the data as MAT files in
%      your working directory
%    - if you set the fast_flag, and MAT files don't exist, then
%      the underlying function will make them for you. so the first
%      time you run this it will probably be real slow

fast_flag = 1; 

% 3. set fixation finder parameters
%    - currently this uses the VT (velocity) fixation finder.  you
%      must set at least the velocity and time thresholds
%    - other parameters exist. see compute_fix_vt.m

fs = new_fix_vt_struct;
fs.t_thresh = 50;
fs.vel_thresh = 60;
	
% 4. set drop parameters
%    - a drop is when a block is put down
%    - object touches smaller than t_thresh are ignored as noise
%    - the t_window is the ms before and after the drop. this is
%      used as a time window to see, for example, what fixations
%      occur near this drop. it need not be symmetric (eg [100,
%      200] is valid)

drop = cba_new_fix_drop_struct;
drop.t_thresh = 400;
drop.t_win = [500, 500];

% 5. choose analysis type
%    - the following types are supported:
%      - 'all'
%        does all 3 analyses described below
%      - 'all_overlap' 
%        this reports the mean number of fixations "overlapping"
%        the drop window, and the avg. duration
%      - 'one_most_overlap'
%        this reports the mean duration of the fixation that most
%        overlaps the drop window
%      - 'one_largest_of_any_overlap'
%        this reports the mean duration of the largest fixation
%        containing any overlap with the drop window (thus the
%        smallest overlap may belong to the longest fixation)
%      - all overlaps are considered w.r.t. the drop window. 
%        so if a fixation overlaps the entire drop window, and
%        then some on either side, the overlap is effectively 1 
%        not below 1 or above 1 
%      - the exact formula is:
%        overlap = intersect(fix, drop_window) / area(drop_window)

analysis_type = 'all';

% 6. summary file
% if you want to save data 
% pass in '' if you don't want it

summary_file = 'DROP_STATS_SUMMARY';

cba_compile_drop_stats(filenames, fast_flag, fs, drop, analysis_type, ...
		       summary_file);