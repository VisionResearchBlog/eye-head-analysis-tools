function xy = boxPlot(num)

hold on
% Initially, the list of points is empty.
xy = [];
n = 1;
% Loop, picking up the points.
disp('Left mouse button picks points.')
disp 'Drawing box:' 
num
while n < 5
    [xi,yi] = ginput(1);
    plot(xi,yi,'ro')
 
    xy(n,:) = [xi yi];
    n = n+1;
    
    plot(xy(:,1), xy(:,2), 'r')
end

xy(5,:) = [xy(1,1) xy(1,2)];
plot(xy(:,1), xy(:,2), 'r')

hold off

%keyboard
return

