%**************************************************************
%*      bfx_run
%*
%*      BFX_RUN(RUN_TYPE, FILENAME, FIX_TYPE_STRUCTS) is a 
%*      front end to browser and eyeviz.  RUN_TYPE should be
%*      either 'browser' or 'eyeviz'; FILENAME is the raw 
%*      baufix data file to use (it must be corrected to have
%*      the correct gaze, if necessary); FIX_TYPE_STRUCTS is 
%*      a cell array vector of fixation specifiers, which may
%*      or may not literally be fixations.  gaze velocity is 
%*      plotted.
%*
%*      BFX_RUN(RUN_TYPE, FILENAME, FIX_TYPE_STRUCTS, PLOT_TYPE) 
%*      is the same, where PLOT_TYPE specifies what to plot.
%*      Currently, the options are:
%*        -  
%*        - 'vel' 
%*
%*      'vel' is the default.
%* 
%*      pskirko 7.10.01
%**************************************************************

function bfx_run(run_type, filename, fix_type_structs)

color_order = {'r', 'g', 'c', 'm', 'y', 'k'};
n_color = length(color_order);

% load/compute data

ALL = bfx_load_raw(filename, 'all'); 

t = bfx_read_ALL(ALL, 'time');
gaze_h = bfx_read_ALL(ALL, 'gaze_h');
gaze_v = bfx_read_ALL(ALL, 'gaze_v');

vel = compute_vel(t, [gaze_h gaze_v]);
vel = vel.*1000; % convert deg/ms -> deg/s

if(strcmp(run_type, 'eyeviz'))
  asl_pupil = bfx_read_ALL(ALL, 'asl_pupil');
end
  
fix_list = bfx_get_fixes(filename, fix_type_structs, ALL);

% use largest vel. threshold for plotting fills

max_fill = 0;
max_vel  = 200; % hard-coded decent value

n = length(fix_type_structs);
for i=1:n
  ft = fix_type_structs{i};
  if(strcmp(ft.type, 'vt'))
    curr_fill = ft.vel_thresh / max_vel;
    if(curr_fill > max_fill)
      max_fill = curr_fill;
    end
  end
end
if max_fill == 0 max_fill = 0.5; end %default value
fill_thresh = max_fill.*max_vel; % used below


if(strcmp(run_type, 'eyeviz'));
  % --- eyeplot struct
  ps_list = cell(1, n+1);

  % first, add gaze
  ps_list{1} = new_point_struct(t, [gaze_h gaze_v], 'b+', 'gaze'); % eye gaze
  ps_list{1}.trail = 1; % turn on trail for gaze
  
  % then, add for each fix 
  for i=1:n
    fix = fix_list{i};
    ft = fix_type_structs{i};
    centroid = compute_centroid(fix, t, [gaze_h gaze_v]);
    centroid = compute_plottable_centroid(t, fix, centroid);
    
    ps_list{i+1} = new_point_struct(t, centroid, [color_order{i},'o'], ...
				    ft.type);      
  end

  bb = compute_gaze_bb(gaze_h, gaze_v);
  as = new_axes_struct(bb, bb);
  es = new_eyeplot_struct({ps_list}, as);
end

if(strcmp(run_type, 'eyeviz'))
  % --- pupilplot struct
  ps1 = new_pupil_struct(t, asl_pupil, [0.1 0.1 0.1]);
  fake_pupil = max(asl_pupil).*ones(length(asl_pupil), 1);
  ps2 = new_pupil_struct(t, fake_pupil, [0.0 0.7 0.0]);
  bb = compute_pupil_bb(asl_pupil);
  as = new_axes_struct([-100 100], [-100 100]);
  ps = new_pupilplot_struct({{ps2, ps1}}, as);
end
  
% --- timeplot struct
ps1 = new_plot_struct([t vel], 'b-', 'vel'); % add vel
fs_list = cell(1, n); 

for i=1:n
  ft = fix_type_structs{i};
  fs = fix_list{i};
  
  fs_list{i} = new_fill_struct(fs, fill_thresh.*[(i-1)/n, i/n], ...
			       color_order{mod(i, n_color)}, ...
			       [ft.type, ' fix']);
  
  if(isfield(ft, 'editable'))
    if(ft.editable) % set editable
      fs_list{i}.editable = 1;
      fs_list{i}.output_file = ft.output_file;    
    end
  end
  if(strcmp(ft.type, 'editable')) %another way
    fs_list{i}.editable = 1;
    fs_list{i}.output_file = ft.out_file;  
  end    
end

as = new_axes_struct([0 4000], [0 max_vel]);
ts = new_timeplot_struct(t, 2000, {{ps1}}, {fs_list}, as);

if(strcmp(run_type, 'browser'))
  browser(ts);
else % eyeviz
  eyeviz(es, ps, ts);
end

