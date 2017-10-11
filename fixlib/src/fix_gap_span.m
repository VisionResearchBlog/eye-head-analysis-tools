%FIX_GAP_SPAN compute gap span
%   CODE = FIX_GAP_SPAN(FIX1, FIX2) computes the gap span of FIX1
%   over FIX2, i.e., for each gap (space between consecutive
%   fixations) in fix1, how many gaps does it overlap in fix2? The
%   resulting CODE has an entry for each gap in fix1 that contains
%   the gap count, which is naturally non-negative.
%
%   WARNING! code might not perform as expected. counting is
%   arbitrary on exact border lineups (is it a gap? not a gap)
%   currently i count it as a gap. but this can be changed to the
%   other meaning, if that is more useful

% $Id: fix_gap_span.m,v 1.3 2001/08/17 15:14:21 pskirko Exp $
% pskirko 8.17.01

function code = fix_gap_span(fix1, fix2)

n = size(fix1, 1);

code = zeros(n-1,1);

for i=1:(n-1)
  t1 = fix1(i,2);   % end of 1
  t2 = fix1(i+1,1); % start of 2

  % first discard all fixations completely to left of t1, or right
  % of t2
  
  fbegin = fix2(:,1); fend = fix2(:,2);
  
  tmp = find(~((fbegin < t1 & fend < t1) | (fbegin > t2 & fend > t2)));
  fbegin = fix2(tmp,1);
  fend = fix2(tmp,2);
  
  % check for the case that an entire fixation spans this gap, if
  % so, return 0.
  
  tmp = find((fbegin <= t1 & fend >= t2));
  if(~isempty(tmp)) % such a fixation exists
    code(i) = 0;
  else  
    % now see if any fixation overlaps the boundaries, if so, adjust
    % the boundaries to the minimal (shortest gap) set
  
    left_side =  find(fbegin < t1 & fend >= t1);  
    right_side = find(fbegin <=t2 & fend > t2);
    
    if(~isempty(left_side))
      t1 = fend(left_side);
    end
  
    if(~isempty(right_side))
      t2 = fbegin(right_side);
    end
    
    % now count the number of fixations between t1 and t2, the gap
    % span is 1 plus that number
    
    tmp = (fbegin >= t1 & fend <= t2);
    
    code(i) = 1 + sum(tmp);    
  end    
end
