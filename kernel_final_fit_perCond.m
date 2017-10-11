%clear all
%function [x,y,r]= kernel_final_fit3(x,y)
%keyboard
viz=0;
num_kernels=5;
sd=.2;
%[~,idx]=sort(y);
%y=y(idx);
%x=x(idx,:);

%  x1=randn(100,1)*2+2;
%  x2=randn(100,1)*10;
%  x3=randn(100,1)*1+5;
%  x4=x1+(randn(100,1));
%  x5=x2+(randn(100,1));
%  x6=x3+(randn(100,1));
%  y=x1.*x2.*x3+randn(100,1); %tan((0:.1:10)+10)';
%  x=[x1 x2 x3 x4 x5 x6];

%x=F_x_TrialList(:, [2 3 6]);
condlist=unique(KernelCondTrialList(:,1));



for qpq=1:length(condlist)

	tic
	clear r
	
	idx=KernelCondTrialList(:,1)==condlist(qpq);
	
	if(x_or_y)
		x=F_x_TrialList(idx, :); y=delta_eye_x_TrialList(idx,:);
	else
		x=F_y_TrialList(idx, :); y=delta_eye_y_TrialList(idx,:);
	end
	
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
	%hx=nanmedian(abs(x-nanmedian(x,1)),1)/0.6745*(4/3/num_kernels)^0.2+.01;
	%hy=nanmedian(abs(y-nanmedian(y,1)),1)/0.6745*(4/3/num_kernels)^0.2+.01;
	%r.h=sqrt(hy.*hx);
	%keyboard
	
	x_rng=[min(x); max(x)]';
	
	% for p=1:3
	% 	x_rng(p,:)=[mean(x(:,p))-std(x(:,p))*3 mean(x(:,p))+std(x(:,p))*3];
	% end
	
	%width should cover space assuming 3SD's between kernels
	r.h=(abs(x_rng(:,2)-x_rng(:,1))./num_kernels)*sd;
	
	 [xx1,xx2,xx3,xx4]=ndgrid(linspace(x_rng(1,1),x_rng(1,2),num_kernels),...
	 	linspace(x_rng(2,1),x_rng(2,2),num_kernels), ...
	 	linspace(x_rng(3,1),x_rng(3,2),num_kernels), ...
 		linspace(x_rng(4,1),x_rng(4,2),num_kernels));
	
% 	[xx1,xx2,xx3,xx4,xx5,xx6]=ndgrid(linspace(x_rng(1,1),x_rng(1,2),num_kernels),...
% 		linspace(x_rng(2,1),x_rng(2,2),num_kernels), ...
% 		linspace(x_rng(3,1),x_rng(3,2),num_kernels), ...
% 		linspace(x_rng(4,1),x_rng(4,2),num_kernels), ...
% 		linspace(x_rng(5,1),x_rng(5,2),num_kernels), ...
% 		linspace(x_rng(6,1),x_rng(6,2),num_kernels));
	
	
	vecList=[xx1(:) xx2(:) xx3(:) xx4(:)];
	
	%vecList=[xx1(:) xx2(:) xx3(:) xx4(:) xx5(:) xx6(:)];
	
	SIGMA=[r.h(1) 0 0 0 ;
		0 r.h(2) 0 0;
		0 0 r.h(3) 0;
		0 0 0 r.h(4) ];
	
% 	SIGMA=[r.h(1) 0 0  0 0 0;
% 		0 r.h(2) 0 0 0 0;
% 		0 0 r.h(3) 0 0 0;
% 		0 0 0 r.h(4) 0 0;
% 		0 0 0 0 r.h(5) 0;
% 		0 0 0 0 0 r.h(6);]
	

	%%step thru example kernel location
	for k=1:length(vecList)
		z=mvnpdf(x,vecList(k,:),SIGMA);
		r.f(k,1)=sum(z.*y)/(sum(z)); %proper 6D
	end
	
	%take original data
	%find closest vector
	clear recon
	
	for k=1:length(x)
		[val,idx]=min( sqrt(sum(x(k,:)-vecList,2).^2) );
		recon.val(k,1)=r.f(idx);
		recon.idx(k,1)=idx;
	end
	
	if(0)
		figure(808); clf;
		subplot(2,1,1); hold on
		plot(y)
		plot(recon.val)
		%plot((1:length(r.f))*(r.n/length(r.f)),r.f,'*-')
		legend('Delta C_t', '6D Prediction') %'1D Prediction',
		subplot(2,1,2); hold on
		plot(x)
	end
	
	mse(qpq,subNum)=sum((y-recon.val).^2)./length(y);
	mean_gy(qpq,subNum)=mean(y);
	
end
