%evaluate central bias model
for subNum=1:size(LookPropMatrixRAW_H_PerSub,4)
	
	%train with leave one out
	pkp_idx=find(1:size(LookPropMatrixRAW_H_PerSub,3)~=subNum);
	LP_tmp=mean(mean(LookPropMatrixRAW_H_PerSub(:,:,:,pkp_idx),3),4);
	[val1,~]=max(LP_tmp,[],1);
	[val2,~]=max(LP_tmp,[],2);
	
	[~,idx_y]=max(val1);
	[~,idx_x]=max(val2);
	
	
	%for each bin calculate number of fixes from condition peak
	%now test on left out
	for conditionNum=1:12
		EyeDeviationList1=[];
		LP_test=LookPropMatrixRAW_H_PerSub(:,:,:,subNum);
		for zzz=1:size(LP_test,1)
			for ppp=1:size(LP_test,2)
				
				if(LP_test(zzz,ppp,conditionNum)>0)
					
					tmp=[norm([zzz ppp]-[idx_x idx_y]) abs([zzz ppp]-[idx_x idx_y]) ];
					EyeDeviationList1=[EyeDeviationList1; ...
						zeros(LP_test(zzz,ppp,conditionNum),3)+tmp];
				end
			end
		end
		
		EyeDeviation_AcrossSubCond_MEAN_XY(conditionNum, subNum)=nanmean(EyeDeviationList1(:,1));
		EyeDeviation_AcrossSubCond_MEAN_XY(conditionNum, subNum)=nanmedian(EyeDeviationList1(:,1));
		EyeDeviation_AcrossSubCond_MEAN_XY(conditionNum, subNum)=nanstd(EyeDeviationList1(:,1));
		
		EyeDeviation_AcrossSubCond_MEAN_XY(conditionNum, subNum)=nanmean(EyeDeviationList1(:,2));
		EyeDeviation_AcrossSubCond_MEAN_XY(conditionNum, subNum)=nanmedian(EyeDeviationList1(:,2));
		EyeDeviation_AcrossSubCond_MEAN_XY(conditionNum, subNum)=nanstd(EyeDeviationList1(:,2));
		
		EyeDeviation_AcrossSubCond_MEAN_XY(conditionNum, subNum)=nanmean(EyeDeviationList1(:,3));
		EyeDeviation_AcrossSubCond_MEAN_XY(conditionNum, subNum)=nanmedian(EyeDeviationList1(:,3));
		EyeDeviation_AcrossSubCond_MEAN_XY(conditionNum, subNum)=nanstd(EyeDeviationList1(:,3));
	end
end

figure(9193); clf;
boxplot(EyeDeviation_AcrossSubCond_MEAN_XY')

ylim([0 20])
xlabel('Condition [1:4-Small] [5:8-Medium] [9:12-Large]')
ylabel('RMS Error (Degrees)')
xlim([0 13]); ylim([0 20])
set(gca,'FontSize',24)
%legend('Kernel') %, 'Central Bias')
title('Central Bias - Leave one out')