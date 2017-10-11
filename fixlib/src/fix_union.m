%takes union, does no fusing

function fix_union_ = fix_union(fix1, fix2)

[fix_code, fix_chunks] = fix_codify(fix1, fix2);

% we want fixes where code is not 0

fix_union_ = fix_chunks(find(fix_code ~= 0), :);
