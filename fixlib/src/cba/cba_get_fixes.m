% this gets all the fixes requested.
% assumes you are passing it a .data file, not a raw .dat file.

function fixes = cba_get_fixes(filename_data, fix_type_structs, ALL)

if nargin < 3 ALL = cba_load_data(filename_data, 'all'); end

fixes = {};

% convert time to ms starting at 0 
t = cba_read_ALL(ALL, 'time');
t = cba_shift_time(t);

head_h = cba_read_ALL(ALL, 'fastrak_h');
head_p = cba_read_ALL(ALL, 'fastrak_p');
asl_h  = cba_read_ALL(ALL, 'asl_h');
asl_v  = cba_read_ALL(ALL, 'asl_v');
asl_pupil = cba_read_ALL(ALL, 'asl_pupil');

[eih_h, eih_v] = cba_pix2angle(asl_h, asl_v);

gaze_h = head_h + eih_h;
gaze_v = head_p + eih_v;

toid   = cba_read_ALL(ALL, 'touched_object_id');

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

    % actually do fixation
    fix = compute_fix_dt(t, [pos_h, pos_v], ft.disp_thresh, ...
			 ft.t_thresh);
  elseif(strcmp(ft.type, 'drop'))
    drops = cba_compute_drops(t, toid, ft.t_thresh);
    fix = cba_compute_plottable_drops(drops, ft.t_win); 
  elseif(strcmp(ft.type, 'expert'))
    fix = cba_load_fix_expert(ft.filename);
    fix = fix - ft.ms_start_of_data; % adjust fixes to same time
                                     % scale as time 
    fix = fix + ft.ms_offset;	% add offset			     
				    
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
       
    fix = fix_finder_vt(t, [pos_h pos_v], [asl_h,asl_v,asl_pupil], ...
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