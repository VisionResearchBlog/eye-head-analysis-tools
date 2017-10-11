% returns those fixes in fix1 that fit entirely in fix2. 
% by fit entirely, i'll explain it later. 
%
% also returns a code, same length as original fix list, 
% 1= this fix is good, 0 = this fix was rejected
%
% this really hasn't been used, kept for novelty purposes

function [fix_fit, fix_fit_code] = fix_fits_in(fix1, fix2)  

n = size(fix1, 1);
fix_fit = []; 
fix_fit_code = zeros(n,1);

for i=1:n
  t1 = fix1(i,1);
  t2 = fix1(i,2);
  
  i1 = find(t1 >= fix2(:,1));
  if(~isempty(i1))
    i2 = find(t2 <= fix2(i1,2));
    if(~isempty(i2)) % keep fix
      fix_fit_code(i) = 1;
      fix_fit = [fix_fit; [t1, t2]];
    end
  end  
  
end