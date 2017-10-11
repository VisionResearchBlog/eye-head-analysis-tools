figure(101);clf; hold on
plot(nanmean(nanmean(percent_of_trial_used,1),3),'*-')
xticks(1:12)
xticklabels(CondLabels)
xtickangle(60)
ylim([0 0.3])
ylabel('Percent of Data Processed')
set(gca,'FontSize',20)
grid on
