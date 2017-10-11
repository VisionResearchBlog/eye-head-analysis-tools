%old_t=(1:length(xeye))';
%new_t=(1:((length(x)-1)/(length(mocap_sixdof))):length(x))';
%interp_x=interp1( old_t, xeye, new_t(1:length(mocap_sixdof)),'linear');
%interp_y=interp1( old_t, yeye, new_t(1:length(mocap_sixdof)),'linear');

figure(3); clf
subplot(3,3,1)
plot(mocap_sixdof(tmp_idx_mocap,6))%h
ylabel('Heading-Degrees')
%ylim([-180 180])

subplot(3,3,4)
plot(mocap_sixdof(tmp_idx_mocap,7))%p
ylabel('Pitch-Degrees')
%ylim([-180 180])

subplot(3,3,7)
plot(mocap_sixdof(tmp_idx_mocap,8))%r
ylabel('Roll-Degrees')
%ylim([-180 180])


subplot(3,3,2)
plot(interp_y,mocap_sixdof(tmp_idx_mocap,6),'*-')%h
%xlim([0 maxVidResY])
%ylim([-180 180])

subplot(3,3,5)
plot(interp_y,mocap_sixdof(tmp_idx_mocap,7),'*-')%p
%xlim([0 maxVidResY])
%ylim([-180 180])

subplot(3,3,8)
plot(interp_y,mocap_sixdof(tmp_idx_mocap,8),'*-')%r
%xlim([0 maxVidResY])
%ylim([-180 180])

subplot(3,3,3)
plot(interp_x,mocap_sixdof(tmp_idx_mocap,6),'*-')%h
%xlim([0 maxVidResX])
%ylim([-180 180])

subplot(3,3,6)
plot(interp_x,mocap_sixdof(tmp_idx_mocap,7),'*-')%p
%xlim([0 maxVidResX])
%ylim([-180 180])

subplot(3,3,9)
plot(interp_x,mocap_sixdof(tmp_idx_mocap,8),'*-')%r
%xlim([0 maxVidResX])
%ylim([-180 180])


% figure(4); clf;
% subplot(2,1,1)
% xlim([-1000 2000])
% ylim([-1000 2000])
% hold on
% %plot(interp_x,interp_y)
% plot( eye_data.BPORX_px_, eye_data.BPORY_px_)
% %plot(xeye,yeye); 
% subplot(2,1,2); hold on
% plot(eye_data.BPORX_px_)
% plot(eye_data.BPORY_px_)
% legend('x','y')
% ylim([-2000 2000])
% 
figure(99); clf
plotidx=[1 3 5];
for zz=1:3
    subplot(3,2,plotidx(zz)); hold on
    plot(eye_head_data_Array(:,2), eye_head_data_Array(:,6+zz),'*')
    lsline
    [rho,p]=corr(eye_head_data_Array(:,2), eye_head_data_Array(:,6+zz));
%     xlim([0 maxVidResX])
%     ylim([-180 180])
    title(['r=' num2str(rho) ', p=' num2str(p)])
end

plotidx=[2 4 6];
for zz=1:3
    subplot(3,2,plotidx(zz)); hold on
    plot(eye_head_data_Array(:,3), eye_head_data_Array(:,6+zz),'*')
    lsline
    [rho,p]=corr(eye_head_data_Array(:,3), eye_head_data_Array(:,6+zz));
%     xlim([0 maxVidResY])
%     ylim([-180 180])
    title(['r=' num2str(rho) ', p=' num2str(p)])
end
