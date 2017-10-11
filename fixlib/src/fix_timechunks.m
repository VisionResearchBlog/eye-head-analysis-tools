% takes the union of two fixation regions
%ok this isn't exactly a union. a better description would be is i
%take all fix begins and ends, make one big list, and divide this
%list into consecutive blocks

function u = fix_timechunks(fix1, fix2)

u = union(fix1(:,1), union(fix1(:,2), union(fix2(:,1), fix2(:, ...
						  2))));
u = u(:);

u1 = [0; u];
u2 = [u; 0];

u = [u1, u2];
u(1,:) = []; u(size(u,1),:) = [];