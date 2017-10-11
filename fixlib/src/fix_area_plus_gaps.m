%computes maximal area spanned by fix1 and fix2, that is including gaps

function ans = fix_area_plus_gaps(fix)

tmp = fix(:);
ans = max(tmp) - min(tmp);
