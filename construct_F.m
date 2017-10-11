theta=angular_vel(below_thresh_eye,:) ; % global
alpha=linear_accel_global(below_thresh_eye) ;%relative accel
omega=angular_vel_global(below_thresh_eye) ; %hpr relative angular vel]

H=[theta alpha omega];

%predict change? or absolute?
%y1=delta_c_x(below_thresh_eye) ;
%y2=delta_c_y(below_thresh_eye) ;
%remove nans

predx=eye_ang_x(below_thresh_eye);
predy=eye_ang_y(below_thresh_eye);

F_x_xpred=[H eye_ang_x_lastframe(below_thresh_eye) predx];
F_x_xpred=[F_x_xpred F_x_xpred(:,7)-F_x_xpred(:,6)];

%add eye delta to last column
F_y_ypred=[H eye_ang_y_lastframe(below_thresh_eye) predy];
F_y_ypred=[F_y_ypred F_y_ypred(:,7)-F_y_ypred(:,6)];

%make index for below_thresh segments
tmp=find(below_thresh_eye);
clear cntr
cntr=1;
for zpz=2:length(tmp)
    
    %distance less than one means contiguous
    if(tmp(zpz)-tmp(zpz-1) == 1)
        %keep the label
        cntr(zpz)=cntr(zpz-1);
    else
        cntr(zpz)=cntr(zpz-1)+1;
    end
    
end

%clf; plot(below_thresh_eye)
%cntr


F_x_xpred=[F_x_xpred( ~sum(isnan(F_x_xpred),2),:)...
    cntr( ~sum(isnan(F_x_xpred),2))'];
F_y_ypred=[F_y_ypred( ~sum(isnan(F_y_ypred),2),:)...
    cntr( ~sum(isnan(F_x_xpred),2))'];

%keyboard
%1-Hv 2-Pv 3-Rv 4-LinAccel 5-AngleVel 6- 7-EyeLast 8-EyeThis