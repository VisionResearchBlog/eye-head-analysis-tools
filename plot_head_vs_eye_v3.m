%plot_head_vs_eye
%color and sort according to condition & x,y position
lim_list=[-100 0; -50 50; 20 165];

pidx=[1 3 5; 2 4 6]';
plabels_y='RPH';
plabels_x='XY';

eh_dat=eye_head_trial_and_condition_segments;
eh_dat=eh_dat( sum(isnan(eh_dat),2)==0,:);
%ehdat contains                  %hpr                                           -repetion#-       -tru_trial#
%[ 1-eye_ang_x, 2-eye_ang_y 3/4/5-angular_orient(below_thresh,:) 6-conditionNum 7-mod(trialNum,9) 8-trialNum];

%plot the marginals for head orientation
figure(599); clf;
subplot(1,3,1)
hist(eh_dat(:,3),90); title('Roll')
subplot(1,3,2)
hist(eh_dat(:,4),90); title('Pitch')
subplot(1,3,3)
hist(eh_dat(:,5),90); title('Yaw/Heading')


x_lim=[-200 200; -200 200; -40 40; -40 40; -200 200; -200 200];
y_lim=[0 80; 0 60; 0 80; 0 60; 0 80; 0 60];

%global
ctr=0;
f=figure(600); clf;
for xxx=0:2 %hpr head
	for yyy=0:1 %horz/vert eye
		ctr=ctr+1;
		
		subplot(3,2,pidx(xxx+1,yyy+1)); hold on
		scatter(eh_dat(:,3+xxx),eh_dat(:,yyy+1),15,'o','filled')
		xlabel(plabels_y(xxx+1))
		ylabel(plabels_x(yyy+1))
		lsline
		[rho,pval]=corr(eh_dat(:,3+xxx),eh_dat(:,yyy+1));
		title(['r= ' num2str(rho) ', p= ' num2str(pval) ])
		xlim(x_lim(ctr,:))
		ylim(y_lim(ctr,:))
		
		%given current orientatio what is likely eye positoin?
		NW_estimate=ksr(eh_dat(:,3+xxx),eh_dat(:,yyy+1));
		plot(NW_estimate.x, NW_estimate.f,'r')
		legend('Data','Linear Regression', 'Nadara-Watson')
	end
end


%print(f,['eye_vs_head_' num2str(ppp) '.jpg'], '-djpeg')


%per condition
for ppp=1:num_Conditions
	%find the right condition
	eh_dat_idx=eh_dat(:,6)==ppp;
	eh_dat_tmp=eh_dat(eh_dat_idx,:);
	%remove nans
	eh_dat_tmp=eh_dat_tmp( sum(isnan(eh_dat_tmp),2)==0,:);
	
	f=figure(600+ppp); clf;
	
	if(~isempty(eh_dat_tmp))
		ctr=0;
		for xxx=0:2 %hpr head
			for yyy=0:1 %horz/vert eye
				ctr=ctr+1;
				subplot(3,2,pidx(xxx+1,yyy+1)); hold on
				scatter(eh_dat_tmp(:,3+xxx),eh_dat_tmp(:,yyy+1),15,'o','filled')
				xlabel(plabels_y(xxx+1))
				ylabel(plabels_x(yyy+1))
				lsline
				[rho,pval]=corr(eh_dat_tmp(:,3+xxx),eh_dat_tmp(:,yyy+1));
				title([CondLabels{ppp} ' r= ' num2str(rho) ', p= ' num2str(pval) ])
				xlim(x_lim(ctr,:))
				ylim(y_lim(ctr,:))
				
				if(sum(eh_dat_tmp(:,3+xxx))~=0)
					NW_estimate=ksr(eh_dat_tmp(:,3+xxx),eh_dat_tmp(:,yyy+1));
					plot(NW_estimate.x, NW_estimate.f,'r')
					legend('Data','Linear Regression', 'Nadara-Watson')
				end
			end
		end
		%print(f,['eye_vs_head_' num2str(ppp) '.jpg'], '-djpeg')
	end
end



%
%
%
% %9 locations, 6 conditions
% %rgb upper left pure red, bottom right pure blue
% %rgb_list=[1:-(1/5):0; zeros(1,6); 0:(1/5):1]';
% rgb_list=[1 0 0; 1 .6 .6; 0 1 0; 0 1 .6; 0 0 1; .6 .6 1];
% ctr=0;
% for nc=1:6 %num condition
% 	figure(700+nc); clf;
% 	for xxx=0:2
% 		for yyy=0:1
% 			ctr=ctr+1;
% 			idx2=find(eh_dat(:,6)==nc);
% 			for nt=1:27
% 				subplot(3,2,pidx(xxx+1,yyy+1)); hold on
% 				plot_idx=find(eh_dat(:,6)==nc & eh_dat(:,8)==nt);
% 				plot3(1:length(plot_idx),eh_dat(plot_idx,3+xxx),...
% 					eh_dat(plot_idx,yyy+1),'o',...
% 					'MarkerEdgeColor','k',...
% 					'MarkerFaceColor',rgb_list(nc,:),...
% 					'MarkerSize',5)
% 				xlabel('Time')
% 				ylabel(plabels_y(xxx+1))
% 				zlabel(plabels_x(yyy+1))
% 			end
% 		end
% 	end
% end
%
% %lets just plot the x,y from each trial (should make a 3x3 grid)
% rgb_list=[1 0 0; 1 .6 .6; 0 1 0; 0 1 .6; 0 0 1; .6 .6 1];
% ctr=0;
% for nc=1:6 %num condition
% 	figure(1700+nc); clf; hold on
% 	%for xxx=0:2
% 	%for yyy=0:1
% 	ctr=ctr+1;
% 	idx2=find(eh_dat(:,6)==nc);
% 	for nt=1:27
% 		%subplot(3,2,pidx(xxx+1,yyy+1)); hold on
% 		plot_idx=find(eh_dat(:,6)==nc & eh_dat(:,8)==nt);
% 		plot(eh_dat(plot_idx,3+xxx),eh_dat(plot_idx,yyy+1),'*',...
% 			'Color',rgb_list(nc,:))
% 		%xlabel(plabels_y(xxx+1))
% 		%ylabel(plabels_x(yyy+1))
% 	end
% 	%end
% 	%end
% end
%
%
% for nl=0:8 %num location
% 	figure(800+nl); clf
% 	ctr=0;
% 	for xxx=0:2
% 		for yyy=0:1
% 			for nc=1:6 %num condition
% 				plot_idx=find(eh_dat(:,6)==nc & eh_dat(:,7)==nl);
% 				subplot(3,2,pidx(xxx+1,yyy+1)); hold on
% 				scatter(eh_dat(plot_idx,3+xxx),eh_dat(plot_idx,yyy+1),15,...
% 					rgb_list(nc,:),'o','filled')
% 				%xlim(lim_list(xxx+1,:))
% 				xlabel(plabels_y(xxx+1))
% 				ylabel(plabels_x(yyy+1))
%
% 			end
% 			ctr=ctr+1;
%
% 			xlim(x_lim(ctr,:))
% 			ylim(y_lim(ctr,:))
%
% 		end
% 	end
%
% 	subplot(3,2,1)
% 	title(['Location: ' num2str(nl+1)]);
% 	legend(CondLabels)
% end
%
% clear eh_dat
