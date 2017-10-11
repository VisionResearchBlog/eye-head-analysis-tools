function d = calcDist(v1,v2)

d=(sqrt( (v1(:,1)-v2(:,1)).^2 + (v1(:,2)-v2(:,2)).^2 ));
return
