%CBA_COMPUTE_FIX4DROP associate fixations with drops
%   LIST = CBA_COMPUTE_FIX4DROP(DROPS, FIX, T_LIM) produces for
%   each drop a struct specifying which fixations overlap that drop
%   (see CBA_NEW_DROP_STRUCT)

% $Id: cba_compute_fix4drop.m,v 1.3 2001/08/15 16:46:59 pskirko Exp $
% pskirko 6.13.01

function drop_structs = cba_compute_fix4drop(drops, fix, t_lim)

if(isempty(drops))
  drop_structs ={};
  return;
end

t_low = t_lim(1);
t_high = t_lim(2);
n = length(drops);

drop_structs = {}; idx = 1;

for i=1:n 
   t = drops(i);
   t_min = t - t_low; 
   t_max = t + t_high;

% take only fixations where:
% fix_start > t_min AND
% fix_end   < t_max

% actually, 
% do not take 
% fix_start and end < t_min
% fix_start and end > t_max

cond1 = (fix(:,1) < t_min) & (fix(:,2) < t_min);
cond2 = (fix(:,1) > t_max) & (fix(:,2) > t_max);

cond = ~(cond1 | cond2);

valid_fix = fix(find(cond),:);

%   valid_fix = (fix(:,1) > t_min) & (fix(:,2) < t_max);
%   valid_fix = fix(find(valid_fix), :);
   
   drop_structs{i} = cba_new_drop_struct(t, [t_min t_max], valid_fix);
   idx = idx + 1;
end
