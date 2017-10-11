% METRIC_AREA_INTERSECT area of intersection metric
%   ANS = METRIC_AREA_INTERSECT(FIX1, FIX2) computes:
%
%   ANS = area(FIX1 intersect FIX2) / area_plus_gaps(FIX1 union FIX2)
%

% $Id: metric_area_intersect.m,v 1.2 2001/08/15 15:40:52 pskirko Exp $
% pskirko 7.23.01

function ans = metric_area_intersect(fix1, fix2)

ans = fix_area(fix_intersect(fix1,fix2)) / ...
      fix_area_plus_gaps(fix_union(fix1, fix2));
