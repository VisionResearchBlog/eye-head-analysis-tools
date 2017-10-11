%**************************************************************
%*      THIS FILE IS OBSOLETE. USE CBA_RUN.M INSTEAD. 
%*      it should probably be removed from cvs
%*  
%*
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
function cba_run_browser(filename, fix_type_structs, plot_type)

if nargin < 3 plot_type = 'vel'; end

color_order = {'r', 'g', 'c', 'm', 'y', 'k'};

filename_data = [filename '.data'];
ALL = cba_load_data(filename_data, 'all');
t = ALL{2};
t = t.*1000;
t = (t - t(1));

toid = ALL{18};
o_size = ALL{22};

% compute gaze
asl_h = ALL{16};
asl_v = ALL{17};
asl_pupil = ALL{15};

if(strcmp(plot_type, 'vel')) % make sure asl data exists
  if(sum(asl_h) == 0)
    error('no asl data available; cannot compute velocities (use toid)');
  end
end

[eih_h, eih_v] = cba_pix2angle(asl_h, asl_v);
head_h = ALL{12};
head_p = ALL{13};
gaze_h = eih_h + head_h;
gaze_v = eih_v + head_p;

vel = compute_vel(t, [gaze_h gaze_v]);
vel = vel.*1000;

n = length(fix_type_structs);

% load fixations
if(strcmp(plot_type, 'toid'))
  vel_thresh = 2;
elseif(strcmp(plot_type, 'size'))
  vel_thresh = 40;
else
  vel_thresh = 60; %default
end

fix_list = cell(1, n);
for i=1:n
  ft = fix_type_structs{i};
  fix = [];
  
  if(strcmp(ft.type, 'vt'))
    if(ft.vel_thresh > vel_thresh)
      vel_thresh = ft.vel_thresh;
    end
    
    fix = compute_fix_vt(t, vel,  ft.vel_thresh, ft.t_thresh);
%   elseif(strcmp(ft.type, 'drops'))    
%    fix = cba_compute_drops(t, toid, ft.t_thresh);
%    fix = cba_drop2fill(fix, ft.t_win);
  
  elseif(strcmp(ft.type, 'dt'))    
    fix = compute_fix_dt(t, [gaze_h gaze_v], ft.disp_thresh, ft.t_thresh);
  elseif(strcmp(ft.type, 'expert'))
    if(isempty(ft.filename))
      fix = cba_load_fix_expert([filename '.fix.expert']);
    else
      fix = cba_load_fix_expert(ft.filename);
    end
    fix = fix - ft.ms_start_of_data; % adjust fixes to same time
                                     % scale as time
  elseif(strcmp(ft.type, 'drop'))
    drops = cba_compute_drops(t, toid, ft.t_thresh);
    fix = cba_compute_plottable_drops(drops, ft.t_win);
  else
    error(['unknown fix type: ' ft.type]);
  end
  
  fix_list{i} = fix;
end

% --- eyeplot struct
ps_list = cell(1, n+1);

% first, add gaze
ps_list{1} = new_point_struct(t, [gaze_h gaze_v], 'bo', 'gaze'); % eye gaze

% then, add for each fix (but skip drops)
idx = 1;
for i=1:n
  fix = fix_list{i};
  ft = fix_type_structs{i};
  
  if(strcmp(ft.type, 'drop') == 0) % NOT drop
    centroid = compute_centroid(fix, t, [gaze_h gaze_v]);
    centroid = compute_plottable_centroid(t, fix, centroid);
    
    ps_list{idx+1} = new_point_struct(t, centroid, ...
				      [color_order{idx},'+'], ...
				      ft.type);
    idx = idx +1;
    end
end

as = new_axes_struct([-25 25], [-25 25]);
es = new_eyeplot_struct({ps_list}, as);

% --- pupilplot struct
ps1 = new_pupil_struct(t, asl_pupil, [0.1 0.1 0.1]);
fake_pupil = max(asl_pupil).*ones(length(asl_pupil), 1);
ps2 = new_pupil_struct(t, fake_pupil, [0.0 0.7 0.0]);
as = new_axes_struct([-100 100], [-100 100]);
ps = new_pupilplot_struct({{ps2, ps1}}, as);

% --- timeplot struct

% first, add vel
if(strcmp(plot_type, 'toid')) %plot toid
  toid = cba_cleanup_toid(t, toid, 500);
  ps1 = new_plot_struct([t (toid +1)], 'b-', 'toid'); 
elseif(strcmp(plot_type, 'size'))
  ps1 = new_plot_struct([t o_size], 'b-', 'size');
else
  ps1 = new_plot_struct([t vel], 'b-', 'vel');
end
  
ps2 = cba_compute_size_changes( );

% then, add fixations
fs_list = cell(1, n);

for i=1:n
  ft = fix_type_structs{i};
  fs = fix_list{i};
  
  lt = [ft.type, ' fix'];
  
  if(strcmp(ft.type, 'expert'))
    lt = [ft.type, '( ', ft.name, ' ) fix'];
  end
  
  fs_list{i} = new_fill_struct(fs, vel_thresh.*[(i-1)/n, i/n], ...
			       color_order{i}, lt);
end


as = new_axes_struct([0 4000], [0 3*vel_thresh]);
ts = new_timeplot_struct(t, 2000, {{ps1, ps2}}, {fs_list}, as);

% run gui
browser(ts);
