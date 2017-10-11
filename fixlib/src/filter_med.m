%FILTER_MED median filter
%   B = FILTER_MED(A, RADIUS) filters data in A according to median 
%   filter with radius (NOT diameter) of RADIUS. result put in
%   B. inefficient implementation. uses zero to pad the ends when
%   necessary during filtering.

% $Id: filter_med.m,v 1.2 2001/08/16 19:05:13 pskirko Exp $
% pskirko 8.16.01

function b = filter_med(a, radius)

n = length(a);
b = zeros(n, 1);

a_tmp = [zeros(radius, 1); a(:); zeros(radius, 1)];

for i=1:n
   b(i) = median(a_tmp(i:i+2*radius));
end
