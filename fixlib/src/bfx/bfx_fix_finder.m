%BFX_FIX_FINDER "fixation finder" for baufix data
%   this script mimics the old fixation finder. you specify a file
%   and some parameters, and this programs computes the fixations and
%   saves the results in a ".fix" file

% $Id: bfx_fix_finder.m,v 1.2 2002/02/28 22:08:41 pilardi Exp $
% pskirko 8.15.01

clear all;

% 1. SET PARAMETERS
% ------------------------------------------------------------------

filename =                   'BS_20000718.G1.7.dat';

% eye data type (asl, eih, gaze)

eye_data_type =              'gaze';

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
save_data_filename =         'BFX_FIX_FINDER.OUTPUT';

% visualizing results

viz_results =                1;

% 2. DO ANALYSIS 
% ------------------------------------------------------------------

% ignore this section 

ALL =       bfx_load_raw(filename, 'all');

t =         bfx_read_ALL(ALL, 'time');

asl_h =     bfx_read_ALL(ALL, 'asl_h');
asl_v =     bfx_read_ALL(ALL, 'asl_v');
asl_pupil = bfx_read_ALL(ALL, 'asl_pupil');

eih_h =     bfx_read_ALL(ALL, 'eih_h');
eih_v =     bfx_read_ALL(ALL, 'eih_v');

gaze_h =    bfx_read_ALL(ALL, 'gaze_h');
gaze_v =    bfx_read_ALL(ALL, 'gaze_v');

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

fix = fix_finder_vt(t, [pos_h pos_v], [asl_h, asl_v,asl_pupil], ...
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

browser(ts);