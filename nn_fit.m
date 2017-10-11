%pool = parpool;

idx=unique(eye_pos_head_rot_AllSubs(:,end));

n_units=15;

edges=-50:50;
	
for kk=1:length(idx)
	tic
	kk_idx=~(eye_pos_head_rot_AllSubs(:,end)==idx(kk));
	nn_x=eye_pos_head_rot_AllSubs(kk_idx,3:5)';
	nn_y=eye_pos_head_rot_AllSubs(kk_idx,1)';
	
	
	net = fitnet(n_units);
	%[net,tr] = train(net,nn_x,nn_y,'useParallel','yes','showResources','yes');
	[net,tr] = train(net,nn_x,nn_y);
	nntraintool
	
	%now test on untrained file
	SimOut=sim(net, eye_pos_head_rot_AllSubs(~kk_idx,3:5)');
	fit_raw_error= eye_pos_head_rot_AllSubs(~kk_idx,1)'-SimOut;
	RMSE(kk)=sqrt( sum((eye_pos_head_rot_AllSubs(~kk_idx,1)'-SimOut).^2)./sum(~kk_idx) );
	MAE(kk)=sum(abs(eye_pos_head_rot_AllSubs(~kk_idx,1)'-SimOut))./sum(~kk_idx);
	
	[N,BIN]=histc(fit_raw_error,edges);
	bar(edges,N./sum(N),'histc')
	xlim([-50 50])
	save(['nnet_fit.sub.' num2str(idx(kk)) '.mat'],'net','tr','SimOut', 'RMSE',...
		'MAE', 'kk','fit_raw_error', 'edges','N','BIN')
	[RMSE(kk) MAE(kk)]
	toc
	keyboard
end

