% file used to study how well the "noticed" tags are used to
% discriminate our drops.
% try to see if we can use the noticed tags...blech
clear all;

filename = 'AC_G1_072301.dat';

ALL =         cba_load_data([filename, '.data'], 'all');

o_size =      cba_read_ALL(ALL, 'size');
t =           cba_read_ALL(ALL, 'time');
t =           cba_shift_time(t);
toid =        cba_read_ALL(ALL, 'touched_object_id');

noticed =     cba_load_noticed(filename);

% convert noticed into a plottable format

% ugh inefficient
n = size(noticed, 1);

noticed_viz= 0.*t;

for i=1:n
  curr_t = noticed(i);

  disp(['noticed: ', num2str(curr_t)]);
  
  maxt = max(find(t <= curr_t));
  noticed_viz(maxt) = 1;
  
  mint = min(find(t >= curr_t));
  noticed_viz(mint) = 1;
end

size_changes = cba_compute_size_changes(t, o_size, toid);
drops = cba_compute_drops(t, toid, 400);
[yc_drops, nc_drops] = cba_partition_drops(drops, size_changes); 

twin = [500, 500];
yc = cba_compute_plottable_drops(yc_drops, twin);
nc = cba_compute_plottable_drops(nc_drops, twin);

% partition size changes according to noticed/not noticed
[yn_changes, nn_changes] = cba_changes_by_noticed(t, o_size, toid, noticed);

[yn_drops, nn_drops] = cba_partition_drops(drops, yn_changes); 

ps_list = {};

ps_list{1} = new_plot_struct([t, noticed_viz], 'b-', 'noticed'); 
ps_list{2} = new_plot_struct([t, o_size./100], 'r-', 'size'); 

fs_list = {};

twin = [500, 500];
yc = cba_compute_plottable_drops(yn_drops, twin);
nc = cba_compute_plottable_drops(nn_drops, twin);

fs_list{1} = new_fill_struct(yc, [0.2 0.4], [0 1 0], 'noticed');
fs_list{2} = new_fill_struct(nc, [0.4 0.6], [0 0 1], 'not noticed');

as = new_axes_struct([0, 4000], [-1, 5]); 
ts = new_timeplot_struct(t, 2000, {ps_list}, {fs_list},  as); 

browser(ts);
