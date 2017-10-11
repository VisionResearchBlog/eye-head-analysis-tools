%computes where fix1 and fix2 agree, for each one
% this is like a looser intersection, in that agreements
% are also measured over empty space
% 1 - they agree
% 0 - they don't agree

function fix_agree_ = fix_agree(fix1, fix2)

[fix_code, fix_chunks] = fix_codify(fix1, fix2);

%only keep where code == 0 or code == 1

fix_agree_ = fix_chunks(fix_code == 0 | fix_code == 1, :);

