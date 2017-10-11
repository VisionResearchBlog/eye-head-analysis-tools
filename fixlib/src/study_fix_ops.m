%STUDY_FIX_OPS visualize fixation operations
%   see README.user.metrics (in the doc directory) for description of
%   fixation operations and metrics.

% $Id: study_fix_ops.m,v 1.2 2001/08/17 15:12:37 pskirko Exp $
% pskirko 8.15.01

clear all;

% sample fixations

fix1 = [10 20; 30 50; 55 70; 85 95];
fix2 = [5 40; 45 55; 75 80];

fixu = fix_union(fix1, fix2);
fixf = fix_union_and_fuse(fix1, fix2);
fixi = fix_intersect(fix1, fix2);
fixa = fix_agree(fix1, fix2);
fixd = fix_disagree(fix1, fix2);
fixc = fix_timechunks(fix1, fix2);

fs_list{1} = new_fill_struct(fix1, [0, 1], 'r', 'fix1');
fs_list{2} = new_fill_struct(fix2, [1, 2], 'g', 'fix2');
fs_list{3} = new_fill_struct(fixu, [2, 3], 'b', 'union');
fs_list{4} = new_fill_struct(fixf, [3, 4], 'c', 'union & fuse');
fs_list{5} = new_fill_struct(fixi, [4, 5], 'm', 'intersect');
fs_list{6} = new_fill_struct(fixa, [5, 6], 'y', 'agree');
fs_list{7} = new_fill_struct(fixd, [6, 7], 'k', 'disagree');
fs_list{8} = new_fill_struct(fixc, [7, 8], 'r', 'chunks');

bogus_t = [0, 100];

as = new_axes_struct([0, 100], [0, 10]);
ts = new_timeplot_struct(bogus_t, 2000, {{}}, {fs_list}, as);

browser(ts);

% compute metrics

% Note: fixations can also be analyzed locally, i.e. in specific regions
% of time.  It's not done here but might be useful in future

aa = metric_area_agree(fix1, fix2);
ai = metric_area_intersect(fix1, fix2);

ci12 = metric_cond_area_intersect(fix1, fix2);
ci21 = metric_cond_area_intersect(fix2, fix1);

as12 = metric_avg_span(fix1, fix2);
as21 = metric_avg_span(fix2, fix1);

ds12 = metric_dev_span(fix1, fix2);
ds21 = metric_dev_span(fix2, fix1);

gs12 = metric_avg_gap_span(fix1, fix2);
gs21 = metric_avg_gap_span(fix2, fix1);

dgs12 = metric_dev_gap_span(fix1, fix2);
dgs21 = metric_dev_gap_span(fix2, fix1);


fid = 1; %stdout

fprintf(fid, '\n-----------\nAnalysis:\n-----------\n\n');
fprintf(fid, ['area_agree:\t\t\t\t', num2str(aa), '\n']);
fprintf(fid, ['area_intersect:\t\t\t\t', num2str(ai), '\n']);

fprintf(fid, ['cond_area_intersect -> fix1 over fix2:\t', num2str(ci12), ...
	'\n']);
fprintf(fid, ['cond_area_intersect -> fix2 over fix1:\t', num2str(ci21), ...
	     '\n']);

fprintf(fid, ['avg_span -> fix1 over fix2:\t\t', num2str(as12), '\n']);
fprintf(fid, ['avg_span -> fix2 over fix1:\t\t', num2str(as21), '\n']);

fprintf(fid, ['dev_span -> fix1 over fix2:\t\t', num2str(ds12), '\n']);
fprintf(fid, ['dev_span -> fix2 over fix1:\t\t', num2str(ds21), '\n']);

fprintf(fid, ['avg_gap_span -> fix1 over fix2:\t\t', num2str(gs12), '\n']);
fprintf(fid, ['avg_gap_span -> fix2 over fix1:\t\t', num2str(gs21), '\n']);

fprintf(fid, ['dev_gap_span -> fix1 over fix2:\t\t', num2str(dgs12), '\n']);
fprintf(fid, ['dev_gap_span -> fix2 over fix1:\t\t', num2str(dgs21), '\n']);




