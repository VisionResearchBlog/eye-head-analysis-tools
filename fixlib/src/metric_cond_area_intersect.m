% METRIC_COND_AREA_INTERSECT area of intersection metric
%   ANS = METRIC_COND_AREA_INTERSECT(FIX1, FIX2) computes:
%
%   ANS = area(FIX1 intersect FIX2) / area(FIX2)

% $Id: metric_cond_area_intersect.m,v 1.1 2001/07/23 15:29:55 pskirko Exp $
% pskirko 7.23.01

function ans = metric_cond_area_intersect(fix1, fix2)

ans = fix_area(fix_intersect(fix1, fix2)) / fix_area(fix2);
