%**************************************************************
%*      cba_run_browser
%*
%*      intermediate-level file; uses high-level parameters
%*      to run the low-level browser
%* 
%*      you must supply a .data file (from cba_converter) for
%*      raw data file you pass in
%*
%*
%*      pskirko 7.5.01
%**************************************************************
function cba_run(run_type, filename, fix_type_structs, plot_type, ALL)

if nargin < 3 plot_type = 'vel'; end % default

color_order = {'r', 'g', 'c', 'm', 'y', 'k'};

filename_data = [filename, '.data'];

if nargin < 5
  ALL = cba_load_data(filename_data, 'all');
end

% convert time to ms starting at 0 
t = cba_read_ALL(ALL, 'time');
t = t.*1000;
t = (t - t(1));

if(strcmp(plot_type, 'toid'))
  toid = cba_read_ALL(ALL, 'touched_object_id');
end

% compute gaze
asl_h = cba_read_ALL(ALL, 'asl_h');
asl_v = cba_read_ALL(ALL, 'asl_v');
asl_pupil = cba_read_ALL(ALL, 'asl_pupil');

if(strcmp(plot_type, 'vel')) % make sure asl data exists
  if(sum(asl_h) == 0)
    error('no asl data available; cannot compute velocities (use toid)');
  end
end

[eih_h, eih_v] = cba_pix2angle(asl_h, asl_v);
head_h = cba_read_ALL(ALL, 'fastrak_h');
head_p = cba_read_ALL(ALL, 'fastrak_p');
gaze_h = eih_h + head_h;
gaze_v = eih_v + head_p;

vel = compute_vel(t, [gaze_h gaze_v]);
vel = vel.*1000; % convert deg/ms -> deg/s

fix_list = cba_get_fixes(filename, fix_type_structs, ALL);

n = length(fix_type_structs);

if(strcmp(run_type, 'eyeviz'))
  % --- eyeplot struct
  ps_list = cell(1, n+1);
  
  % first, add gaze
  ps_list{1} = new_point_struct(t, [gaze_h gaze_v], 'b+', 'gaze'); % eye gaze
  ps_list{1}.trail = 1; % turn on trail for gaze
  
  % then, add for each fix (but skip drops)
  idx = 1;
  for i=1:n
    fix = fix_list{i};
    ft = fix_type_structs{i};
    
  %  if(strcmp(ft.type, 'drop') == 0) % NOT drop
      centroid = compute_centroid(fix, t, [gaze_h gaze_v]);
      centroid = compute_plottable_centroid(t, fix, centroid);
      
      ps_list{idx+1} = new_point_struct(t, centroid, ...
					[color_order{idx},'o'], ...
					ft.type);
      idx = idx +1;
  %  end
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
  as = new_axes_struct(bb, bb);
  ps = new_pupilplot_struct({{ps2, ps1}}, as);
end

% --- timeplot struct

% decide whether to plot vel or toid
% also decide where to plot fixes
if(strcmp(plot_type, 'toid')) %plot toid
  ps1 = new_plot_struct([t toid], 'b-', 'toid'); 
  miny = min(toid) - 1;
  maxy = max(toid) + 1;
  max_fill  = 0.5;
else
  ps1 = new_plot_struct([t vel], 'b-', 'vel');
  miny = 0;
  maxy = 200; % guess (extreme velocities should go over this val)
  
  max_fill = 0;

  for i=1:n
    ft = fix_type_structs{i};
    if(strcmp(ft.type, 'vt'))
      curr_fill = ft.vel_thresh / maxy;
      if(curr_fill > max_fill)
	max_fill = curr_fill;
      end
    end
  end
  if max_fill == 0 max_fill = 0.5; end %default value
end
fill_thresh = max_fill.*maxy + (1-max_fill).*miny; % used below   

% then, add fixations
fs_list = cell(1, n);

for i=1:n
  ft = fix_type_structs{i};
  fs = fix_list{i};
  
  lt = [ft.type, ' fix'];
  
  if(strcmp(ft.type, 'expert') & ~isempty(ft.name))
    lt = [ft.type, '( ', ft.name, ' ) fix'];
  end
  
  correct_lim = (fill_thresh - miny).*[(i-1)/n, i/n] + miny;
  fs_list{i} = new_fill_struct(fs, correct_lim, ...
			       color_order{i}, lt);
  
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


as = new_axes_struct([0 4000], [miny maxy]);
ts = new_timeplot_struct(t, 2000, {{ps1}}, {fs_list}, as);

% run gui
if(strcmp(run_type, 'eyeviz'))
  eyeviz(es, ps, ts);
else
  browser(ts);
end
