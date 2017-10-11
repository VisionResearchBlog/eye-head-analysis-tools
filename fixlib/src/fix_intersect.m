%does intersection of fix1 and fix2

function fix_intersect_ = fix_intersect(fix1, fix2)

[fix_code, fix_chunks] = fix_codify(fix1, fix2);

% keep only where code ==1

fix_intersect_ = fix_chunks(find(fix_code == 1),:);