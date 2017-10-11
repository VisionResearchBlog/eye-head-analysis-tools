% this gets all the fixes requested.

function fixes = bfx_get_fixes(filename, fix_type_structs, ALL)

if nargin < 3 ALL = bfx_load_raw(filename, 'all'); end

fixes = {};

t = bfx_read_ALL(ALL, 'time');

asl_h = bfx_read_ALL(ALL, 'asl_h');
asl_v = bfx_read_ALL(ALL, 'asl_v');
asl_pupil = bfx_read_ALL(ALL, 'asl_pupil');

eih_h = bfx_read_ALL(ALL, 'eih_h');
eih_v = bfx_read_ALL(ALL, 'eih_v');

gaze_h = bfx_read_ALL(ALL, 'gaze_h');
gaze_v = bfx_read_ALL(ALL, 'gaze_v');

n = length(fix_type_structs);

for i=1:n
  ft = fix_type_structs{i};
  fix = [];
  
  if(strcmp(ft.type, 'dt'))    
    % determine eye data type
    if(strcmp(ft.eye_data_type, 'asl'))
      pos_h = asl_h;
      pos_v = asl_v;      
    elseif(strcmp(ft.eye_data_type, 'eih'))
      pos_h = eih_h;
      pos_v = eih_v;
    elseif(strcmp(ft.eye_data_type, 'gaze'))      
      pos_h = gaze_h;
      pos_v = gaze_v;
    end
    
    fix = compute_fix_dt(t, [pos_h, pos_v], ft.disp_thresh, ft.t_thresh);  
  
  elseif(strcmp(ft.type, 'editable'))
    if(isempty(ft.in_file))
      fix = [];
    else
      try,
	fix = load_dot_fix(ft.in_file);
      catch, 
	fix = [];
      end
    end
  elseif(strcmp(ft.type, 'expert'))
    fix = bfx_load_fix_expert(ft.filename);
    fix = fix + ft.ms_offset; % add offset 
  elseif(strcmp(ft.type, 'raw'))
    fix = ft.fix;
  elseif(strcmp(ft.type, 'vt'))
    % determine eye data type
    if(strcmp(ft.eye_data_type, 'asl'))
      pos_h = asl_h;
      pos_v = asl_v;      
    elseif(strcmp(ft.eye_data_type, 'eih'))
      pos_h = eih_h;
      pos_v = eih_v;
    elseif(strcmp(ft.eye_data_type, 'gaze'))      
      pos_h = gaze_h;
      pos_v = gaze_v;
    end
    
    fix = fix_finder_vt(t, [pos_h pos_v], [asl_h, asl_v,asl_pupil], ...
			ft.clump_space_thresh, ...
			ft.clump_t_thresh, ...
			ft.track_loss_pupil_thresh, ...
			ft.t_thresh, ...
			ft.vel_thresh);    
  else
    error(['unknown fix type: ' ft.type]);
  end
  
  fixes{i} = fix;
end