%FIX_SPAN computes the span of fix1 over fix2
%   CODE = FIX_SPAN(FIX1, FIX2) computes, for each fixation in FIX1,
%   how many fixations does it overlap in FIX2.  If two fixations 
%   only share one border (e.g., [1 2] and [2 3]), the span is 0,
%   NOT 1.

% $Id: fix_span.m,v 1.3 2001/08/17 15:13:32 pskirko Exp $
% pskirko 8.15.01

function code = fix_span(fix1, fix2)

n = size(fix1, 1);
code = zeros(n,1);

fbegin = fix2(:,1);
fend = fix2(:,2);
  
for i=1:n
  t1 = fix1(i,1);
  t2 = fix1(i,2);

  tmp = (fbegin <= t1 & fend <= t1) | (fbegin >= t2 & fend >= t2);
  code(i) = sum(~tmp);    		  
end
