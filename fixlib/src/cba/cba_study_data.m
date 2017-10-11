% quick file to look at data in browser.
% pskirko 7.19.01

clear all;

filename = 'BB_G1_041001.dat';
% WARNING: this file has no asl data. so plotting eye angle is
% sorta pointless

filename_data = [filename, '.data']; % output of cba_converter

ALL = cba_load_data(filename_data, 'all');
t = cba_read_ALL(ALL, 'time');
% convert t to ms starting at 0 (i should make this a function)
t = cba_shift_time(t);

% basically, you make a plot struct for each thing you want to view
 
% 1. fastrak_h (head heading angle)

fastrak_h = cba_read_ALL(ALL, 'fastrak_h');
ps_fastrak_h = new_plot_struct([t fastrak_h], 'b-', 'fastrak_h'); 

% 2. eih_h (eye-in-head h) this takes a little work

asl_h = cba_read_ALL(ALL, 'asl_h');
asl_v = cba_read_ALL(ALL, 'asl_v');

[eih_h, eih_v] = cba_pix2angle(asl_h, asl_v);
ps_eih_h = new_plot_struct([t eih_h], 'r-', 'eih_h'); 

% pick how much data to look at at once, and where to start
t_lim = [0 4000]; % first 4 sec.

% pick a time increment
t_step = 2000; % 2 sec. step

% pick whatever vertical limits you want for data

ad = [fastrak_h(:); eih_h(:) ]; %all data
y_lim = [min(ad), max(ad)];

as = new_axes_struct(t_lim, y_lim); 
ts = new_timeplot_struct(t, t_step, {{ps_fastrak_h, ps_eih_h}}, ...
			 {{}}, as); % fix list is 
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