%COMPUTE_TRANS2ANGLE computes translation "visual angles"
%  this is an archaic, vestigial piece of code. It was used to see
%  if changes in visual angle due to translation could improve
%  performance of fixation finder. it didn't, but the code remains.

% $Id: compute_trans2angle.m,v 1.2 2001/08/16 19:05:00 pskirko Exp $
% pskirko 8.16.01

function [h, v] = compute_trans2angle(x, y, z, pt)

n = length(x);
h = zeros(n,1); v = zeros(n,1); idx = 1;

% converts translations into angles computed about pt

% need unit vector parallel to y axis, pointing toward user

v2 = [0 -1 0];

xc = pt(1);
yc = pt(2);
zc = pt(3);

for i=1:n % replace this, too slow

if(i == 1) % base case

% compute horizontal angle

x1 = x(1);
y1 = y(1);

else

x1 = x(i-1);
y1 = y(i-1);

end

x2 = 0 ;
y2 =-1;

v1 = [x1-xc y1-yc];
v2 = [0 -1];

%tmp = acos(dot(v1, v2) / (norm(v1)*norm(v2)));
tmp = dot(v1, v2) / (norm(v1)*norm(v2));

if(tmp > 1) % can't happen? but why! roundoff??
tmp = 1;
elseif (tmp < -1)
tmp = -1;
end

tmp = acos(tmp);

h(idx, 1) = 180.*tmp./pi;

if(x1 > x2)
h(idx, 1) = -h(idx, 1);
end

% compute vertical angle

if i==1

z1 = z(1);

else

z1 = z(i-1);

end

z2 = 0;



v1 = [z1-zc y1-yc];
%v2 = [z2-zc y2-yc];
v2 = [0 -1];

tmp = dot(v1, v2) / (norm(v1)*norm(v2));

if(tmp > 1) % can't happen? but why! roundoff??
tmp = 1;
elseif (tmp < -1)
tmp = -1;
end

tmp = acos(tmp);

v(idx, 1) = 180.*tmp./pi;

if(z1 > z2)
v(idx, 1) = -v(idx, 1);
end

%v(idx, 1) = 180.*acos(dot(v1, v2) / (norm(v1)*norm(v2)))./pi;

idx = idx +1;

end
