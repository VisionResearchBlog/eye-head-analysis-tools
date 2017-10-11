%FILTER_13PT 13 pt. filter
%   FILTER_13PT filters data with the 13 pt filter from yasser's
%   original analysis program. this is pretty unused though,
%   because it's not very useful.

% $Id: filter_13pt.m,v 1.2 2001/08/16 19:05:12 pskirko Exp $
% pskirko 8.16.01

function y = filter_13pt(x)

a = [0.019203200 -0.004184296 0.067431290 0.022965800 -0.206515100 ...
     -0.289451600 0 0.289451600 0.206515100 -0.022965800 -0.067431290 ...
     0.004184296 -0.019203200 ];

n = length(x);
y = zeros(n, 1);

for i=1:n
  tmp = 0;
  for j=1:13
    idx = i - 7 + j;
    
    if(idx > 0 & idx < n+1)
      tmp = tmp + a(j)*x(idx);
    end
  end
  y(i) = tmp;
end