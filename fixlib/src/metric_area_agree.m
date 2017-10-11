% area metric for fixations
% computes : area(fix1 AGREE fix2) / area_plus_gaps(fix1 UNION fix2)

function ans = metric_area_agree(fix1, fix2)

ans = fix_area(fix_agree(fix1, fix2)) / ...
      fix_area_plus_gaps(fix_union(fix1, fix2));



