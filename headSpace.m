%max_move_HeadAng, head_time, eye_time, eye_time_ff
%what is the distribution of max head moves for conditions?0
edges=0:2:180;
figure(3434); clf
for hhh=1:size(max_move_HeadAng,2)
	subplot(3,4,hhh); hold on
	tmp=squeeze(max_move_HeadAng(:,hhh,:));
	tmp=tmp(:);
	nan_idx=isnan(tmp);
	perc_nan=sum(nan_idx)./length(tmp);
	tmp=tmp(~nan_idx);
	[N,BIN] = histc(tmp,edges);
	line([mean(tmp) mean(tmp)],0:1)
	line([median(tmp) median(tmp)],0:1,'Color','red','LineStyle','--')
	bar(edges,N./sum(N));
	ylim([0 0.8])
	title([CondLabels{hhh}])
	text(60,0.7, [num2str(round(perc_nan*100)) '%'],'FontSize',20)
	xlim([edges(1) edges(end)])
	if(hhh==1)% || hhh==5 || hhh==9)
		ylabel('Proportion of Max Head Movement')
	end
	
	if(hhh==9)% || hhh==10 || hhh==11 || hhh==12)
		xlabel('Head Movement (Degrees)')
	end
	
	xlim([0 75])
	set(gca,'FontSize',22)
	set(gcf,'color','w');
end

%head-eye
eh_lat= head_time-eye_time_ff;
%eh_lat= head_time-eye_time;
edges=-2:0.1:2;
figure(3435); clf

for hhh=1:size(eh_lat,2)
	subplot(3,4,hhh); hold on
	tmp=squeeze(eh_lat(:,hhh,:));
	tmp=tmp(:);
	ylim([0 0.5])
	nan_idx=isnan(tmp);
	perc_nan=sum(nan_idx)./length(tmp);
	tmp=tmp(~nan_idx);
	[N,BIN] = histc(tmp,edges);
	bar(edges,N./sum(N));
	line([mean(tmp) mean(tmp)],0:1)
	line([median(tmp) median(tmp)],0:1,'Color','red','LineStyle','--')
	title([CondLabels{hhh}])
	text(1.1,0.45, [num2str(round(perc_nan*100)) '%'],'FontSize',20)
	xlim([edges(1) edges(end)])
	if(hhh==1)% || hhh==5 || hhh==9)
		ylabel('Proportion of Latency')
	end
	
	if(hhh==9)% || hhh==10 || hhh==11 || hhh==12)
		xlabel('Head-Eye - Latency (Sec)')
	end
	set(gca,'FontSize',22)
	set(gcf,'color','w');
end