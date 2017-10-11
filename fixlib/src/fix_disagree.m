% disagree is the opposite of agree (see FIX_AGREE)

function fix_agree_ = fix_disagree(fix1, fix2)

[fix_code, fix_chunks] = fix_codify(fix1, fix2);

%only keep where code == 2 or code == -1

fix_agree_ = fix_chunks(fix_code == -1 | fix_code == 2, :);
