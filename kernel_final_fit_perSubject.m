function [r,x,y, mserror,eye_new_pos] = ...
    kernel_final_fit_perSubject(data,x_or_y)

tic
num_kernels=6;
sd=.2;
viz=0;

%data contains: 
%1-Hv 2-Pv 3-Rv 4-LinAccel 5-AngleVel 6-EyeLast 7-EyeNow 8-EyeDelta


%eye delta
%delta_c_x=dataX(:,8);
%delta_c_y=dataY(:,8);
delta_c=data(:,8);

%actual eye
%e_x=dataX(:,7);
%e_y=dataY(:,7);
eye_dat=data(:,6);

angular_vel=data(:,1:3);
linear_accel_global=data(:,5);
angular_vel_global=data(:,4);

%construct H(t)
theta=angular_vel; % global
alpha=linear_accel_global ;%relative accel
omega=angular_vel_global ; %hpr relative angular vel]

H=[theta alpha omega];

% ?c_j,(Hj,c_t?1) .% Change in eye this frame, head this frame, eye position last frame
%F=(H(t),c(t-1))
F=[H eye_dat ];
%F_y=[H e_y  ];

%we want to learn the expected deviation of the eye (t) given F
% if(x_or_y)
% 	x=F_x; y=delta_c_x ;
% else
% 	x=F_y; y=delta_c_y ;
% end
x=F; y=delta_c;

x=x(3:end,:); y=y(3:end);

%remove nans
x=x( ~sum(isnan(x),2),:);
y=y( ~sum(isnan(x),2));


r.n=length(x);
x_rng=[min(x); max(x)]';
r.h=(abs(x_rng(:,2)-x_rng(:,1))./num_kernels)*sd;

% hx=nanmedian(abs(x-nanmedian(x)))/0.6745*(4/3/r.n)^0.2;
% hy=nanmedian(abs(y-nanmedian(y)))/0.6745*(4/3/r.n)^0.2;
% r.h=sqrt(hy*hx);


[xx1,xx2,xx3,xx4,xx5,xx6]=ndgrid(linspace(x_rng(1,1),x_rng(1,2),num_kernels),...
    linspace(x_rng(2,1),x_rng(2,2),num_kernels), ...
    linspace(x_rng(3,1),x_rng(3,2),num_kernels), ...
    linspace(x_rng(4,1),x_rng(4,2),num_kernels), ...
    linspace(x_rng(5,1),x_rng(5,2),num_kernels), ...
    linspace(x_rng(6,1),x_rng(6,2),num_kernels));

% [xx1,xx2,xx3,xx4]=ndgrid(linspace(x_rng(1,1),x_rng(1,2),num_kernels),...
% 	linspace(x_rng(2,1),x_rng(2,2),num_kernels), ...
% 	linspace(x_rng(3,1),x_rng(3,2),num_kernels), ...
% 	linspace(x_rng(4,1),x_rng(4,2),num_kernels) );

vecList=[xx1(:) xx2(:) xx3(:) xx4(:) xx5(:) xx6(:)];
%
SIGMA=[r.h(1) 0 0  0 0 0;
    0 r.h(2) 0 0 0 0;
    0 0 r.h(3) 0 0 0;
    0 0 0 r.h(4) 0 0;
    0 0 0 0 r.h(5) 0;
    0 0 0 0 0 r.h(6);];

% vecList=[xx1(:) xx2(:) xx3(:) xx4(:) ];
% SIGMA=[r.h(1) 0 0 0;
% 	0 r.h(2) 0 0 ;
% 	0 0 r.h(3) 0 ;
% 	0 0 0 r.h(4) ];

%%step thru example kernel location
for k=1:length(vecList)
    z=mvnpdf(x,vecList(k,:),SIGMA);
    r.f(k,1)=sum(z.*y)/(sum(z)); %proper 6D
end


%take original data
%find closest vector
for k=1:length(x)
    [~,idx]=min( sqrt(sum(x(k,:)-vecList,2).^2) );
    recon.val(k,1)=r.f(idx);
    recon.idx(k,1)=idx;
end

if(viz)
    figure(808); clf;
    subplot(2,1,1); hold on
    plot(y)
    plot(recon.val)
    %plot((1:length(r.f))*(r.n/length(r.f)),r.f,'*-')
    legend('Delta C_t', '6D Prediction') %'1D Prediction',
    subplot(2,1,2); hold on
    plot(x)
    legend('1','2','3','4')
end

mserror.recon=sqrt(sum((y-recon.val).^2)./length(y));
%mean_gy(qpq,subNum)=mean(y);

%run simulation of eye gaze
% if(x_or_y)
%     xx=	[e_x(2:end); e_x(end)];
% else
%     xx=	[e_y(2:end); e_y(end)];
% end

xx=	[eye_dat(2:end); eye_dat(end)];

theta_r=theta(2:end);


%first get initial eye position
[~,idx]=min( sqrt(sum(xx(1,:)-vecList,2).^2) );
predict.val(1,1)=r.f(idx);
predict.idx(1,1)=idx;
%firstnonzero=find(below_thresh_eye);
eye_new_pos=xx; %(below_thresh_eye(firstnonzero(1)));
last_not_nan=-1;



for k=2:length(eye_dat)
    
    if( (eye_dat(k,end)-eye_dat(k-1,end))>0 )
        %we have a break and need to update our eye position
        eye_old_pos=xx(k,end);
    else
        eye_old_pos=eye_new_pos(k-1);
    end
    
    if( isnan(eye_old_pos) )
        if(last_not_nan<0)
            eye_old_pos=eye_new_pos(last_not_nan);
        else
            disp('eye nan')
            if(x_or_y)
                eye_old_pos=40;%xcenter;
            else
                eye_old_pos=30;%ycenter;
            end
        end
    else
        last_not_nan=k;
    end
    
    eye_new_pos(k,1)=eye_old_pos+predict.val(k-1);
    
    try
        [~,idx]=min( sqrt( sum( ([H(k,:) eye_new_pos(k)]-vecList).^2,2) ));
    catch ME
        ME
        keyboard
    end
    predict.val(k,1)=r.f(idx);
    predict.idx(k,1)=idx;
    
    if( isnan(eye_new_pos(k) )); keyboard; end
    
end

if(viz)
    figure(809); clf; hold on;
    plot(x(:,end))
    plot(eye_new_pos)
end

idx=find(~isnan(xx));

mserror.predict_FRAME_AVE=sqrt( sum( (xx(idx)-eye_new_pos(idx)).^2 )./length(data) );
if(isnan(mserror.predict_FRAME_AVE)); keyboard; end

toc

return
