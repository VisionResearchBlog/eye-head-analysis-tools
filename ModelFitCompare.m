figure(666); clf; %hold on
fsz=14;

subplot(4,1,1)
boxplot(EyeDeviation_PREDICT_PerSubCond_MEAN_XY') %kernel
ylabel('RMS Error (Degrees)')
xlim([0 13]); ylim([0 35])
text(0,20,'Kernel Method','FontSize',fsz)
set(gca,'FontSize',fsz)

KernelMeth_R=convert_to_R_data(EyeDeviation_PREDICT_PerSubCond_MEAN_XY,flist);
CentralBias_R=convert_to_R_data(EyeDeviation_AcrossSubCond_MEAN_XY,flist);
Fang_R=convert_to_R_data( squeeze(nanmean(fang_pred_list,1)) ,flist);



subplot(4,1,2)
boxplot(RMSE_PerCond) 
ylabel('RMS Error (Degrees)')
xlim([0 13]); ylim([0 35])
text(0,20,'Single Layer NN - 15 Units','FontSize',fsz)
set(gca,'FontSize',fsz)

subplot(4,1,3)
boxplot(squeeze(nanmean(fang_pred_list,3)))
ylim([0 20])
ylabel('RMS Error (Degrees)')
xlim([0 13]); ylim([0 35])
text(0,20,'Fang et al 2015 Model Fit','FontSize',fsz)
set(gca,'FontSize',fsz)

subplot(4,1,4)
boxplot(EyeDeviation_AcrossSubCond_MEAN_XY')
ylim([0 35])
xlabel('Condition [1:4-Small] [5:8-Medium] [9:12-Large]')
ylabel('RMS Error (Degrees)')
xlim([0 13]); ylim([0 35])
text(0,20,'Central Bias','FontSize',fsz)
set(gca,'FontSize',fsz)

set(gcf,'color','w');



