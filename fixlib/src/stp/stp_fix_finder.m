%STP_FIX_FINDER "fixation finder" for saccade testing program data
%   this script mimics the old fixation finder. you specify a file
%   and some parameters, and this programs computes the fixations and
%   saves the results in a ".fix" file

% $Id: stp_fix_finder.m,v 1.1 2001/08/15 16:35:56 pskirko Exp $
% pskirko 8.14.01

clear all;

% 1. SET PARAMETERS
% ------------------------------------------------------------------

filename =                   'diane.100pix.dat';

% eye data type (asl, eih, gaze)

eye_data_type =              'eih';

% velocity threshold parameters

t_thresh =                   50; % ms
vel_thresh =                 50; % deg/sec

% clumping parameters (use [] to disable)

clump_space_thresh =         []; % deg
clump_t_thresh =             []; % ms

% track loss parameters (use [] to disable)

track_loss_pupil_thresh =    []; % ?

% saving results

save_data =                  1; % 1 to save, else 0
save_data_filename =         'STP_FIX_FINDER.OUTPUT';

% visualizing results

viz_results =                1;

% 2. DO ANALYSIS 
% ------------------------------------------------------------------

% ignore this section 

ALL =       stp_load_raw(filename, 'all');

t =         stp_read_ALL(ALL, 'time');
t =         stp_shift_time(t);

asl_h =     stp_read_ALL(ALL, 'asl_h');
asl_v =     stp_read_ALL(ALL, 'asl_v');
asl_pupil = stp_read_ALL(ALL, 'asl_pupil');

[eih_h, eih_v] = stp_pix2angle(asl_h, asl_v);

head_h =    stp_read_ALL(ALL, 'head_h');
head_p =    stp_read_ALL(ALL, 'head_p');

gaze_h = eih_h + head_h;
gaze_v = eih_v + head_p;

if(strcmp(eye_data_type, 'asl'))
  pos_h = asl_h;
  pos_v = asl_v;      
elseif(strcmp(eye_data_type, 'eih'))
  pos_h = eih_h;
  pos_v = eih_v;
elseif(strcmp(eye_data_type, 'gaze'))      
  pos_h = gaze_h;
  pos_v = gaze_v;
else
  error(['bad eye_data_type: ', eye_data_type]);
end

fix = fix_finder_vt(t, [pos_h pos_v], asl_pupil, ...
		    clump_space_thresh, ...
		    clump_t_thresh, ...
		    track_loss_pupil_thresh, ...
		    t_thresh, ...
		    vel_thresh);    

if(save_data)
  save_dot_fix(save_data_filename, fix);
end

% 3. VISUALIZE RESULTS
% ------------------------------------------------------------------

% caveat emptor

if(~viz_results) return; end

vel = compute_vel(t, [pos_h, pos_v]);
vel = vel.*1000; % ms to sec

fs = new_fill_struct(fix, [0, vel_thresh], 'r', 'vt fix');

ps = new_plot_struct([t, vel], 'b-', [eye_data_type, ' vel']); % add vel
as = new_axes_struct([0, 4000], [0, 200]);
ts = new_timeplot_struct(t, 2000, {{ps}}, {{fs}}, as);

%browser(ts);

% use eyeviz as well

% eyeplot

centroid = compute_centroid(fix, t, [pos_h, pos_v]);
centroid = compute_plottable_centroid(t, fix, centroid);

ps_list = {};

ps_list{1} = new_point_struct(t, [pos_h, pos_v], 'b+', eye_data_type); 
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

%eyeviz(es, ps, ts);