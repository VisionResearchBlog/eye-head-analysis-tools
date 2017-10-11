%STP_VIZ visualizer
%   meant to be expanded as needed.  assumes you'll be viewing
%   fixation finder output.  i've left comments in case you ever
%   get expert files.
%
%   assumes you've saved fixation finder results into a .fix
%   file. if you want to visualize and run fix finder all at once,
%   this is the wrong file. go to stp_fix_finder.

% $Id: stp_viz.m,v 1.2 2001/08/17 20:28:30 pskirko Exp $
% pskirko 8.14.01

clear all;

% 1. SET PARAMETERS FOR LOADING UP DATA
%    so if you want to see velocities we'll have to retrieve them
%    from the data file.
% ------------------------------------------------------------------

filename =                   'diane.100pix.dat';
fix_finder_file =            'STP_FIX_FINDER.OUTPUT';

% supposing you have an expert file...

%fix_expert_file =           'STP_EXPERT_FILE';

% fix finders (crap i should probably save a summary file but for
% now, hack it). the point of specifying this here is that when i
% draw the fixations on screen the topmost one corresponds to the
% velocity threshold.

vel_thresh =                 50; % deg/sec

% 2. LOAD DATA
% ------------------------------------------------------------------

% ignore this section 

ALL =       stp_load_raw(filename, 'all');

t =         stp_read_ALL(ALL, 'time');
t =         stp_shift_time(t);

asl_h =     stp_read_ALL(ALL, 'asl_h');
asl_v =     stp_read_ALL(ALL, 'asl_v');
asl_pupil = stp_read_ALL(ALL, 'asl_pupil');

[eih_h, eih_v] = stp_pix2angle(asl_h, asl_v);

% visualize eye-in-head data
pos_h = eih_h;
pos_v = eih_v;      

fix = load_dot_fix(fix_finder_file);

% again supposing you have an expert file:
% fix_expert = stp_load_fix_expert('STP_EXPERT_FILE');


% 3. VISUALIZE RESULTS
% ------------------------------------------------------------------

vel = compute_vel(t, [pos_h, pos_v]);
vel = vel.*1000; % ms to sec

% THIS LINE ADDS THE INFO TO VISUALIZE FIX FINDER STUFF

fs_list{1} = new_fill_struct(fix, [0, vel_thresh], 'r', 'vt fix');

%% again suppposing you had expert file

%fs_list{1} = new_fill_struct(fix, vel_thresh.*[0, 0.5], 'r', 'vt fix')
%fs_list{2} = new_fill_struct(fix_expert, vel_thresh.*[0.5, 1], ...
%'g', 'fix expert');

ps = new_plot_struct([t, vel], 'b-', ['eih', ' vel']); % add vel
as = new_axes_struct([0, 4000], [0, 200]);
ts = new_timeplot_struct(t, 2000, {{ps}}, {fs_list}, as);

%browser(ts);

% use eyeviz as well

% eyeplot

centroid = compute_centroid(fix, t, [pos_h, pos_v]);
centroid = compute_plottable_centroid(t, fix, centroid);

ps_list = {};

ps_list{1} = new_point_struct(t, [pos_h, pos_v], 'b+', 'eih'); 
ps_list{2} = new_point_struct(t, centroid, 'ro', 'vt fix');
bb = compute_gaze_bb(pos_h, pos_v);
as = new_axes_struct(bb, bb);
es = new_eyeplot_struct({ps_list}, as);

% pupilplot

ps1 = new_pupil_struct(t, asl_pupil, [0.1 0.1 0.1]);
fake_pupil = max(asl_pupil).*ones(length(asl_pupil), 1);
ps2 = new_pupil_struct(t, fake_pupil, [0.0 0.7 0.0]);
bb = compute_pupil_bb(asl_pupil);
as = new_axes_struct(bb, bb);
ps = new_pupilplot_struct({{ps2, ps1}}, as);

eyeviz(es, ps, ts);