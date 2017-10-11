%evaluate central bias model
[val1,~]=max(LookPropMatrixRAW_H(:,:,conditionNum),[],1);
[val2,~]=max(LookPropMatrixRAW_H(:,:,conditionNum),[],2);

[~,idx_y]=max(val1);
[~,idx_x]=max(val2);

cnt=0;
EyeDeviationList1=[];
%EyeDeviationList2=zeros(size(LookPropMatrixRAW_H,1)*size(LookPropMatrixRAW_H,2),2);
%for each bin calculate number of fixes from condition peak
for zzz=1:size(LookPropMatrixRAW_H,1)
	for ppp=1:size(LookPropMatrixRAW_H,2)
		
		if(LookPropMatrixRAW_H(zzz,ppp,conditionNum)>0)
			cnt=cnt+1;
			
			tmp=[norm([zzz ppp]-[idx_x idx_y]) abs([zzz ppp]-[idx_x idx_y]) ];
			EyeDeviationList1=[EyeDeviationList1; zeros(LookPropMatrixRAW_H(zzz,ppp,conditionNum),3)+tmp];
			%EyeDeviationList2(cnt,:)=[LookPropMatrixRAW_H(zzz,ppp,conditionNum) tmp];
		end
	end
end

EyeDeviation_PerSubCond_MEAN_XY(conditionNum, subNum)=nanmean(EyeDeviationList1(:,1));
EyeDeviation_PerSubCond_MED_XY(conditionNum, subNum)=nanmedian(EyeDeviationList1(:,1));
EyeDeviation_PerSubCond_SD_XY(conditionNum, subNum)=nanstd(EyeDeviationList1(:,1));

EyeDeviation_PerSubCond_MEAN_X(conditionNum, subNum)=nanmean(EyeDeviationList1(:,2));
EyeDeviation_PerSubCond_MED_X(conditionNum, subNum)=nanmedian(EyeDeviationList1(:,2));
EyeDeviation_PerSubCond_SD_X(conditionNum, subNum)=nanstd(EyeDeviationList1(:,2));

EyeDeviation_PerSubCond_MEAN_Y(conditionNum, subNum)=nanmean(EyeDeviationList1(:,3));
EyeDeviation_PerSubCond_MED_Y(conditionNum, subNum)=nanmedian(EyeDeviationList1(:,3));
EyeDeviation_PerSubCond_SD_Y(conditionNum, subNum)=nanstd(EyeDeviationList1(:,3));