%pool = parpool;
%Kernel_PerSubCondTrialList
%Fx_pred_PerTrial_PerSub
%Fy_pred_PerTrial_PerSub

idx=unique(Kernel_PerSubCondTrialList(:,end));

n_units=20;

edges=-50:50;

for kk=1:length(idx)
	tic
	kk_idx=~(Kernel_PerSubCondTrialList(:,end)==idx(kk));
	nn_x=Fx_pred_PerTrial_PerSub(kk_idx,1:5)';
	nn_y=Fx_pred_PerTrial_PerSub(kk_idx,7)';
	
	net = fitnet(n_units);
	%[net,tr] = train(net,nn_x,nn_y,'useParallel','yes','showResources','yes');
	[net,tr] = train(net,nn_x,nn_y);
	nntraintool
	
	%now test on untrained file
	%test global
	SimOut=sim(net, Fx_pred_PerTrial_PerSub(~kk_idx,1:5)');
	fit_raw_error= Fx_pred_PerTrial_PerSub(~kk_idx,7)'-SimOut;
	RMSE(kk)=sqrt( sum((Fx_pred_PerTrial_PerSub(~kk_idx,7)'-SimOut).^2)./sum(~kk_idx) );
	MAE(kk)=sum(abs(Fx_pred_PerTrial_PerSub(~kk_idx,7)'-SimOut))./sum(~kk_idx);
	
	if(viz_AcrossSubjects)
		figure(26);clf
		[N,BIN]=histc(fit_raw_error,edges);
		bar(edges,N./sum(N),'histc')
		xlim([-50 50])
		
		save(['nnet_fit.sub.' num2str(idx(kk)) '.mat'],'net','tr','SimOut', 'RMSE',...
			'MAE', 'kk','fit_raw_error', 'edges','N','BIN')
	end
	
	[RMSE(kk) MAE(kk)]
	
	if(viz_perSubject)
		figure(27);clf
	end
	
	%---now per trial type
	for tt=1:12
		tmp_idx=Kernel_PerSubCondTrialList(:,1)==tt;
		tt_idx=~kk_idx & tmp_idx;
		
		SimOut=sim(net, Fx_pred_PerTrial_PerSub(tt_idx,1:5)');
		fit_raw_error= Fx_pred_PerTrial_PerSub(tt_idx,7)'-SimOut;
		RMSE_PerCond(kk,tt)=sqrt( sum((Fx_pred_PerTrial_PerSub(tt_idx,7)'-SimOut).^2)./sum(tt_idx) );
		MAE_PerCond(kk,tt)=sum(abs(Fx_pred_PerTrial_PerSub(tt_idx,7)'-SimOut))./sum(tt_idx);
		
		
		if(viz_perSubject)
			subplot(3,4,tt); hold on
			[N,BIN]=histc(fit_raw_error,edges);
			bar(edges,N./sum(N),'histc')
			xlim([-50 50])
			save(['nnet_fit.sub.' num2str(idx(kk)) '.mat'],'net','tr','SimOut', 'RMSE',...
				'MAE', 'kk','fit_raw_error', 'edges','N','BIN')
			title([num2str(tt) ': ' num2str([RMSE(kk) MAE(kk)]) ])
		end
	end
	
	toc
end



	figure(8292); clf; hold on
	%plot(mean(EyeDeviation_PerSubCond_AVE,2))
	%errorbar(1:12, mean(EyeDeviation_PerSubCond_MEAN_XY,2), ...
	%	std(EyeDeviation_PerSubCond_MEAN_XY,[],2)./sqrt(size(EyeDeviation_PerSubCond_MEAN_XY,2)))
	%boxplot(EyeDeviation_PerSubCond_MEAN_XY') % central bias
	boxplot(RMSE_PerCond) %kernel
	
	xlabel('Condition [1:4-Small] [5:8-Medium] [9:12-Large]')
	ylabel('RMS Error (Degrees)')
	xlim([0 13]); ylim([0 20])
	%title('Central Bias - Peak of Fix PDF')
	set(gca,'FontSize',24)
	title('NN Fit - 15 units')
	