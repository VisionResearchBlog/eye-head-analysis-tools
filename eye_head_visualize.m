%eye_head_visualize
figure(1); clf
imagesc(LookPropMatrixPERC); hold on
colorbar;
title('All Data')
xlabel('Vert Position (Degrees)')
ylabel('Horz Position (Degrees)')
[v1,i1]=max(LookPropMatrixPERC,[],1);
[v1,i1]=max(v1);
[v2,i2]=max(LookPropMatrixPERC,[],2);
[v2,i2]=max(v2);
scatter(i1,i2, 40, 'r','filled', 'o')
globalPeak=[i1,i2]





%
% if(viz)
%     figure(1); clf; hold on
%     plot(xeye,yeye,'b*')
%     %plot(xeye(x1),yeye(x1),'r*')
%     %plot(xeye(x2),yeye(x2),'m*')
%     %plot(xeye(x3),yeye(x3),'g*')
%     %plot(xeye(x4),yeye(x4),'k*')
%     xlim([-1500 2500])
%     ylim([-1500 1500])
%     plot(xeye(bad_X),yeye(bad_X),'m*')
%     plot(xeye(bad_Y),yeye(bad_Y),'r*')
%     legend('normal', 'bad y', 'bad x')
%     title('accepted & rejected eye data')
% end
% %plot(xeye(bad_X|bad_Y),yeye(bad_X|bad_Y),'k*')
%
%
% if(viz)
%     figure(1); clf
%     subplot(2,1,1); hold on
%     title('Raw vs. filtered eye position')
%     plot(t,eye_data.BPORX_px_,'-')
%     ylabel('horizontal position')
%     xlabel('frame')
%     plot(t,xeye); ylim([-10 1500])
%     legend('raw','filtered')
%     subplot(2,1,2); hold on
%     plot(t,eye_data.BPORY_px_,'-')
%     plot(t,yeye); ylim([-10 1500])
%     ylabel('vertical position')
%     xlabel('frame')
%
%
%
% %nneds to be per trial
% if(viz)
%     figure(6); clf;
%     subplot(4,1,1); hold on
%     plot(exp_data.mocap(idx_rng(1)).sixdof(1:3,:)')
%     title('single trial head position & orientation')
%     legend('x','y','z')
%     ylabel('m?')
%
%     subplot(4,1,2); hold on
%     %plot(linear_vel)
%     plot(linear_vel_global)
%     legend('xv','yv','zv','global_vel')
%     ylabel('m?/sec')
%
%     subplot(4,1,3); hold on
%     plot(exp_data.mocap(idx_rng(1)).sixdof(4:6,:)')
%     legend('h','p','r')
%     ylabel('degrees')
%
%     subplot(4,1,4); hold on
%     %plot(angular_vel)
%     plot(angular_vel_global)
%     legend('hv','pv','rv','global_vel')
%     ylabel('degrees/sec')
% end
%
% %per condition num
% if(viz)
%     figure(4); clf
%     figure(5); clf
% end
%
% if(viz)
%     figure(4);
%     subplot(2,3,plotidx(conditionNum));
%     imagesc(LookPropMatrixPERC); hold on
%     title(CondLabels{conditionNum})
%     colorbar
%
%     if(conditionNum==1)
%         xlabel('Vert Position (Degrees)')
%         ylabel('Horz Position (Degrees)')
%     end
%
%     [v1,i1]=max(LookPropMatrixPERC,[],1);
%     [v1,i1]=max(v1);
%     [v2,i2]=max(LookPropMatrixPERC,[],2);
%     [v2,i2]=max(v2);
%     scatter(i1,i2, 40, 'r','filled', 'o')
%
% end
% figure(6); clf;  figure(7); clf;
%
%
% figure(6);
% subplot(2,3,plotidx(conditionNum))
% imagesc(ave_Subs(:,:,conditionNum)); hold on
% title(CondLabels{conditionNum})
% colorbar;
%
% if(conditionNum==1)
%     xlabel('Vert Position (Degrees)')
%     ylabel('Horz Position (Degrees)')
% end
%
% figure(7);
% subplot(2,3,plotidx(conditionNum))
% imagesc(ave_Subs_HeadThresh(:,:,conditionNum)); hold on;
% title(CondLabels{conditionNum})
% colorbar;
% if(conditionNum==1)
%     xlabel('Vert Position (Degrees)')
%     ylabel('Horz Position (Degrees)')
% end