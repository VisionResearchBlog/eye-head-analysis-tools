% computes area spanned by fixation "coverage"
% this area does not include gaps. gaps are the things between fixations.

function ans = fix_area(fix)

ans = sum(fix(:,2) - fix(:,1));
