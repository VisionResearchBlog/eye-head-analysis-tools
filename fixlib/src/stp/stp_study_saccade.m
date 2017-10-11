% study raw saccade data

clear all;

filename = 'diane.100pix.dat';

ALL = stp_load_raw(filename, 'all');

t = stp_read_ALL(ALL, 'time');
t = stp_shift_time(t);

raw = stp_read_ALL(ALL, 'saccade_raw_data');
saccade = stp_read_ALL(ALL, 'Saccade');

volts = stp_convert_saccade_raw_data(t, raw);

% visualize results

ps_list = {};
ps_list{1} = new_plot_struct(volts, 'b-', 'volts'); 
ps_list{2} = new_plot_struct([t, saccade], 'r-', 'saccade');
as = new_axes_struct([0, 4000], [-2, 2]);
ts = new_timeplot_struct(t, 2000, {ps_list}, {{}}, as);

browser(ts);
