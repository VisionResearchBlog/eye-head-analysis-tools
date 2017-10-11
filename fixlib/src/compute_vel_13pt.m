%COMPUTE_VEL_13PT computes velocities using 13-pt filter
%   This is a vestigial piece of code, it takes space data and uses 
%   the 13-pt filter from yasser's original fixation finder program 
%   to compute velocities.  unfortunately, using the filter seems
%   to have absolutely no positive value, so we don't use it.

% $Id: compute_vel_13pt.m,v 1.2 2001/08/16 19:05:04 pskirko Exp $
% pskirko 8.16.01

function vel = compute_vel_13pt(x)

n = size(x,1);
m = size(x,2);

x2 = zeros(n,m);

for i=1:m
  x2(:,i) = filter_13pt(x(:,i));
end

vel = [sqrt(sum(abs(x2').^2, 1))]';
