function [x,y,r]= kernel_final_fit3(x,y)
tic
viz=0;
num_kernels=20;
sd=2;

%[~,idx]=sort(y);
%y=y(idx);
%x=x(idx,:);

%remove vel & accel
x=x(1:1000,[2 3 6]);

%normalize?
% x(:,1)=x(:,1)./sum(x(:,1));
% x(:,2)=x(:,2)./sum(x(:,2));
% x(:,3)=x(:,3)./sum(x(:,3));

% [~,ii]=sort(y);
% y=y(ii);
% x=x(ii,:);

% non_z=find(y~=0);
% %most entries for eye are zero....
% y=y(non_z);
% x=x(non_z,:);

r.n=length(x);
% optimal bandwidth suggested by Bowman and Azzalini (1997) p.31
hx=nanmedian(abs(x-nanmedian(x,1)),1)/0.6745*(4/3/num_kernels)^0.2+.01;
hy=nanmedian(abs(y-nanmedian(y,1)),1)/0.6745*(4/3/num_kernels)^0.2+.01;
r.h=sqrt(hy.*hx);
%keyboard

x_rng=[min(x); max(x)]';

% for p=1:3
% 	x_rng(p,:)=[mean(x(:,p))-std(x(:,p))*3 mean(x(:,p))+std(x(:,p))*3];
% end

%width should cover space assuming 3SD's between kernels
r.h=(abs(x_rng(:,2)-x_rng(:,1))./num_kernels)*sd;

[xx1,xx2,xx3]=ndgrid(linspace(x_rng(1,1),x_rng(1,2),num_kernels),...
	linspace(x_rng(2,1),x_rng(2,2),num_kernels),...
	linspace(x_rng(3,1),x_rng(3,2),num_kernels));

vecList=[xx1(:) xx2(:) xx3(:)];

SIGMA=[r.h(1) 0 0;
	0 r.h(2) 0  ;
	0 0 r.h(3) ];

%for k=1:num_kernels %step thru example kernel location
for k=1:length(vecList)
	z=(mvnpdf(x,vecList(k,:),SIGMA));
	r.f(k)=sum(z.*y)/(sum(z)); 
end


%given our X reconstruct our predicted Y
for k=1:length(x)
	for p=1:size(vecList,2)
		tmp(:,p)=(x(k,p)-vecList(:,p)).^2;
	end
	
	[~,idx]=min( sum(tmp,2) );
	recon.val(k)=r.f(idx);
	recon.idx(k)=idx;
end

if(1)
	figure(808); clf;
	subplot(2,1,1); hold on
	plot(y)
	%plot((1:length(r.f))*(r.n/length(r.f)),r.f,'*-')
	plot(recon.val)
	legend('Delta C_t', '6D Prediction') %'1D Prediction',
	subplot(2,1,2); hold on
	plot(x)
	legend('X1','X2','X3')
end
toc
return