%keyboard
% a =          53;
% b =     0.05034;
% c =       58.37;
% d =      0.6682;

%hand tuned
%in_data=eye_ang_x-30;
%guess! center data on median - assume head at rest at is 0,0 for 1st 100ms
%in_data=angular_orient(below_thresh_eye,3)-nanmedian(head_mocap_sixdof(:,8));
eps=1e-6;
in_data=angular_orient(below_thresh_eye,3)-nanmedian( angular_orient(1:6,3) )+eps;


%fx=(a./( 1+ exp(-b*( in_data-d))))-0.5*c;
fx=(((2./(1+exp(-2*in_data/30)))+1)-2)*25;
%eye_ang_y-20;
%in_data=angular_orient(below_thresh_eye,2)-nanmedian(head_mocap_sixdof(:,7));
in_data=angular_orient(below_thresh_eye,2)-nanmedian( angular_orient(1:6,2) )+eps;

%fy=(a./( 1+ exp(-b*( in_data-d))))-0.5*c;
fy=(((2./(1+exp(-2*in_data/30)))+1)-2)*25;

rmse_fang_predict= sqrt(nanmean( (fx-(eye_ang_x(below_thresh_eye)-30)).^2 + ...
 (fy-(eye_ang_y(below_thresh_eye)-20)).^2)); 

% figure(2); clf; subplot(2,1,1); hold on
% plot(eye_ang_x(below_thresh_eye)-30)
% plot(eye_ang_y(below_thresh_eye)-20)
% subplot(2,1,2); hold on
% plot(angular_orient(below_thresh_eye,2:3));
