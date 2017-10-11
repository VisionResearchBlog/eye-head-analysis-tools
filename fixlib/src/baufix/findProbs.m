function transMat = findProbs(b)

objects = 13
%create empty transistion mat
transMat = zeros(objects,objects);

for t=1:size(b,3)

   for i=1:size(b,1)-1 %count along rows
       %we assume going down the row is going forward in time
       transMat(b(i),b(i+1),t) = transMat(b(i),b(i+1),t) + 1;
   end
end

return 