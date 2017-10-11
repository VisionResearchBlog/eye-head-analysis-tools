% quick file to look at data in browser.
% pskirko 7.19.01

clear all;

filename = 'BB_G1_041001.dat';
filename_data = [filename, '.data']; % output of cba_converter

%try to fast-load data

ALL = fast_load(filename);
if(~iscell(ALL))
  if(ALL == -1)
    ALL = cba_load_data(filename_data, 'all');
    fast_save(filename, ALL);
  end
else
    
  disp('fast load success');
end

% raw values 

t = cba_read_ALL(ALL, 'time');
t = cba_shift_time(t); % to ms starting at 0

asl_h =     cba_read_ALL(ALL, 'asl_h');
asl_v =     cba_read_ALL(ALL, 'asl_v');
asl_pupil = cba_read_ALL(ALL, 'asl_pupil');
fastrak_h = cba_read_ALL(ALL, 'fastrak_h');
fastrak_p = cba_read_ALL(ALL, 'fastrak_p');
o_size =    cba_read_ALL(ALL, 'size');
toid =      cba_read_ALL(ALL, 'touched_object_id');

% derived quantities

[eih_h, eih_v] = cba_pix2angle(asl_h, asl_v); 
gaze_h = eih_h + fastrak_h;
gaze_v = eih_v + fastrak_p;
gaze_vel = compute_vel(t, [gaze_h, gaze_v]);
gaze_vel = gaze_vel.*1000;
size_ch = cba_compute_size_changes(t, o_size, toid);

% drops (their own section)

drops = cba_compute_drops(t, toid, 400);
[yc_drops, nc_drops] = cba_partition_drops(drops, size_ch); 

twin = [500, 500];
yc = cba_compute_plottable_drops(yc_drops, twin);
nc = cba_compute_plottable_drops(nc_drops, twin);

% vt

ft = new_fix_vt_struct;
ft.vel_thresh = 60; 
ft.t_thresh = 30;

fix = fix_finder_vt(t, [gaze_h gaze_v], [asl_h, asl_v,asl_pupil], ...
		    ft.clump_space_thresh, ...
		    ft.clump_t_thresh, ...
		    ft.track_loss_pupil_thresh, ...
		    ft.t_thresh, ...
		    ft.vel_thresh);    

% plot structs

ps_eih_h =     new_plot_struct([t eih_h], 'r-', 'eih_h'); 
ps_fastrak_h = new_plot_struct([t fastrak_h], 'b-', 'fastrak_h'); 
ps_gaze_vel  = new_plot_struct([t, gaze_vel], 'b-', 'gaze vel');
ps_size =      new_plot_struct([t o_size], 'r-', 'size'); 

ps_list = {ps_gaze_vel, ps_size};

% fill structs

fs_vt = new_fill_struct(fix, [0, 20], [1 0 0], 'fix vt');
fs_sc = new_fill_struct(size_ch,[20 40] , [1 0 1], 'size change');
fs_yc = new_fill_struct(yc, [40 60], [0 1 0], 'w/ change');
fs_nc = new_fill_struct(nc, [60 80], [0 0 1], 'w/o change');

fs_list = {fs_vt, fs_sc, fs_yc, fs_nc};

t_lim = [0 4000]; % first 4 sec.
t_step = 2000; % 2 sec. step

% y limits

ad = [ gaze_vel(:); o_size(:) ]; % all data
y_lim = [min(ad), max(ad)];

as = new_axes_struct(t_lim, y_lim); 
ts = new_timeplot_struct(t, t_step, {ps_list}, {fs_list},  as); 

browser(ts);