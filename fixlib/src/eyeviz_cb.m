%EYEVIZ_CB eyeviz callbacks
%   EYEVIZ_CB is called by EYEVIZ

%   all hacks done for speed, still there's room for improvement
%   (less for-loops!)

%   this file is a mess, good luck modifying it!

% $Id: eyeviz_cb.m,v 1.7 2001/08/17 19:25:02 pskirko Exp $
% pskirko 6.21.01

function eyeviz_cb(id)

global h_fig;

[h_cbo, h_fig] = gcbo;

if(strcmp(id, 'eyeplot_change_xy_lim'))
  ans = inputdlg({'enter minimum x value:', ...
		  'enter maximum x value:', ...
		  'enter minimum y value:', ...
		  'enter maximum y value:'}, ...
		  'change x and y limits', 1);
  
  if length(ans) < 4 return; end    

  xmin = str2double(ans(1)); xmax = str2double(ans(2));  
  ymin = str2double(ans(3)); ymax = str2double(ans(4));  
  
  if(xmin == NaN | xmax == NaN) return; end
  if(ymin == NaN | ymax == NaN) return; end
  
  as = get_eyeplot_curr_axes_params;  
  as.xlim = [xmin, xmax];
  as.ylim = [ymin, ymax];
  set_eyeplot_curr_axes_params(as);
  axes(get_eyeplot_axes);
  xlim(as.xlim);
  ylim(as.ylim);
		  
elseif(strcmp(id, 'edit_fix'))
  edit_fix;
  update_all;

elseif(strcmp(id, 'goto_time'))
  selection_type = get(h_fig, 'SelectionType');
  
  if(strcmp(selection_type, 'normal')) % only do on left-click    
    [new_t, y] = ginput(1);
    
    as = get_timeplot_curr_axes_params;
    
    if(new_t >= as.xlim(1) & new_t <= as.xlim(2))      
      goto_time(new_t);
    else
      t_step = my_get('ev_t_step');
      if(new_t > as.xlim(2))
	as.xlim = as.xlim + t_step;
      else
	as.xlim = as.xlim - t_step;
      end
      new_t = 0.5.*[sum(as.xlim)];
      
      set_timeplot_curr_axes_params(as);
      goto_time(new_t);
    end
  end  
          
elseif(strcmp(id, 'init'))
  % set current time
  point_struct = get_point_struct(1);
  t = point_struct.t;
  
  curr_t = t(1);
  curr_t_idx = 1;
   
  my_set('ev_curr_t', curr_t);
  my_set('ev_curr_t_idx', curr_t_idx);

  % copy eyeplot's axes params
  curr_ap = copy_axes_params(get_eyeplot_axes_params);
  my_set('ev_eyeplot_curr_axes_params', curr_ap);
  
  % copy timeplot's axes params
  curr_ap = copy_axes_params(get_timeplot_axes_params);
  my_set('ev_timeplot_curr_axes_params', curr_ap);
 
  % make time lookup table
  ts = get_timeplot_struct;
  t_step = ts.t_step; 
  t_max = t(length(t));
  
  t_lookup = 0:t_step:t_max;
  t_lookup = [t_lookup (max(t_lookup)+t_step)];
  my_set('ev_t_lookup', t_lookup);

  % init timestep
  my_set('ev_t_step', t_step);
  
  % initially trail is off
  my_set('ev_trail', 0);

  % set trail colors
  my_set('ev_trail_colors', [1 1 1; 0.9 0.9 0.9; 0.7 0.7 0.7; 0.5 ...
		    0.5 0.5; 0.3 0.3 0.3; 0.1 0.1 0.1; 0.05 0.05 ...
		    0.05; 0 0 0 ]);

  my_set('ev_redraw_timeplot', 1);
  %  my_set('ev_time_marker_handle', []);  

  % check to see if editable fill struct exists
  init_editable_fill_structs;
  if(isempty(get_editable_fill_structs)) % if not,disable fix editing
    set(my_find('ev_new_fix'), 'Enable', 'off');    
    set(my_find('ev_edit_fix'), 'Enable', 'off');    
  end

  update_all;
  
elseif(strcmp(id, 'jump'))
  answer = inputdlg('enter new time (ms):', 'jump to time', 1);

  if(~isempty(answer))
    new_t = str2num(answer{1});
    if(~isempty(new_t))
      goto_time(new_t);
    end
  end
  
elseif(strcmp(id, 'next'))
  curr_t_inc;
  update_all;
  
elseif(strcmp(id, 'new_fix'))
  grab_new_fix;
  update_all; 
  
elseif(strcmp(id, 'prev'))
  curr_t_dec;
  update_all;
  
  elseif(strcmp(id, 'timeplot_change_t_step'))
  ans = inputdlg({'enter new t step:'}, ...		  
		 'change t step', 1);
  
  if length(ans) < 1 return; end    

  t_step = str2double(ans(1)); 
  if(isempty(t_step)) return; end
  if(t_step == NaN) return; end
  
  my_set('ev_t_step', t_step);
  init_t_lookup;
  
elseif(strcmp(id, 'timeplot_change_x_lim'))
  ans = inputdlg({'enter minimum x value:', ...
		  'enter maximum x value:'}, ...
		 'change x limits', 1);
  
  if length(ans) < 2 return; end    

  xmin = str2double(ans(1)); xmax = str2double(ans(2));  
  if(isempty(xmin) | isempty(xmax)) return; end
  if(xmin == NaN | xmax == NaN) return; end
  
  as = get_timeplot_curr_axes_params;  
  as.xlim = [xmin, xmax];
  set_timeplot_curr_axes_params(as);
  axes(get_timeplot_axes);
		
  my_set('ev_redraw_timeplot', 1);
  update_all; % redraw the time marker in case it needs to expand
  
elseif(strcmp(id, 'timeplot_change_y_lim'))
  ans = inputdlg({'enter minimum y value:', ...
		  'enter maximum y value:'}, ...
		 'change y limits', 1);
  
  if length(ans) < 2 return; end    

  ymin = str2double(ans(1)); ymax = str2double(ans(2));  
  if(ymin == NaN | ymax == NaN) return; end
  
  as = get_timeplot_curr_axes_params;  
  as.ylim = [ymin, ymax];
  set_timeplot_curr_axes_params(as);
  axes(get_timeplot_axes);
  ylim(as.ylim);
		  
  update_all; % redraw the time marker in case it needs to expand

elseif(strcmp(id, 'trail'))
  toggle_trail;
  
else
  
end

%**************************************************************
%*      copy_axes_params
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function ap_out = copy_axes_params(ap_in)

ap_out = new_axes_struct(ap_in.xlim, ap_in.ylim);


%**************************************************************
%*      curr_t_dec
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function curr_t_dec

curr_t = my_get('ev_curr_t');
curr_t_idx = my_get('ev_curr_t_idx');

if(curr_t_idx == 1) return; end

point_struct = get_point_struct(1);
t = point_struct.t;

curr_t_idx = curr_t_idx - 1;
curr_t = t(curr_t_idx);

my_set('ev_curr_t', curr_t);
my_set('ev_curr_t_idx', curr_t_idx);


%**************************************************************
%*      curr_t_inc
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function curr_t_inc

curr_t = my_get('ev_curr_t');
curr_t_idx = my_get('ev_curr_t_idx');

point_struct = get_point_struct(1);
t = point_struct.t;

if(curr_t_idx == length(t)) return; end

curr_t_idx = curr_t_idx + 1;
curr_t = t(curr_t_idx);

my_set('ev_curr_t', curr_t);
my_set('ev_curr_t_idx', curr_t_idx);

%**************************************************************
%*      edit_fix
%*  
%*      
%* 
%*      pskirko 7.6.01
%**************************************************************

function edit_fix

axes(get_timeplot_axes); 

% the new fix button is disabled if they're not in editable mode.
% so here we can assume editable fix exists.

[X, Y] = ginput(1);

%figure out which fix this is

[fs, fidx] = get_editable_fill_struct(Y);

if(isempty(fs)) return; end

fix = fs.fill;
idx = find(X>=fix(:,1) & X<=fix(:,2));
target_fix = fix(idx,:);
fix(idx,:) = [];

if(isempty(target_fix)) return; end

[X,Y] = ginput(2);

if(X(1) > X(2)) return; end % nope

t_range = [X(1), X(2)];

fs.fill = sortrows([fix; t_range]);
set_fill_struct(fidx, fs);
my_set('ev_redraw_timeplot', 1);

write_to_file(fs);
  

%**************************************************************
%*      get_curr_t
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function [curr_t, curr_t_idx] = get_curr_t

curr_t = my_get('ev_curr_t');
curr_t_idx = my_get('ev_curr_t_idx');


%**************************************************************
%*      get_editable_fill_struct  
%*       
%*      pskirko 7.6.01
%**************************************************************

function [fs, idx] = get_editable_fill_struct(y)

idxes = my_get('ev_editable_fill_struct_idxes');

if(isempty(idxes))
  fs = [];
else
  n = length(idxes);
  ldx = -1;
  fs = [];
  idx = -1;
  for i=1:n
    lidx = idxes(i);
    lfs = get_fill_struct(lidx);    
    lylim = lfs.ylim;
    
    if(y >= lylim(1) & y <= lylim(2))
      fs = lfs;
      idx = lidx;
      break;
    end
  end
end


%**************************************************************
%*      get_editable_fill_structs
%*       
%*      pskirko 7.6.01
%**************************************************************

function fs_list = get_editable_fill_structs

idxes = my_get('ev_editable_fill_struct_idxes');

if(isempty(idxes))
  fs_list = {};
else
  n = length(idxes);
  for i=1:n
    idx = idxes(i);
    fs_list{i} = get_fill_struct(idx);
  end
end


%**************************************************************
%*      get_eyeplot_axes
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function h = get_eyeplot_axes

global h_fig;

h = findobj(h_fig, 'Tag', 'ev_eyeplot_axes');


%**************************************************************
%*      get_eyeplot_axes_params
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function ap = get_eyeplot_axes_params

eyeplot_struct = my_get('ev_eyeplot_struct');
ap = eyeplot_struct.axes_params;


%**************************************************************
%*      get_eyeplot_curr_axes_params
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function ap = get_eyeplot_curr_axes_params

ap = my_get('ev_eyeplot_curr_axes_params');


%**************************************************************
%*      get_num_fill_structs
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function n = get_num_fill_structs

global h_fig;

ts = my_get('ev_timeplot_struct');
fs = ts.fill_structs;
n = length(fs);


%**************************************************************
%*      get_num_plot_structs
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function n = get_num_plot_structs

global h_fig;

ts = my_get('ev_timeplot_struct');
ps = ts.plot_structs;
n = length(ps);


%**************************************************************
%*      get_num_pupil_structs
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function n = get_num_pupil_structs

global h_fig;

ts = my_get('ev_pupilplot_struct');
ps = ts.pupil_structs;
n = length(ps);


%**************************************************************
%*      get_num_point_structs
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function n = get_num_point_structs

global h_fig;

eyeplot_struct = my_get('ev_eyeplot_struct');
point_struct = eyeplot_struct.point_structs;
n = length(point_struct);


%**************************************************************
%*      get_fill_struct
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function fs = get_fill_struct(idx)

global h_fig;

ts = my_get('ev_timeplot_struct');
fs = ts.fill_structs;
fs = fs{idx}; 


%**************************************************************
%*      get_plot_struct
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function ps = get_plot_struct(idx)

global h_fig;

ts = my_get('ev_timeplot_struct');
ps = ts.plot_structs;
ps = ps{idx}; 


%**************************************************************
%*      get_point_struct
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function point_struct = get_point_struct(idx)

global h_fig;

eyeplot_struct = my_get('ev_eyeplot_struct');
point_struct = eyeplot_struct.point_structs;
point_struct = point_struct{idx}; 

%**************************************************************
%*      get_pupil_struct
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function ps = get_pupil_struct(idx)

global h_fig;

ts = my_get('ev_pupilplot_struct');
ps = ts.pupil_structs;
ps = ps{idx}; 



%**************************************************************
%*      get_pupilplot_axes
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function h = get_pupilplot_axes

global h_fig;

h = findobj(h_fig, 'Tag', 'ev_pupilplot_axes');


%**************************************************************
%*      get_pupilplot_axes_params
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function ap = get_pupilplot_axes_params

ps = my_get('ev_pupilplot_struct');
ap = ps.axes_params;


%**************************************************************
%*      get_timeplot_axes
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function h = get_timeplot_axes

global h_fig;

h = findobj(h_fig, 'Tag', 'ev_timeplot_axes');


%**************************************************************
%*      get_timeplot_axes_params
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function ap = get_timeplot_axes_params

timeplot_struct = my_get('ev_timeplot_struct');
ap = timeplot_struct.axes_params;

%**************************************************************
%*      get_timeplot_curr_axes_params
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function ap = get_timeplot_curr_axes_params

ap = my_get('ev_timeplot_curr_axes_params');


%**************************************************************
%*      get_timeplot_struct
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function ts = get_timeplot_struct

ts = my_get('ev_timeplot_struct');


%**************************************************************
%*      goto_time
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function goto_time(new_t)

curr_t = my_get('ev_curr_t');
curr_t_idx = my_get('ev_curr_t_idx');

point_struct = get_point_struct(1);
t = point_struct.t;

if(new_t < t(1) | new_t > t(length(t))) 
  disp('illegal jump');
  return; 
end

curr_t_idx = max(find(t < new_t));
curr_t = t(curr_t_idx);

my_set('ev_curr_t', curr_t);
my_set('ev_curr_t_idx', curr_t_idx);

update_all;


%**************************************************************
%*      grab_new_fix
%*  
%*      
%* 
%*      pskirko 7.6.01
%**************************************************************

function grab_new_fix

axes(get_timeplot_axes); 

% first get appropriate fix set to edit

[X, Y] = ginput(1);

[fs, fidx] = get_editable_fill_struct(Y);

if(isempty(fs)) return; end  % they didn't pick a set

[X, Y] = ginput(2);
t_range = [X(1), X(2)];

fs.fill = sortrows([fs.fill; t_range]);
set_fill_struct(fidx, fs);
my_set('ev_redraw_timeplot', 1);

write_to_file(fs);

  
%**************************************************************
%*      init_editable_fill_structs
%*  
%*      
%* 
%*      pskirko 7.6.01
%**************************************************************

function init_editable_fill_structs

idxes = [];

n = get_num_fill_structs;

for i=1:n
  fs = get_fill_struct(i);      
  if(fs.editable)
    idxes = [ idxes, i ];
  end
end	    

my_set('ev_editable_fill_struct_idxes', idxes);


%**************************************************************
%*      init_t_lookup
%*  
%*      
%* 
%*      pskirko 7.6.01
%**************************************************************
function init_t_lookup
  % make time lookup table
  ts = get_timeplot_struct;
  t = ts.t;
  t_step = my_get('ev_t_step');
  t_max = t(length(t));
  
  t_lookup = 0:t_step:t_max;
  t_lookup = [t_lookup (max(t_lookup)+t_step)];
  my_set('ev_t_lookup', t_lookup);

%**************************************************************
%*      is_trail_on
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function a = is_trail_on

a = my_get('ev_trail');

%**************************************************************
%*      lookup_t
%*  
%*      returns t from lookup that is closest (floor) to key
%* 
%*      pskirko 6.21.01
%**************************************************************

function t = lookup_t(key)

if(key <=0)
  t = 0;
  return;
end

t_lookup = my_get('ev_t_lookup');
t_idx = max(find(t_lookup < key));

if(t_idx ~= 1)
t_idx = t_idx - 1;  
end

t = t_lookup(t_idx);

%**************************************************************
%*      my_find
%*  
%*      findobj shortcut
%* 
%*      pskirko 6.21.01
%**************************************************************

function h = my_find(tag)

global h_fig;

h = findobj(h_fig, 'Tag', tag);

%**************************************************************
%*      my_get
%*  
%*      getappdata shortcut
%* 
%*      pskirko 6.21.01
%**************************************************************

function val = my_get(key)

global h_fig;

val = getappdata(h_fig, key);

%**************************************************************
%*      my_set
%*  
%*      setappdata shortcut
%* 
%*      pskirko 6.21.01
%**************************************************************

function my_set(key, val)

global h_fig;

setappdata(h_fig, key, val);


%**************************************************************
%*      plot_eye
%*  
%*      plots eye data
%*  
%*      trail is currently wanky, could be improved. (try
%*      going backwards thru data file with it on)
%*
%*      pskirko 6.21.01
%**************************************************************

function plot_eye

axes(get_eyeplot_axes); cla; hold on; grid on;

lt = {}; idx = 1; lh = [];

ap = get_eyeplot_curr_axes_params;
xlim(ap.xlim); ylim(ap.ylim);

[curr_t, curr_t_idx] = get_curr_t;
n = get_num_point_structs;

for i=1:n
  point_struct = get_point_struct(i);
  x = point_struct.x;

  if(~isempty(x))
    if(is_trail_on & point_struct.trail) % fancy
      trail_colors = my_get('ev_trail_colors');
      for i = 1:8
	curr = curr_t_idx - i;
	if(curr > 0)
	  plot(x(curr, 1), x(curr, 2),  point_struct.linespec, ...
	       'MarkerEdgeColor', trail_colors(9-i,:), 'MarkerSize', 10);
	end
      end
      h = plot(x(curr_t_idx, 1), x(curr_t_idx, 2), ...
	       point_struct.linespec, 'MarkerSize', 10); 
      lh = [lh h ]; lt{idx} = point_struct.legend; idx = idx+1;
    else
      h = plot(x(curr_t_idx, 1), x(curr_t_idx, 2), ...
	       point_struct.linespec, 'MarkerSize', 10);
      lh = [lh h ]; lt{idx} = point_struct.legend; idx = idx+1;
    end
  end
end

axes(get_eyeplot_axes);
legend(lh, lt);


%**************************************************************
%*      plot_pupil
%*  
%*      plots time series data
%* 
%*      pskirko 6.21.01
%**************************************************************

function plot_pupil

% make template
slices = 20;
del_theta = 2*pi/slices;
tmp = 0:del_theta:(2*pi);

x = cos(tmp);
y = sin(tmp);

axes(get_pupilplot_axes); cla; hold on; 

ap = get_pupilplot_axes_params;
xlim(ap.xlim); ylim(ap.ylim);

[curr_t, curr_t_idx] = get_curr_t;

n = get_num_pupil_structs;

for i=1:n
  ps = get_pupil_struct(i);
  d = ps.pupil(curr_t_idx);
  
  fill(d.*x, d.*y, ps.color);  
end

%**************************************************************
%*      plot_time
%*  
%*      plots time series data
%* 
%*      pskirko 6.21.01
%**************************************************************

function plot_time

axes(get_timeplot_axes); 

redraw_time = my_get('ev_redraw_timeplot');

if(redraw_time)
  my_set('ev_redraw_timeplot', 0);

  lh = []; lt = {}; idx =1;
  
  %see if axes need to be updated
  [curr_t, curr_t_idx] = get_curr_t;
  ap = get_timeplot_curr_axes_params;
  ts = get_timeplot_struct;
%  t_step = ts.t_step;
t_step = my_get('ev_t_step');
  
  if(curr_t < ap.xlim(1) | curr_t > ap.xlim(2))
    new_t = lookup_t(curr_t);
    width = ap.xlim(2) - ap.xlim(1);
    ap.xlim = [new_t (new_t+width)];
    set_timeplot_curr_axes_params(ap);
  end
  
  cla; hold on; 
  
  xlim(ap.xlim); ylim(ap.ylim);
  
  % fills 
  if 1
    n = get_num_fill_structs;
    
    for i=1:n
      fs = get_fill_struct(i);      
      %  h = plot_fix(fs.fill, fs.ylim, fs.color, ap.xlim;)
      if(~isempty(fs.fill))
	h = plot_fix(fs.fill, fs.ylim, fs.color, [min(ts.t) ...
		    max(ts.t)]);
	if(h ~= -1) % warn't empty
	  lh = [lh h(1)];
	  lt{idx} = fs.legend; idx = idx +1;
	end
      end
    end
  end
  
  % plots
  
  n = get_num_plot_structs;
  
  for i=1:n
    ps = get_plot_struct(i);
    if(~isempty(ps.x))
      h = plot(ps.x(:,1), ps.x(:,2), ps.linespec);
      lh = [lh h];
      lt{idx} = ps.legend; idx = idx + 1;  
    end
  end
  
%  axes(get_timeplot_axes); 
%  [h, obj] = legend(lh, lt);
%  my_set('ev_timeplot_legend', h);
  
else % just update limits
  
  %see if axes need to be updated
  [curr_t, curr_t_idx] = get_curr_t;
  ap = get_timeplot_curr_axes_params;
  ts = get_timeplot_struct;
%  t_step = ts.t_step;
t_step = my_get('ev_t_step'); 

  if(curr_t < ap.xlim(1) | curr_t > ap.xlim(2))
    new_t = lookup_t(curr_t);
    width = ap.xlim(2) - ap.xlim(1);
    ap.xlim = [new_t (new_t+width)];
    set_timeplot_curr_axes_params(ap);
  end
  
  xlim(ap.xlim); ylim(ap.ylim);

%  h = my_get('ev_timeplot_legend');
%  h2 = legend(h);
%  my_set('ev_timeplot_legend', h2);
  
 % axes(get_timeplot_axes); 
 % legend(lh, lt);
end

%**************************************************************
%*      plot_time_marker
%*  
%*      plots marker for current time (removes old one?)
%* 
%*      pskirko 6.21.01
%**************************************************************

function plot_time_marker

axes(get_timeplot_axes); hold on; 

% hack
hf = my_find('ev_time_marker_handle');
if(~isempty(hf)) % move it
  set(hf, 'Parent', get_pupilplot_axes);
end

ap = get_timeplot_curr_axes_params;
[curr_t, curr_t_idx] = get_curr_t;

y_min = ap.ylim(1); y_max = ap.ylim(2);

win = 10;

hf = fill([curr_t-win curr_t+win curr_t+win curr_t-win], ...
	  [y_min y_min y_max y_max], [1 0 0]);

set(hf, 'Tag', 'ev_time_marker_handle');


%**************************************************************
%*      set_eyeplot_curr_axes_params
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function set_eyeplot_curr_axes_params(ap)

my_set('ev_eyeplot_curr_axes_params', ap);


%**************************************************************
%*      set_fill_struct
%*  
%* 
%*      pskirko 7.6.01
%**************************************************************

function set_fill_struct(idx, fs);

ts = my_get('ev_timeplot_struct');
ts.fill_structs{idx} = fs;
my_set('ev_timeplot_struct', ts);

%**************************************************************
%*      set_timeplot_curr_axes_params
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function set_timeplot_curr_axes_params(ap)

my_set('ev_timeplot_curr_axes_params', ap);


%**************************************************************
%*      toggle_trail
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function toggle_trail

a = 1;

if(is_trail_on)
  a = 0;
end

my_set('ev_trail', a);

%**************************************************************
%*      update_all
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************
function update_all

  plot_eye;
  plot_time_marker;
  plot_time;
  plot_pupil; %hack: pupil must come after time. i warned you.
  update_time_display;

%**************************************************************
%*      update_time_display
%*  
%*      currently unused
%* 
%*      pskirko 6.21.01
%**************************************************************

function update_time_display

curr_t  = get_curr_t;

ms_str = num2str(curr_t);

% format tc
tc = compute_ms2tc(curr_t);
tc_str = [num2str(tc(1)), ':', num2str(tc(2)), ':', num2str(tc(3)), ':', ...
	  num2str(round(tc(4)))];

set(my_find('ev_time_text'), 'String', [ms_str, ' ms; ', ...
	     tc_str, 'tc']);


%**************************************************************
%*      write_to_file
%*  
%*      for now rewrite entire file. this is slow, might want
%*      to change it in future
%*
%*      pskirko 7.26.01
%**************************************************************

function write_to_file(fs)

if(~isempty(fs.output_file))
  save_dot_fix(fs.output_file, fs.fill);
end