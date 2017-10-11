%CBA_STUDY_SUBJECT sample script for running eyeviz/browser
%   the comments in this file explain how to use and modify this
%   example

% $Id: cba_study_subject.m,v 1.3 2001/07/26 15:56:09 pskirko Exp $
% pskirko 7.5.01

clear all;

% 1. data filename
%    - note: for each data file, be sure to run the "cba_converter"
%      program on it. this produces a ".data" file that makes this
%      file faster to load. currently, i am not sure where in my
%      code this is required, so as a precaution, please adhere to 
%      the above rule.
%    - you can specify whether to plot velocity or toid. toid
%      (touched object id) is useful for seeing where subjects 
%      drops the blocks.
%    - if you specify plot_type as vel, when there is no asl data,
%      the program will quit

filename = 'KN_G1_051101.dat';
plot_type = 'vel'; % vel or toid

% 2. specify fixations
%    - this scheme is also used to load things other than
%      fixations. for example, you can load "drops" this way too.

% 2.1 expert fixations
%     - for expert fixation, you must specify the ms offset of the
%       data. my code treats the beginning of each file as time=0.
%       however, data is not recorded this way.  it is adjusted 
%       to my scale by subtracting the 'WritingDataOn' value from
%       all times in the file.  
%     - the struct takes other parameters, see the .m file for 
%       details

filename_expert = [filename, '.fix.expert.diane'];
ms = compute_tc2ms(cba_load_config(filename, 'WritingDataOn'));
fs_expert = cba_new_fix_expert_struct(ms, filename_expert);

% 2.2 vt algorithm
%     - this also has many parameters. the only required ones
%       are t_thresh and vel_thresh
%     - DO NOT use this if no asl data is present.  without 
%       data, fixations cannot be computed.
%     - you can also edit these files. you need to set the
%       editable flag to 1, and set the output_file to some file

fs_vt = new_fix_vt_struct;
fs_vt.vel_thresh = 60; 
fs_vt.t_thresh = 30;

%fs_vt.editable = 1; 
%fs_vt.output_file = 'data/cba/TEST_OUT';

% 2.3 drops
%     - you can also plot drops as though they are fixations.
%

fs_drop = cba_new_fix_drop_struct;
fs_drop.t_thresh = 400;
fs_drop.t_win = [250, 250];

% 2.4 editable file
%     - you can read in a file you saved from editing

%fs_edit = new_fix_editable_struct;
%fs_edit.in_file = 'data/cba/TEST_IN'; % if doesn't exist, starts off empty

% 3. run program
%    - you can run the browser or eyeviz. browser is just the
%      velocity time series, eyeviz is the more advanced app

cba_run('eyeviz', filename, {fs_vt}, plot_type);

% here we look at drops

%plot_type = 'toid';
%cba_run('browser', filename, {fs_drop, fs_vt}, plot_type);


