%will return these::
%max_move_HeadAng, head_time, eye_time, eye_time_ff
maxHeadMoveLengthThresh=70; %maybe 90?

% %what is distance from origina at t=1
%find first good frame
tmp=find(~(sum(isnan(angular_orient),2)>0 | sum(angular_orient==0,2)>0));

if(~isempty(tmp))
	b_e_diff=angular_orient-median(angular_orient(tmp(1:9),:)); %take median of 1st 100ms
	clear ang_length
	for kkk=1:size(b_e_diff,1)
		ang_length(kkk)=norm(b_e_diff(kkk,:));
	end
	
	perc_zero_vel=sum( angular_vel_global==0 | sum(isnan(angular_vel),2)>0 )./length(angular_vel);
else
	perc_zero_vel=1;
end

%eval the head
%sometimes transients creat massive movements - restrict to below 90
if(perc_zero_vel<=0.33)
	tmp=ang_length<maxHeadMoveLengthThresh; %70;
	max_move_HeadAng(trialNum,conditionNum,subNum) = max(ang_length(tmp));
	% keyboard
	%
	%
	% %find time when head move 3sds away fromm start
	% a_tmp1=ang_length(1:14)==0;
	% a_tmp2=isnan(ang_length(1:14));
	% a_tmp3=ang_length(~(a_tmp1|a_tmp2));
	%
	% h_thresh=nanmedian(a_tmp3)+nanstd(a_tmp3)*3;
	% tmp=find(ang_length>=h_thresh);
	
	%try vel thresh
	tmp=find(angular_vel_global>head_vel_thresh);
	if(~isempty(tmp))
		head_time(trialNum,conditionNum,subNum)=tmp(1)*smp_rate_mocap;
	else
		%disp('head thresh fail')
		% 	if(isnan(h_thresh))
		% 		disp('crap data - nan')
		% 	head_time(trialNum,conditionNum,subNum)=NaN;
		% 	end
		
		head_time(trialNum,conditionNum,subNum)=NaN;
		%	keyboard
	end
	
	% if(conditionNum==7)
	% 	if( max(ang_length)> 60 )
	% 		max(ang_length)
	% 		figure(1919); clf;
	% 		subplot(2,1,1); hold on
	% 		plot(ang_length)
	% 		plot(angular_vel_global)
	% 		subplot(2,1,2)
	% 		plot(angular_orient)
	% 		max_move_HeadAng(trialNum,conditionNum,subNum)
	% 		perc_zero_vel
	% 		keyboard
	% 	end
else
	%bad trial too many zeros & nans
	max_move_HeadAng(trialNum,conditionNum,subNum)=NaN;
	head_time(trialNum,conditionNum,subNum)=NaN;
end


%eval the eye
xy=[eye_ang_x eye_ang_y];
xy=xy-xy(1,:);
for kkk=1:size(xy,1)
	eye_length(kkk)=norm(xy(kkk,:));
end


%find time when head move 3sds away fromm start
e_thresh=nanmedian(eye_length(1:14))+nanstd(eye_length(1:14))*3;
tmp=find(eye_length>=e_thresh);
if(~isempty(tmp))
	eye_time(trialNum,conditionNum,subNum)=tmp(1)*smp_rate_mocap;
else
	%disp('eye thresh fail')
	eye_time(trialNum,conditionNum,subNum)=NaN;
	if(isnan(e_thresh))
		%	disp('crap data - nan')
	end
	%keyboard
end

%alternate just take end of first fix
if(~isempty(fix))
	eye_time_ff(trialNum,conditionNum,subNum)=fix(1,2);
else
	eye_time_ff(trialNum,conditionNum,subNum)=NaN;
end

%can't be longer than the trial
if( mod(conditionNum,2)==1) %odd/slow
	t_thr=4;
else
	t_thr=3;
end

if( abs(head_time(trialNum,conditionNum,subNum)-...
		eye_time_ff(trialNum,conditionNum,subNum))>t_thr ) 
	
	disp('latency')
	abs(head_time(trialNum,conditionNum,subNum)-...
		eye_time_ff(trialNum,conditionNum,subNum))
	
	keyboard 
end