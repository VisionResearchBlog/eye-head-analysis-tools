% codifies the timechunk input and fix1, fix2 according to the
% following: 1element per timechunk
%
% neither fix1 nor fix2 0
% fix1 only -1
% fix2 only  2
% fix1 and fix2 1

function [fix_code, fix_chunks] = fix_codify(fix1, fix2)

fix_chunks = fix_timechunks(fix1, fix2);

n = size(fix_chunks, 1);

for i=1:n
  t1 = fix_chunks(i,1);
  t2 = fix_chunks(i,2);
  
  fix1_is_there = 0;
  fix2_is_there = 0;
    
  i1 = find(t1 >= fix1(:,1));
  if(~isempty(i1))
     i2 = find(t2 <= fix1(i1,2));
     if(~isempty(i2)) % keep fix
       fix1_is_there = -1;
     end
  end  
  
  % repeat for fix2
  i1 = find(t1 >= fix2(:,1));
  if(~isempty(i1))
     i2 = find(t2 <= fix2(i1,2));
     if(~isempty(i2))
       fix2_is_there = 2;
     end
  end  
  
  fix_code(i) = fix1_is_there + fix2_is_there;   
end