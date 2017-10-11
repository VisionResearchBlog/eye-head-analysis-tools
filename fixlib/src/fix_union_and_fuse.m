% takes union of 2 fixes. collapses consecutive agreements into 1
% large fix

function fix_union_ = fix_union_and_fuse(fix1, fix2)

[fix_code, fix_chunks] = fix_codify(fix1, fix2);

% we want fixes where code is not 0

tmp = fix_chunks(find(fix_code ~= 0), :);
%fix_union_ = tmp;

% collapse consecutive fixations 
% first compute column 2 - column 1 (shift column1 up 1 elt)
% will be 0 wherever they're consecutive

c1 = [tmp(:,1); 0];
c2 = [0; tmp(:,2)];

diff = c2 - c1; %ignore first and last entries

% convert diff to ones and zeros
diff = (diff ~= 0);

d1 = diff; d1(length(d1)) = 0;
d2 = diff; d2(1) = 0; % we ignore these vals

%d2 = diff(2:length(diff));
%d1 = diff(1:length(diff)-1);

% remove all zero codes

goodc1 = c1(find(d1 ~= 0));
goodc2 = c2(find(d2 ~= 0));

% ok this is sorta goofy, but i can't think of a better
%way at the moment

fix_union_ = [];
keep_going = 1;
while(keep_going)

  if(isempty(goodc1) | isempty(goodc2))
    keep_going = 0;
  else
    fix_union_ = [fix_union_; [goodc1(1), goodc2(1)]];
    goodc1(1) = []; goodc2(1) = [];
  end
end
 
