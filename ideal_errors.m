xy=[ 0 1; -1 1; -1 0; -1 -1; 0 -1; 1 -1; 1 0; 1 1];
xy_sz=[15 7.5; 30 15; 60 30];

for mmm=1:3
	coords= [xy(:,1)*xy_sz(mmm,1) xy(:,2)*xy_sz(mmm,2) ];
	for nnn= 1:length(coords)
		dist(nnn)=norm(coords(nnn,:));
	end
	rmse_ideal(mmm)=sqrt(mean(dist.^2));
	mean_error_ideal(mmm)=mean(dist);
end

%rmse_ideal =   14.5237   29.0474   58.0948
%mean_error_ideal =   14.0103   28.0205   56.0410