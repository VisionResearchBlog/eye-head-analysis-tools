%COMPUTE_PLOTTABLE_PUPIL prepare pupils for eyeviz
%   [FILL_X, FILL_Y] = COMPUTE_PLOTTABLE_PUPIL(PUPIL) converts the pupil
%   diameter data in pupil in a format that can be used in eyeviz's 
%   pupilplot, i.e. it makes little things that show up as disks.
%   see cba_run.m for example.

% $Id: compute_plottable_pupil.m,v 1.2 2001/08/16 19:04:59 pskirko Exp $
% pskirko 8.16.01

function [fill_x, fill_y] = compute_plottable_pupil(pupil, xc, yc, ...
						  slices)

if nargin < 2 xc = 0; end
if nargin < 3 yc = 0; end
if nargin < 4 slices = 20; end

% static data for plotting pupils
% each column has different circle 

n = length(pupil);

for j=1:n

x = []; y = [];
r = pupil(j);
  
theta = 0;
del_theta = (2/slices)*pi;

for i=1:slices
  x(i) = r*cos(theta) + xc;
  y(i) = r*sin(theta) + yc;
 
  theta = theta + del_theta;
end

fill_x(:, j) = x';
fill_y(:, j) = y';
end
