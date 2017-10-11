figure(929); clf
subplot(4,1,1); hold on
title('eye')

plot(new_t_ms/1000, eye_ang_x)
plot(new_t_ms/1000, eye_ang_y)
plot(new_t_ms/1000, interp_pupil*20)
legend('x','y','pupil')
%plot(new_t_ms(below_thresh_eye)/1000, eye_ang_x(below_thresh_eye),'*')
%plot(new_t_ms(below_thresh_eye)/1000, interp_y(below_thresh_eye),'*')
%[ ex, ey]=smi2angle(interp_x(below_thresh), interp_y(below_thresh));
%ylim([0  80])
plot( eye_time(trialNum,conditionNum,subNum),20, 'r*')
plot( eye_time_ff(trialNum,conditionNum,subNum),21, 'b*')

subplot(4,1,2); hold on
title('eye velocity')
plot(new_t_ms/1000,velFF )

ft=[];
for qbq=1:size(fix_frames,1)
	ft=[ft; new_t_ms(fix_frames(qbq,1):fix_frames(qbq,2))];
end
plot(ft/1000, ones(length(ft),1)*vel_thresh,'*')
plot(new_t_ms/1000,below_ff*vel_thresh*0.5,'*')


%ylim([20 60])
subplot(4,1,3); hold on
title('3dof orientation')
plot(new_t_ms/1000, angular_orient(:,1) )
plot(new_t_ms/1000, angular_orient(:,2) )
plot(new_t_ms/1000, angular_orient(:,3) )
legend('heading','pitch', 'yaw')

subplot(4,1,4); hold on
title('global vel & accel')
plot(new_t_ms/1000,angular_vel_global)
plot(new_t_ms/1000,linear_accel_global)
plot(head_time(trialNum,conditionNum,subNum),20,'r*')
legend('orient vel','linear accel','start head')


