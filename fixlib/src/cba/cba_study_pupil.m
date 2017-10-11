% a file for viewing pupil velocities

clear all;

filename = 'KN_G1_051101.dat';
filename_data = [filename, '.data']; 

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

t = cba_read_ALL(ALL, 'time');
t = cba_shift_time(t); % to ms starting at 0

asl_h = cba_read_ALL(ALL, 'asl_h');
asl_v = cba_read_ALL(ALL, 'asl_v');
asl_pupil = cba_read_ALL(ALL, 'asl_pupil');

[eih_h, eih_v] = cba_pix2angle(asl_h, asl_v);

vel = compute_vel(t, [eih_h, eih_v]);
vel = vel.*1000; %ms to s

pupil_vel = compute_vel(t, asl_pupil);

ps_pupil = new_plot_struct([t asl_pupil], 'b-', 'pupil');
ps_pupil_vel = new_plot_struct([t pupil_vel], 'b-', 'pupil');

% pick how much data to look at at once, and where to start
t_lim = [0 4000]; % first 4 sec.

% pick a time increment
t_step = 2000; % 2 sec. step

% pick whatever vertical limits you want for data

ad = [ pupil_vel(:)];
%ad = [fastrak_h(:); eih_h(:) ]; %all data
y_lim = [min(ad), max(ad)];


%as fixation let's do size change

%size_ch = cba_compute_size_changes(t, o_size, toid);

%fs_sc = new_fill_struct(size_ch,[0 20] , [1 0 0], 'size change');

%divide the drops according to size change
%drops = cba_compute_drops(t, toid, 400);

%[w_change, wo_change] = cba_partition_drops(drops, size_ch);

%twin = [500, 500];
%wc = cba_compute_plottable_drops(w_change, twin);
%woc = cba_compute_plottable_drops(wo_change, twin);

%fs_wc = new_fill_struct(wc, [20 40], [0 1 0], ...
%			'w change');
%fs_woc = new_fill_struct(woc, [40 60], [0 0 1], ...
%			 'wo change');


as = new_axes_struct(t_lim, y_lim); 
ts = new_timeplot_struct(t, t_step, {{ps_pupil_vel}},  {{}}, as); % fix list is 
							      % empty

% you'll notice the {{}} look funny.  the purpose is to get the
% entire cell array.  matlab syntax says that you can put a cell
% array at the end of a function call to send a variable number of 
% arguments, ie
%
% plot(x, y, 'size', 'big', 'color', 'green')
%
% can be written as
%
% plot(x, y, {'size', 'big', 'color', 'green'})
%
% i think this is why i have to do nested cell arrays
				   
browser(ts);