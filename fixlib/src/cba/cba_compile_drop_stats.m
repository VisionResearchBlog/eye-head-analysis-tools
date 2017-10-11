%CBA_COMPILE_DROP_STATS companion file to CBA_STUDY_DROP_STATS
%   see that file for details

% $Id: cba_compile_drop_stats.m,v 1.7 2002/05/03 17:32:21 pilardi Exp $
% pskirko 7.20.01

% NOTE: this file could be improved by breaking out each analysis
% type into a separate file, and passing pertinent info into
% it. more modular. but, no time. pskirko  8.15.01

function cba_compile_drop_stats(filenames, fast_flag, fs_vt, fs_drop, ...
				analysis_type, summary_file)

ALL_list = load_all_files(filenames, fast_flag);

RESULT_list = {};
n = length(ALL_list);
for i=1:n
  tmp =  do_analysis(ALL_list{i}, filenames{i}, ...
		     fs_vt, fs_drop, analysis_type);
  
  RESULT_list = {RESULT_list{:}, tmp{:}};
end

MEANS_list = compute_means(RESULT_list, analysis_type);

%plot_results(MEANS_list, analysis_type);

if(~strcmp(summary_file, ''))
  save_results(MEANS_list, analysis_type, summary_file);
end

%**************************************************************
%*      compute_means
%* 
%*      
%*
%*      pskirko 6.21.01
%**************************************************************

function MEANS_list = compute_means(RESULT_list, analysis_type)

MEANS_list = {}; 

n = length(RESULT_list);

% you can do this simpler with struct arrays, i think, but oh well
% 1-  all 
% 2 - any
% 3 - most

idx1 = 1;
idx2 = 1;
idx3 = 1;

% a result list may contain all 3 types of analyses

for i=1:n
  RESULT = RESULT_list{i};

  if(strcmp(RESULT.type, 'all_overlap'))
    yc_num1(idx1) = RESULT.yc_num;
    yc_dur1(idx1) = RESULT.yc_dur;
    nc_num1(idx1) = RESULT.nc_num;
    nc_dur1(idx1) = RESULT.nc_dur;
  
    yn_num1(idx1) = RESULT.yn_num;
    yn_dur1(idx1) = RESULT.yn_dur;
    nn_num1(idx1) = RESULT.nn_num;
    nn_dur1(idx1) = RESULT.nn_dur;  
    idx1 = idx1 + 1;    
  elseif(strcmp(RESULT.type, 'one_largest_of_any_overlap'))
    yc_num2(idx2) = RESULT.yc_num;
    yc_dur2(idx2) = RESULT.yc_dur;
    nc_num2(idx2) = RESULT.nc_num;
    nc_dur2(idx2) = RESULT.nc_dur;
  
    yn_num2(idx2) = RESULT.yn_num;
    yn_dur2(idx2) = RESULT.yn_dur;
    nn_num2(idx2) = RESULT.nn_num;
    nn_dur2(idx2) = RESULT.nn_dur;  
    idx2 = idx2 + 1;      
  elseif(strcmp(RESULT.type, 'one_most_overlap'))
    yc_num3(idx3) = RESULT.yc_num;
    yc_dur3(idx3) = RESULT.yc_dur;
    nc_num3(idx3) = RESULT.nc_num;
    nc_dur3(idx3) = RESULT.nc_dur;
  
    yn_num3(idx3) = RESULT.yn_num;
    yn_dur3(idx3) = RESULT.yn_dur;
    nn_num3(idx3) = RESULT.nn_num;
    nn_dur3(idx3) = RESULT.nn_dur;  
    idx3 = idx3 + 1;    
  else
    error(['bad type: ', RESULT.type]);
  end
end

if(strcmp(analysis_type, 'all_overlap'))
  yc_num1 = mean(yc_num1);
  yc_dur1 = mean(yc_dur1);
  nc_num1 = mean(nc_num1);
  nc_dur1 = mean(nc_dur1);
  
  yn_num1 = mean(yn_num1);
  yn_dur1 = mean(yn_dur1);
  nn_num1 = mean(nn_num1);
  nn_dur1 = mean(nn_dur1); 
  
  MEANS_list{1} = struct('type', analysis_type, ...
			 'yc_num', yc_num1, ...
			 'yc_dur', yc_dur1, ...
			 'nc_num', nc_num1, ...
			 'nc_dur', nc_dur1, ...
			 'yn_num', yn_num1, ...
			 'yn_dur', yn_dur1, ...
			 'nn_num', nn_num1, ...
			 'nn_dur', nn_dur1);
elseif(strcmp(analysis_type, 'one_largest_of_any_overlap'))
  yc_num2 = mean(yc_num2);
  yc_dur2 = mean(yc_dur2);
  nc_num2 = mean(nc_num2);
  nc_dur2 = mean(nc_dur2);
  
  yn_num2 = mean(yn_num2);
  yn_dur2 = mean(yn_dur2);
  nn_num2 = mean(nn_num2);
  nn_dur2 = mean(nn_dur2); 
  
  MEANS_list{1} = struct('type', analysis_type, ...
			 'yc_num', yc_num2, ...
			 'yc_dur', yc_dur2, ...
			 'nc_num', nc_num2, ...
			 'nc_dur', nc_dur2, ...
			 'yn_num', yn_num2, ...
			 'yn_dur', yn_dur2, ...
			 'nn_num', nn_num2, ...
			 'nn_dur', nn_dur2);
elseif(strcmp(analysis_type, 'one_most_overlap'))
  yc_num3 = mean(yc_num3);
  yc_dur3 = mean(yc_dur3);
  nc_num3 = mean(nc_num3);
  nc_dur3 = mean(nc_dur3);
  
  yn_num3 = mean(yn_num3);
  yn_dur3 = mean(yn_dur3);
  nn_num3 = mean(nn_num3);
  nn_dur3 = mean(nn_dur3); 
  
  MEANS_list{1} = struct('type', analysis_type, ...
			 'yc_num', yc_num3, ...
			 'yc_dur', yc_dur3, ...
			 'nc_num', nc_num3, ...
			 'nc_dur', nc_dur3, ...
			 'yn_num', yn_num3, ...
			 'yn_dur', yn_dur3, ...
			 'nn_num', nn_num3, ...
			 'nn_dur', nn_dur3);
  
elseif(strcmp(analysis_type, 'all'))
  yc_num1 = mean(yc_num1);
  yc_dur1 = mean(yc_dur1);
  nc_num1 = mean(nc_num1);
  nc_dur1 = mean(nc_dur1);
  
  yn_num1 = mean(yn_num1);
  yn_dur1 = mean(yn_dur1);
  nn_num1 = mean(nn_num1);
  nn_dur1 = mean(nn_dur1); 
  
  MEANS_list{1} = struct('type', 'all_overlap', ...
			 'yc_num', yc_num1, ...
			 'yc_dur', yc_dur1, ...
			 'nc_num', nc_num1, ...
			 'nc_dur', nc_dur1, ...
			 'yn_num', yn_num1, ...
			 'yn_dur', yn_dur1, ...
			 'nn_num', nn_num1, ...
			 'nn_dur', nn_dur1);
  yc_num2 = mean(yc_num2);
  yc_dur2 = mean(yc_dur2);
  nc_num2 = mean(nc_num2);
  nc_dur2 = mean(nc_dur2);
  
  yn_num2 = mean(yn_num2);
  yn_dur2 = mean(yn_dur2);
  nn_num2 = mean(nn_num2);
  nn_dur2 = mean(nn_dur2); 
  
  MEANS_list{2} = struct('type', 'one_largest_of_any_overlap', ...
			 'yc_num', yc_num2, ...
			 'yc_dur', yc_dur2, ...
			 'nc_num', nc_num2, ...
			 'nc_dur', nc_dur2, ...
			 'yn_num', yn_num2, ...
			 'yn_dur', yn_dur2, ...
			 'nn_num', nn_num2, ...
			 'nn_dur', nn_dur2);
  yc_num3 = mean(yc_num3);
  yc_dur3 = mean(yc_dur3);
  nc_num3 = mean(nc_num3);
  nc_dur3 = mean(nc_dur3);
  
  yn_num3 = mean(yn_num3);
  yn_dur3 = mean(yn_dur3);
  nn_num3 = mean(nn_num3);
  nn_dur3 = mean(nn_dur3); 
  
  MEANS_list{3} = struct('type', 'one_most_overlap', ...
			 'yc_num', yc_num3, ...
			 'yc_dur', yc_dur3, ...
			 'nc_num', nc_num3, ...
			 'nc_dur', nc_dur3, ...
			 'yn_num', yn_num3, ...
			 'yn_dur', yn_dur3, ...
			 'nn_num', nn_num3, ...
			 'nn_dur', nn_dur3);
  
end

%**************************************************************
%*      do_analysis
%* 
%*      performs chosen analysis on one given file      
%*
%*      pskirko 6.21.01
%**************************************************************

function RESULT = do_analysis(ALL, filename, fs_vt, fs_drop, analysis_type)

t = cba_read_ALL(ALL, 'time');
t = cba_shift_time(t); % convert to ms from 0

asl_h = cba_read_ALL(ALL, 'asl_h');
asl_v = cba_read_ALL(ALL, 'asl_v');
asl_pupil = cba_read_ALL(ALL, 'asl_pupil');

[eih_h, eih_v] = cba_pix2angle(asl_h, asl_v);

head_h = cba_read_ALL(ALL, 'fastrak_h');
head_p = cba_read_ALL(ALL, 'fastrak_p');

gaze_h = eih_h + head_h;
gaze_v = eih_v + head_p;

vel = compute_vel(t, [gaze_h gaze_v]);
vel = vel.*1000; % convert deg/ms -> deg/s

toid = cba_read_ALL(ALL, 'touched_object_id');
o_size = cba_read_ALL(ALL, 'size');

if(sum(asl_h) == 0) % no asl data
  disp(['the file: ', filename,  ' has no asl data. analysis', ...
	'is probably meaningless']);
end

% run the vt algorithm with the given parameters
fix = fix_finder_vt(t, [gaze_h gaze_v], [asl_h,asl_v,asl_pupil], ...
		    fs_vt.clump_space_thresh, ...
		    fs_vt.clump_t_thresh, ...
		    fs_vt.track_loss_pupil_thresh, ...
		    fs_vt.t_thresh, ...
		    fs_vt.vel_thresh);    


% compute drops
drops = cba_compute_drops(t, toid, fs_drop.t_thresh);

%compute size changes
size_changes = cba_compute_size_changes(t, o_size, toid);

% divide drops into change (yc)/no_change (nc)
[yc_drops, nc_drops] = cba_partition_drops(drops, size_changes);

% noticed
noticed =     cba_load_noticed(filename);

[yn_changes, nn_changes] = cba_changes_by_noticed(t, o_size, toid, noticed);
[yn_drops, nn_drops] = cba_partition_drops(yc_drops, yn_changes); 

%for each condition, compute fixations overlapping drops, 
% and their average duration

t_win = fs_drop.t_win;

yc_drop_list = cba_compute_fix4drop(yc_drops, fix, t_win);
nc_drop_list = cba_compute_fix4drop(nc_drops, fix, t_win);

yn_drop_list = cba_compute_fix4drop(yn_drops, fix, t_win);
nn_drop_list = cba_compute_fix4drop(nn_drops, fix, t_win);

RESULT = {}; 

if(strcmp(analysis_type, 'all'))
  [yc_num, yc_dur] = analyze_all_overlap(yc_drop_list);
  [nc_num, nc_dur] = analyze_all_overlap(nc_drop_list);
  [yn_num, yn_dur] = analyze_all_overlap(yn_drop_list);
  [nn_num, nn_dur] = analyze_all_overlap(nn_drop_list);
  
  RESULT{1} = struct('type',   'all_overlap', ...
		       'yc_num', yc_num, ...
		       'yc_dur', yc_dur, ...
		       'nc_num', nc_num, ...
		       'nc_dur', nc_dur, ...
		       'yn_num', yn_num, ...
		       'yn_dur', yn_dur, ...
		       'nn_num', nn_num, ...
		       'nn_dur', nn_dur);
  
  [yc_num, yc_dur] = analyze_one_largest_of_any_overlap(yc_drop_list);
  [nc_num, nc_dur] = analyze_one_largest_of_any_overlap(nc_drop_list);
  [yn_num, yn_dur] = analyze_one_largest_of_any_overlap(yn_drop_list);
  [nn_num, nn_dur] = analyze_one_largest_of_any_overlap(nn_drop_list);
  
  RESULT{2} = struct('type',   'one_largest_of_any_overlap', ...
		       'yc_num', yc_num, ...
		       'yc_dur', yc_dur, ...
		       'nc_num', nc_num, ...
		       'nc_dur', nc_dur, ...
		       'yn_num', yn_num, ...
		       'yn_dur', yn_dur, ...
		       'nn_num', nn_num, ...
		       'nn_dur', nn_dur);
  [yc_num, yc_dur] = analyze_one_most_overlap(yc_drop_list);
  [nc_num, nc_dur] = analyze_one_most_overlap(nc_drop_list);
  [yn_num, yn_dur] = analyze_one_most_overlap(yn_drop_list);
  [nn_num, nn_dur] = analyze_one_most_overlap(nn_drop_list);
  
  RESULT{3} = struct('type',   'one_most_overlap', ...
		       'yc_num', yc_num, ...
		       'yc_dur', yc_dur, ...
		       'nc_num', nc_num, ...
		       'nc_dur', nc_dur, ...
		       'yn_num', yn_num, ...
		       'yn_dur', yn_dur, ...
		       'nn_num', nn_num, ...
		       'nn_dur', nn_dur);
elseif(strcmp(analysis_type, 'all_overlap'))
  [yc_num, yc_dur] = analyze_all_overlap(yc_drop_list);
  [nc_num, nc_dur] = analyze_all_overlap(nc_drop_list);
  [yn_num, yn_dur] = analyze_all_overlap(yn_drop_list);
  [nn_num, nn_dur] = analyze_all_overlap(nn_drop_list);
  
  RESULT{1} = struct('type',   analysis_type, ...
		       'yc_num', yc_num, ...
		       'yc_dur', yc_dur, ...
		       'nc_num', nc_num, ...
		       'nc_dur', nc_dur, ...
		       'yn_num', yn_num, ...
		       'yn_dur', yn_dur, ...
		       'nn_num', nn_num, ...
		       'nn_dur', nn_dur);
  
elseif(strcmp(analysis_type, 'one_largest_of_any_overlap'))
  [yc_num, yc_dur] = analyze_one_largest_of_any_overlap(yc_drop_list);
  [nc_num, nc_dur] = analyze_one_largest_of_any_overlap(nc_drop_list);
  [yn_num, yn_dur] = analyze_one_largest_of_any_overlap(yn_drop_list);
  [nn_num, nn_dur] = analyze_one_largest_of_any_overlap(nn_drop_list);
  
  RESULT{1} = struct('type',   analysis_type, ...
		       'yc_num', yc_num, ...
		       'yc_dur', yc_dur, ...
		       'nc_num', nc_num, ...
		       'nc_dur', nc_dur, ...
		       'yn_num', yn_num, ...
		       'yn_dur', yn_dur, ...
		       'nn_num', nn_num, ...
		       'nn_dur', nn_dur);
elseif(strcmp(analysis_type, 'one_most_overlap'))
  [yc_num, yc_dur] = analyze_one_most_overlap(yc_drop_list);
  [nc_num, nc_dur] = analyze_one_most_overlap(nc_drop_list);
  [yn_num, yn_dur] = analyze_one_most_overlap(yn_drop_list);
  [nn_num, nn_dur] = analyze_one_most_overlap(nn_drop_list);
  
  RESULT{1} = struct('type',   analysis_type, ...
		       'yc_num', yc_num, ...
		       'yc_dur', yc_dur, ...
		       'nc_num', nc_num, ...
		       'nc_dur', nc_dur, ...
		       'yn_num', yn_num, ...
		       'yn_dur', yn_dur, ...
		       'nn_num', nn_num, ...
		       'nn_dur', nn_dur);
end


%**************************************************************
%*      analyze_all_overlap
%* 
%*      num - total num overlap 
%*      dur - avg. duration of these
%*
%*      pskirko 6.21.01
%**************************************************************

function [num, dur] = analyze_all_overlap(drop_list)

num = 0;
dur = 0;

n = length(drop_list);

for i=1:n
  ds = drop_list{i};
  fix = ds.fix;
  
  if(isempty(fix))
    num(i) = 0;
    dur(i) = 0;
  else
    num(i) = size(fix,1);
    dur(i) = mean(fix(:,2) - fix(:,1));
  end  
end

num = mean(num);
dur = mean(dur);


%**************************************************************
%*      analyze_one_largest_of_any_overlap
%* 
%*      dur - avg. duration of largest fixation having any
%*      overlap with drop window
%*
%*      pskirko 6.21.01
%**************************************************************

function [num, dur] = analyze_one_largest_of_any_overlap(drop_list)

num = 0;
dur = 0;

n = length(drop_list);

for i=1:n
  ds = drop_list{i};
  fix = ds.fix;
  
  if(isempty(fix))
    num(i) = 0;
    dur(i) = 0;
  else
    num(i) = 1;
    dur(i) = max(fix(:,2) - fix(:,1));
  end  
end

num = mean(num);
dur = mean(dur);

%**************************************************************
%*      analyze_one_most_overlap
%* 
%*      dur - avg. duration of one fixation having most 
%*      overlap with drop window
%*
%*      pskirko 6.21.01
%**************************************************************

function [num, dur] = analyze_one_most_overlap(drop_list)

num = 0;
dur = 0;

n = length(drop_list);

for i=1:n
  ds = drop_list{i};
  fix = ds.fix;
  drop = [ds.t - ds.t_win(1), ds.t + ds.t_win(2)];
  
  if(isempty(fix))
    num(i) = 0;
    dur(i) = 0;
  else
    num(i) = 1;
    % compute conditional area intersection of each fix with drop
    
    n = size(fix, 1);
    
    overlap = -1;
    best_fix = [];
    
    for i=1:n
      curr_fix = fix(i, :);
      curr_overlap = metric_cond_area_intersect(curr_fix, drop);
      
      if(curr_overlap > overlap)
	overlap = curr_overlap;
	best_fix = curr_fix;
      end          
    end
    
    if(isempty(best_fix)) % should not happen
      num(i) = 0;
      dur(i) = 0; 
    else
      num(i) = 1;
      dur(i) = best_fix(2) - best_fix(1);        
    end  
  end
end

num = mean(num);
dur = mean(dur);

%**************************************************************
%*      load_all_files
%* 
%*      pskirko 6.21.01
%**************************************************************

function ALL_list = load_all_files(filenames, fast_flag)

ALL_list = {}; idx = 1;

n = length(filenames);

for i=1:n
  filename = filenames{i};
  
  if(fast_flag == 1) %try to use fast_load
    ALL = fast_load(filename);
    
    if(~iscell(ALL)) % fast_load failed
      disp(['fast_load failed for ', filename, ...
	   '; will save this using fast_save']);
            
      ALL = cba_load_data([filename, '.data'], 'all');      
      fast_save(filename, ALL);
      ALL_list{idx} = ALL; idx = idx + 1;
      
    else %load succeeded
      ALL_list{idx} = ALL; idx = idx + 1;
    end
    
  else % use non-fast method    
    ALL = cba_load_data([filename, '.data'], 'all');
    ALL_list{idx} = ALL; idx = idx + 1;
  end   
end

%**************************************************************
%*      plot_results
%* 
%*      pskirko 6.21.01
%**************************************************************

function plot_results(MEANS_list, analysis_type)
if 0 % old code

yc_num = [];
yc_dur = [];
nc_num = [];
nc_dur = [];

n = length(RESULT_list);

for i=1:n % compile means across all files
  R = RESULT_list{i};
  yc_num(i) = R.yc_num;
  yc_dur(i) = R.yc_dur;
  nc_num(i) = R.nc_num;
  nc_dur(i) = R.nc_dur;
end

yc_mean_num = mean(yc_num);
yc_mean_dur = mean(yc_dur);
yc_std_dur  = std(yc_dur) / sqrt(n);
nc_mean_num = mean(nc_num);
nc_mean_dur = mean(nc_dur);
nc_std_dur  = std(nc_dur) / sqrt(n);

figure(1); clf;
bar([yc_mean_dur, nc_mean_dur]');
hold on;
errorbar([1, 2], [yc_mean_dur, nc_mean_dur], [yc_std_dur, nc_std_dur], 'k.');
title([analysis_type, ': durations'], 'Interpreter', 'none');
set(gca, 'XTickLabel', {'size change'; 'no size change'});
hold off;

if(strcmp(analysis_type, 'all_overlap'))
  figure(2); clf;
  bar([yc_mean_num, nc_mean_num]');
  title([analysis_type, ': num'], 'Interpreter', 'none');
  set(gca, 'XTickLabel', {'size change'; 'no size change'});
end
end

%**************************************************************
%*      save_results
%* 
%*      pskirko 6.21.01
%**************************************************************

function save_results(MEANS_list, analysis_type, summary_file)

% 1-  all 
% 2 - any
% 3 - most

  yc_num1 = 0;
  yc_dur1 = 0;
  nc_num1 = 0;
  nc_dur1 = 0;
  
  yn_num1 = 0;
  yn_dur1 = 0;
  nn_num1 = 0;
  nn_dur1 = 0; 

  yc_num2 = 0;
  yc_dur2 = 0;
  nc_num2 = 0;
  nc_dur2 = 0;
  
  yn_num2 = 0;
  yn_dur2 = 0;
  nn_num2 = 0;
  nn_dur2 = 0; 

  yc_num3 = 0;
  yc_dur3 = 0;
  nc_num3 = 0;
  nc_dur3 = 0;
  
  yn_num3 = 0;
  yn_dur3 = 0;
  nn_num3 = 0;
  nn_dur3 = 0;  
  
if(strcmp(analysis_type, 'all_overlap'))
  MEANS = MEANS_list{1};
  
  yc_num1 = MEANS.yc_num;
  yc_dur1 = MEANS.yc_dur;
  nc_num1 = MEANS.nc_num;
  nc_dur1 = MEANS.nc_dur;
  
  yn_num1 = MEANS.yn_num;
  yn_dur1 = MEANS.yn_dur;
  nn_num1 = MEANS.nn_num;
  nn_dur1 = MEANS.nn_dur; 
elseif(strcmp(analysis_type, 'one_largest_of_any_overlap'))
  MEANS = MEANS_list{1};
  
  yc_num2 = MEANS.yc_num;
  yc_dur2 = MEANS.yc_dur;
  nc_num2 = MEANS.nc_num;
  nc_dur2 = MEANS.nc_dur;
  
  yn_num2 = MEANS.yn_num;
  yn_dur2 = MEANS.yn_dur;
  nn_num2 = MEANS.nn_num;
  nn_dur2 = MEANS.nn_dur; 
elseif(strcmp(analysis_type, 'one_most_overlap'))
  MEANS = MEANS_list{1};
  
  yc_num3 = MEANS.yc_num;
  yc_dur3 = MEANS.yc_dur;
  nc_num3 = MEANS.nc_num;
  nc_dur3 = MEANS.nc_dur;
  
  yn_num3 = MEANS.yn_num;
  yn_dur3 = MEANS.yn_dur;
  nn_num3 = MEANS.nn_num;
  nn_dur3 = MEANS.nn_dur;   

elseif(strcmp(analysis_type, 'all'))

  for i=1:3
    MEANS = MEANS_list{i};
    
    if(strcmp(MEANS.type, 'all_overlap'))  
      yc_num1 = MEANS.yc_num;
      yc_dur1 = MEANS.yc_dur;
      nc_num1 = MEANS.nc_num;
      nc_dur1 = MEANS.nc_dur;
      
      yn_num1 = MEANS.yn_num;
      yn_dur1 = MEANS.yn_dur;
      nn_num1 = MEANS.nn_num;
      nn_dur1 = MEANS.nn_dur; 
    elseif(strcmp(MEANS.type, 'one_largest_of_any_overlap'))  
      yc_num2 = MEANS.yc_num;
      yc_dur2 = MEANS.yc_dur;
      nc_num2 = MEANS.nc_num;
      nc_dur2 = MEANS.nc_dur;
      
      yn_num2 = MEANS.yn_num;
      yn_dur2 = MEANS.yn_dur;
      nn_num2 = MEANS.nn_num;
      nn_dur2 = MEANS.nn_dur; 
    elseif(strcmp(MEANS.type, 'one_most_overlap'))           
      yc_num3 = MEANS.yc_num;
      yc_dur3 = MEANS.yc_dur;
      nc_num3 = MEANS.nc_num;
      nc_dur3 = MEANS.nc_dur;
      
      yn_num3 = MEANS.yn_num;
      yn_dur3 = MEANS.yn_dur;
      nn_num3 = MEANS.nn_num;
      nn_dur3 = MEANS.nn_dur;         
    end
  end  
end


fid = fopen(summary_file, 'w');

fprintf(fid, 'MEAN DURATION OF FIXATIONS:\n');
fprintf(fid, '\t\t\tNo Change\tChange\tUnnoticed\tNoticed\n');
fprintf(fid, 'one_most_overlap\t\t%g\t%g\t%g\t%g\t\n', ...
	nc_dur3, yc_dur3, nn_dur3, yn_dur3);
fprintf(fid, 'all_overlap\t\t\t%g\t%g\t%g\t%g\t\n', ...
	nc_dur1, yc_dur1, nn_dur1, yn_dur1);
fprintf(fid, 'one_largest_of_any_overlap\t%g\t%g\t%g\t%g\t\n', ...
	nc_dur2, yc_dur2, nn_dur2, yn_dur2);
fprintf(fid, '\n');
fprintf(fid, 'MEAN NUMBER OF FIXATIONS:\n');
fprintf(fid, '\t\t\tNo Change\tChange\tUnnoticed\tNoticed\n');
fprintf(fid, 'one_most_overlap\t\t%g\t%g\t%g\t%g\t\n', ...
	nc_num3, yc_num3, nn_num3, yn_num3);
fprintf(fid, 'all_overlap\t\t\t%g\t%g\t%g\t%g\t\n', ...
	nc_num1, yc_num1, nn_num1, yn_num1);
fprintf(fid, 'one_largest_of_any_overlap\t%g\t%g\t%g\t%g\t\n', ...
	nc_num2, yc_num2, nn_num2, yn_num2);	

fclose(fid);
