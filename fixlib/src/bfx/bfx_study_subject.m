%BFX_STUDY_SUBJECT sample script for running eyeviz/browser
%   the comments in this file explain how to use and modify this
%   example

% $Id: bfx_study_subject.m,v 1.3 2001/08/15 17:03:02 pskirko Exp $
% pskirko 7.5.01

clear all;

% give data filename

filename = 'BS_20000718.G1.7.dat';

% choose "fixations" to show

% fix 1: expert
fs_expert = new_fix_expert_struct;
fs_expert.filename = [filename, '.fix.expert'];

% fix 2: vt algorithm
fs_vt = new_fix_vt_struct;
fs_vt.vel_thresh = 60;
fs_vt.t_thresh = 50;

% make it editable

fs_vt.editable = 1;
fs_vt.output_file = 'data/bfx/TEST_OUT';

bfx_run('eyeviz', filename, {fs_expert, fs_vt});
%bfx_run('browser', filename, {fs_vt});

