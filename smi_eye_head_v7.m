clear all;  clc
tic

if( exist('fix_finder')~=2)
	disp('STOP - you need fix finder in path!')
	return
end

%graphs of eye+head
viz_AcrossSubjects=1;
viz_perSubject=0;
fit_each_trial=0;
%plot the eye velocity/fix finder result
viz_fix=0;
viz_single_trial=0;

%---for SMI ETG v1.0-----=
vidResX=1280; vidResY=960;
%according to SMI tracking can be done outside the cameras FOV
maxVidResX=1707; maxVidResY=1252;
pix2deg_X=60/vidResX;%58.6/vidResX; %60 from SMI, my measure was 58.6
pix2deg_Y=46/vidResY;%37.9/vidResY; %46 from SMI, my measure was 37.9
%~21-25 pixels per degree?
%this assumes lens is homogeneous which may not be true
%maxVidResX maxVidResY
xrng=ceil((maxVidResX-vidResX)/2);
%according to SMI tracking can be done outside the cameras FOV
yrng=ceil((maxVidResY-vidResY)/2);
maxx=vidResX+xrng; minx=0-xrng;
maxy=vidResY+yrng; miny=0-yrng;
smp_rate_eye=1/30;

smp_rate_mocap=1/90;
ang_medkernel=9;
head_vel_thresh=5; %angular vel

%fix finder params-----
method=1; %velocity threshold
vel_thresh=45; %30; %velocity must be under thresh (deg/sec)
t_thresh = 99; %minimum fix duration in ms
pos_medfilt_win_size=4; %in prepare eye at 30hz
clump_space_thresh=2;
clump_t_thresh=100;

%head segment params
thresh_ang=rad2deg(0.5);%/3;% Paper has 0.5 rads? seems high 3; %deg/sec head rotation threshold
thresh_accelerometer=3;%/3; %0.5; %3m/s also from paper

pix_c=1; %factor for size of bins = c*1deg


CondLabels={
	'Slow, Small, Eyes'
	'Fast, Small, Eyes'
	'Slow, Small, Hand'
	'Fast, Small, Hand'
	'Slow, Medium, Eyes'
	'Fast, Medium, Eyes'
	'Slow, Medium, Hand'
	'Fast, Medium, Hand'
	'Slow, Large, Eyes'
	'Fast, Large, Eyes'
	'Slow, Large, Hand'
	'Fast, Large, Hand'};

data_dir=pwd; %'/Users/sullivan/Documents/GLANCE/EyeHead_Exp/smi_data/data/';
data_dir=[data_dir '/data/'];

plotidx=[1 4 7 10 2 5 8 11 3 6 9 12];
eye_pos_head_rot_AllSubs=[];
eye_pos_head_rot_THRESH_AllSubs=[];

LoadFileNames;

F_x_PerSub_TrialList=[];	delta_eye_x_PerSub_TrialList=[];
F_y_PerSub_TrialList=[];	delta_eye_y_PerSub_TrialList=[];
Kernel_PerSubCondTrialList=[];
Fx_pred_PerTrial_PerSub=[];
Fy_pred_PerTrial_PerSub=[];
fang_pred_list=zeros(24,12,size(flist,1))+NaN;
percent_of_trial_used=zeros(24,12,size(flist,1))+NaN;

for subNum=1:size(flist,1)
	tic
	%eye data
	fn1=flist{subNum,2}
	%exp data
	fn2=flist{subNum,1}
	eye_data=readtable([data_dir fn1(1:2) '/' fn1]);
	exp_data=load([data_dir fn1(1:2) '/' fn2]);
	
	%first we need to trim excess data to line up mocap with eye
	
	%USE own FIX FINDER INSTEAD
	%disp('Using fix finder')
	% to do for now just clean up raw data
	
	%SMI seems to have a secret sauce for blinks as pupil is very unreliable
	%pupil=eye_data.RPupilDiameter_mm_.*eye_data.LPupilDiameter_mm_;
	%pupil=double(~strcmp(eye_data.BEventInfo,'Blink')); %still seems
	%unreliable
	pupil=ones(length(eye_data.BEventInfo),1);
	t=eye_data.Time/1000000; %    tt=(Time-Time(1))/1000000;
	%	t=eye_data.x___Time/1000000;
	%generates filtered xeye, yeye
	prepareEyeData;
	
	msg_e_index=zeros(length(eye_data.Type),1);
	%find SMI event tages
	for i=1:length(eye_data.Type)
		msg_index(i,1)=strcmp(eye_data.Type{i},'MSG');
		a=strfind(eye_data.LDiaX_px_{i},'END');
		if(~isempty(a))
			msg_e_index(i)=1;
		end
	end
	
	msg_index=find(msg_index-msg_e_index);
	msg_e_index=find(msg_e_index);
	%get smi event text labels
	condition_txt=eye_data.LDiaX_px_(msg_index);
	%mark the type of trial in a numeric form
	[condition, blockOrder]=MarkTrialType(condition_txt);
	
	%a list of begin & end for each stimulus presentation
	
	%
	EventIdx=[msg_index msg_index+(abs(condition(:,1)-3))*30];
	
	%	this won't work because there was an unintended delay, due to
	%save file mechanism
	
	%EventIdx=[msg_index [msg_index(2:end); length(eye_data.Type)] ];
	EventIdx_t= eye_data.Time(EventIdx)/1000000;
	
	%generate a probability matrix for a look having occured in a
	%particular x,y location
	[LookPropMatrixRAW,LookPropMatrixPERC] = ...
		spatialhist(xeye,yeye,...
		maxVidResX,maxVidResY,...
		pix2deg_X/pix_c,pix2deg_Y/pix_c);
	
	
	for zzz=1:size(exp_data.mocap,2)
		mocap_frame_t(zzz)=size(exp_data.mocap(zzz).sixdof,3);
		%mocap_polling_t(zzz)=exp_data.mocap(zzz).time(end)-exp_data.mocap(zzz).time(1);
	end
	
	
	
	% recall that the eye tracking data is continous in an array
	%but the mocap data is in a struct - let's collapse all mocap
	%data into an array
	head_mocap_sixdof=[];
	torso_mocap_sixdof=[];
	
	for trialNum=1:size(exp_data.mocap,2)
		tmp=exp_data.mocap(trialNum).sixdof;
		%head
		tmp=squeeze(tmp(:,1,:))';
		head_mocap_sixdof=[head_mocap_sixdof; repmat(trialNum,length(tmp),1) ...
			repmat(condition(trialNum,3),length(tmp),1) tmp];
		
		%torso
		tmp=exp_data.mocap(trialNum).sixdof;
		tmp=squeeze(tmp(:,2,:))';
		torso_mocap_sixdof=[torso_mocap_sixdof; repmat(trialNum,length(tmp),1) ...
			repmat(condition(trialNum,3),length(tmp),1) tmp];
		
		tmp=find(head_mocap_sixdof(:,1)==trialNum);
		mocap_indices_per_trial(trialNum,:)=[tmp(1) tmp(end)];
	end
	
	
	
	%given our different types of conditions lets plot them separately
	eye_head_trial_and_condition_segments=[];
	F_x_TrialList=[]; 	F_y_TrialList=[];
	delta_eye_x_TrialList=[];	delta_eye_y_TrialList=[];
	KernelCondTrialList=[]; eye_pos_head_rot=[];
	eye_pos_head_rot_THRESH=[];
	Fx_pred_PerTrial=[];
	Fy_pred_PerTrial=[];
	
	
	%subjects should have all conditions bu just in case
	unique_Cs=unique(condition(:,4));
	num_Conditions=length( unique_Cs ) ;
	
	LookPropMatrixRAW=zeros(60,80,num_Conditions);
	LookPropMatrixRAW_H=zeros(60,80,num_Conditions);
	
	below_perc=[];
	%step through each example of this particular condition
	for c_idx=1:num_Conditions
		conditionNum=unique_Cs(c_idx)
		
		%per condition eye position probability distribution
		
		%for the smi data find the appropriate range applicable to this
		%condition number
		eye_idx_rng=find(conditionNum==condition(:,4));
		
		eye_index=EventIdx(eye_idx_rng,:);
		%correct last entry
		if(mod(conditionNum,2)==1) %slow
			tmp=1/smp_rate_eye*3;
		else
			tmp=1/smp_rate_eye*2;
		end
		
		eye_index(end,2)=eye_index(end,1)+tmp;
		
		mocap_idx_rng=mocap_indices_per_trial(eye_idx_rng,:);
		
		clear fix fix_frames velFF
		ms_error_TrialList=[];
		
		for trialNum=1:length(eye_index)
			%trialNum
			tmp_idx_eye=eye_index(trialNum,1):eye_index(trialNum,2);
			tmp_idx_eye=tmp_idx_eye(2:end-1); %trim because of nans
			tmp_idx_mocap=mocap_idx_rng(trialNum,1):mocap_idx_rng(trialNum,2);
			tmp_idx_mocap=tmp_idx_mocap(4:end-4); %match up with trimmed eye
			
			%now linear interpolate to mat rotational data
			%take the eye data and upscale to mocap smp rate 90hz
			%old_t=(1:length(tmp_idx_eye))'*smp_rate_eye;
			old_t=t(tmp_idx_eye);
			old_t=old_t-old_t(1);
			
			new_t=(1:((length(tmp_idx_eye)-1)/(length(tmp_idx_mocap))):length(tmp_idx_eye))'*smp_rate_eye;
			interp_x=interp1( old_t, xeye(tmp_idx_eye), new_t(1:length(tmp_idx_mocap)),'linear'  );
			interp_y=interp1( old_t, yeye(tmp_idx_eye), new_t(1:length(tmp_idx_mocap)),'linear'  );
			interp_pupil=interp1( old_t, pupil(tmp_idx_eye), new_t(1:length(tmp_idx_mocap)),'linear'  );
			
			tmp=zeros(length(interp_x),1); %filler for labels (we have no AOIS)
			new_t_ms=new_t(1:length(tmp_idx_mocap))*1000;
			
			%need to change recording of mocap data, need timestamp!
			%for now just assume steady 90hz
			linear_pos=head_mocap_sixdof(tmp_idx_mocap,3:5)/1000; %in mm - convert to m
			
			linear_pos=[medfilt1(linear_pos(:,1),ang_medkernel,'omitnan')...
				medfilt1(linear_pos(:,2),ang_medkernel,'omitnan')...
				medfilt1(linear_pos(:,3),ang_medkernel,'omitnan')];
			
			linear_vel=(linear_pos(2:end,:)-linear_pos(1:end-1,:))./smp_rate_mocap;
			linear_vel_global=sqrt((sum(linear_pos(2:end,:)-linear_pos(1:end-1,:),2).^2))./smp_rate_mocap;
			linear_vel_global=medfilt1(linear_vel_global(:,1),ang_medkernel,'omitnan');
			
			linear_accel_global=sqrt((sum(linear_vel_global(2:end,:)-linear_vel_global(1:end-1,:),2).^2))./smp_rate_mocap;
			
			linear_vel=[0 0 0; linear_vel];
			linear_vel_global=[0; linear_vel_global];
			linear_accel_global=[0; 0; linear_accel_global];
			
			angular_orient=head_mocap_sixdof(tmp_idx_mocap,6:8); % in degrees
			angular_orient=[medfilt1(angular_orient(:,1),ang_medkernel,'omitnan')...
				medfilt1(angular_orient(:,2),ang_medkernel,'omitnan')...
				medfilt1(angular_orient(:,3),ang_medkernel,'omitnan')];
			
			angular_vel=angular_orient(2:end,:)-angular_orient(1:end-1,:);
			angular_vel=medfilt1(angular_vel,ang_medkernel,'omitnan');
			
			angular_vel_global=sqrt( angular_vel(:,1).^2 + angular_vel(:,2).^2 + ...
				angular_vel(:,3).^2)./smp_rate_mocap; %
			angular_vel_global=medfilt1(angular_vel_global,ang_medkernel,'omitnan');
			angular_vel=[0 0 0; angular_vel];
			angular_vel_global=[0; angular_vel_global];
			
			torso_angular_orient=torso_mocap_sixdof(tmp_idx_mocap,6:8); % in degrees
			torso_angular_vel=torso_angular_orient(2:end,:)-torso_angular_orient(1:end-1,:);
			torso_angular_vel_global=sqrt( torso_angular_vel(:,1).^2 + torso_angular_vel(:,2).^2 + ...
				torso_angular_vel(:,3).^2)./smp_rate_mocap; %
			
			%now use gyro timing wrt to gaze as we have converted time base
			below_ang_thresh=(angular_vel_global(2:end)<=thresh_ang); %correct for size offsets due to vel & accel calc
			below_accelerometer_thresh=(linear_accel_global(3:end)<=thresh_accelerometer);
			
			%below_thresh_eye=unique([find(below_ang_thresh); find(below_accelerometer_thresh)]);
			
			below_thresh_eye= [0; below_ang_thresh] & [0; 0; below_accelerometer_thresh];
			
			below_perc=[below_perc; length(below_thresh_eye)./(length(angular_vel_global)+1)];
			
			% 			figure(91901); clf;  subplot(2,1,1); hold on;
			% 			plot(angular_vel_global)
			% 			plot(below_ang_thresh*thresh_ang,'r*')
			% 			plot(below_thresh_eye*thresh_ang*.5,'*g')
			%
			% 			subplot(2,1,2); hold on;
			% 			plot(linear_accel_global)
			% 			plot(below_accelerometer_thresh*thresh_accelerometer,'r*')
			% 			plot(below_thresh_eye*thresh_accelerometer*.5,'*g')
			
			try
				%smooth position signal
				[fix, fix_frames,velFF] = ...
					fix_finder('tmp','', method, vel_thresh,t_thresh, ...
					clump_space_thresh, clump_t_thresh,...
					viz_fix, interp_x, interp_y, interp_pupil, new_t_ms, ...
					1:length(tmp_idx_mocap), tmp, [],[],[]);
				
				[ eye_ang_x, eye_ang_y]=smi2angle(interp_x, interp_y);
				%[fmark, fd_dat] = fixdetect(eye_ang_x,eye_ang_y,new_t_ms);
				%figure(3929); clf; hold on; plot(fd_dat.time,fd_dat.v);
				%plot(fmark/1000,ones(length(fmark),1)*10,'*' )
				%keyboard
			catch me
				disp(['No FF return: cond: '  num2str(conditionNum) ...
					', trial: ' num2str(trialNum)])
				%keyboard
			end
			
			%ok some things may not fit in our definition of 'fixation'
			if(exist('fix_frames'))
				%cut off frames at begin & end to get around slop from vel
				%thresh
				fixDat=[fix_frames(:,1)+1 fix_frames(:,2)-1];
				fix=fix/1000;
				
				fix_frame_binary=zeros(length(tmp_idx_mocap),1);
				for bb=1:size(fix_frames,1)
					fix_frame_binary(fix_frames(bb,1):fix_frames(bb,2))=...
						fix_frame_binary(fix_frames(bb,1):fix_frames(bb,2))+1;
				end
			end
			%--END --USE own FIX FINDER INSTEAD
			
			[LookPropMatrixRAW_PerTrial,LookPropMatrixPERC_PerTrial] = ...
				spatialhist(interp_x,...
				interp_y,...
				maxVidResX,maxVidResY,...
				pix2deg_X*pix_c,pix2deg_Y*pix_c);
			
			LookPropMatrixRAW(:,:,conditionNum)=LookPropMatrixRAW(:,:,conditionNum)+LookPropMatrixRAW_PerTrial;
			
			clear  kfit_x F_x delta_eye_x kfit_y F_y delta_eye_y
			
			if(exist('fix_frames'))
				%can use eye & head
				
				%plot only time when head was below threshold
				[LookPropMatrixRAW_H_PerTrial,LookPropMatrixPERC_H_PerTrial] = ...
					spatialhist(  interp_x(below_thresh_eye),interp_y(below_thresh_eye),...
					maxVidResX, maxVidResY, pix2deg_X*pix_c,pix2deg_Y*pix_c);
				
				LookPropMatrixRAW_H(:,:,conditionNum)=LookPropMatrixRAW_H(:,:,conditionNum)+LookPropMatrixRAW_H_PerTrial;
				
				eye_pos_head_rot=[eye_pos_head_rot; eye_ang_x eye_ang_y angular_orient];
				eye_pos_head_rot_THRESH=[eye_pos_head_rot_THRESH; ...
					eye_ang_x(below_thresh_eye) eye_ang_y(below_thresh_eye)...
					angular_orient(below_thresh_eye,:)];
				%will return these::
				%max_move_HeadAng, head_time, eye_time, eye_time_ff
				headDataAnalyze
				
				%we want to use only the period where they are not looking
				%at center...
				below_ff=zeros(length(below_thresh_eye),1);

				if( (size(fix_frames,1)>=2) )
					%use only 2nd fix
					below_ff(fix_frames(2,1):fix_frames(2,2))=1;
					skipme(trialNum)=0;
				else
					disp('only one fixation, skipping')
					skipme(trialNum)=1;
					%onetrialplot
					%keyboard
					continue %keyboard
				end
				
				below_thresh_eye=below_thresh_eye&below_ff;
				
				if( sum(below_thresh_eye)>0 )
					%use only 2nd fix
					below_ff(fix_frames(2,1):fix_frames(2,2))=1;
					skipme(trialNum)=0;
				else
					disp('not enough frames below thresh, skip')
					skipme(trialNum)=1;
					%onetrialplot
					%keyboard
					continue 
				end

				if(viz_single_trial)
					CondLabels{conditionNum}
					trialNum
					onetrialplot
					keyboard
				end
				
				percent_of_trial_used(trialNum,conditionNum,subNum)=...
					sum(below_thresh_eye)./length(below_thresh_eye);
				
				%filtered using thresholds now test simple sigmoid model
				rmse_fang;
				rmse_fang_pertrial(trialNum)=rmse_fang_predict;
				fang_pred_list(trialNum,conditionNum,subNum)=rmse_fang_predict;
				if(isnan(rmse_fang_predict)) 
					disp('cannot calc rmse - only nans?')
					%keyboard; 
				end

				%store chunks that are segmented using head threshes
				eye_head_trial_and_condition_segments=[eye_head_trial_and_condition_segments;
					eye_ang_x(below_thresh_eye) eye_ang_y(below_thresh_eye) ...
					angular_orient(below_thresh_eye,:) ...
					zeros(sum(below_thresh_eye),1)+conditionNum ... %condition small, medium, large
					zeros(sum(below_thresh_eye),1)+mod(trialNum,9)...
					zeros(sum(below_thresh_eye),1)+trialNum]; %code fox location
				
				%set it up so that it's eye pos from last frame
				eye_ang_x_lastframe=[0; eye_ang_x(1:end-1)];
				eye_ang_y_lastframe=[0; eye_ang_y(1:end-1)];
				
				
				%given pitch what is eye y
				delta_c_x=[eye_ang_x(2:end)-eye_ang_x(1:end-1); 0];
				delta_c_y=[eye_ang_y(2:end)-eye_ang_y(1:end-1); 0];
				
				%remove nans
				delta_c_x(isnan(delta_c_x))=0;
				delta_c_y(isnan(delta_c_y))=0;
				
% 				%avoid slowness of fit to generate nn_fit data
                
				construct_F;
				Fx_pred_PerTrial=[Fx_pred_PerTrial; F_x_xpred];
				Fy_pred_PerTrial=[Fy_pred_PerTrial; F_y_ypred];
				KernelCondTrialList=[KernelCondTrialList; zeros(size(F_x_xpred,1),1)+conditionNum ...
					zeros(size(F_x_xpred,1),1)+trialNum];
				
                
			else %should we ignore lack of eye fixations or throw this trial out?
				disp('no fixes')
				%keyboard
			end
			
		end
			
		
		
		LookPropMatrixPERC(:,:,conditionNum)=LookPropMatrixRAW(:,:,conditionNum)./sum(sum(LookPropMatrixRAW(:,:,conditionNum)));
		LookPropMatrixPERC_H(:,:,conditionNum)=LookPropMatrixRAW_H(:,:,conditionNum)./sum(sum(LookPropMatrixRAW_H(:,:,conditionNum)));
		
		if(1 & viz_perSubject)
			figure(1);
			subplot(4,3,plotidx(conditionNum));
			imagesc(log(LookPropMatrixPERC(:,:,conditionNum))); hold on
			title(CondLabels{conditionNum})
			colorbar;
			
			figure(2);
			subplot(4,3,plotidx(conditionNum));
			imagesc(log(LookPropMatrixPERC_H(:,:,conditionNum))); hold on
			title(CondLabels{conditionNum})
			colorbar;
		end
		
		EvalCentralBias
		
		
		
		if(~isempty(ms_error_TrialList))
			EyeDeviation_PREDICT_PerSubCond_MEAN_XY(conditionNum, subNum)=nanmean(ms_error_TrialList(:,1));
			EyeDeviation_PREDICT_PerSubCond_MED_XY(conditionNum, subNum)=nanmedian(ms_error_TrialList(:,1));
			EyeDeviation_PREDICT_PerSubCond_SD_XY(conditionNum, subNum)=nanstd(ms_error_TrialList(:,1));
			
			EyeDeviation_PREDICT_PerSubCond_MEAN_X(conditionNum, subNum)=nanmean(ms_error_TrialList(:,2));
			EyeDeviation_PREDICT_PerSubCond_MED_X(conditionNum, subNum)=nanmedian(ms_error_TrialList(:,2));
			EyeDeviation_PREDICT_PerSubCond_SD_X(conditionNum, subNum)=nanstd(ms_error_TrialList(:,2));
			
			EyeDeviation_PREDICT_PerSubCond_MEAN_Y(conditionNum, subNum)=nanmean(ms_error_TrialList(:,3));
			EyeDeviation_PREDICT_PerSubCond_MED_Y(conditionNum, subNum)=nanmedian(ms_error_TrialList(:,3));
			EyeDeviation_PREDICT_PerSubCond_SD_Y(conditionNum, subNum)=nanstd(ms_error_TrialList(:,3));
		end
		
	end
	
	if(1 & viz_perSubject)
		plot_head_vs_eye_v3
	end
	
	
	
	if(0 & viz_perSubject)
		
		%require per trial fit - see abov L335
		x_or_y=0;
		kernel_final_fit_perCond
		
		x_or_y=1;
		kernel_final_fit_perCond
		
		figure(3); clf
		subplot(1,2,1);
		imagesc(log(mean(LookPropMatrixPERC,3)));
		title('global look proportion per x,y')
		colorbar;
		
		subplot(1,2,2);
		surf(log(mean(LookPropMatrixPERC,3)));
		colorbar;
		title('Global x,y Distibution')
		
	end
	
	nonanlist=~sum(isnan(eye_pos_head_rot)>0,2);
	eye_pos_head_rot=eye_pos_head_rot(nonanlist,:);
	%h=.5; N=50
	
	if(0 & viz_AcrossSubjects)
		eyex_heady=ksr(eye_pos_head_rot(:,5),eye_pos_head_rot(:,1) );
		eyey_headp=ksr(eye_pos_head_rot(:,4),eye_pos_head_rot(:,2) );
		
		figure(8981);
		subplot(5,4,subNum); hold on
		plot( eye_pos_head_rot(:,5),eye_pos_head_rot(:,1),'*' )
		plot(eyex_heady.x,eyex_heady.f,'*-')
		ylabel('Eye - Horizontal'); xlabel('Head - Yaw')
		lsline
		[rho,pval]=corr(eye_pos_head_rot(:,1), eye_pos_head_rot(:,5));
		title(['r= ' num2str(rho) ', p= ' num2str(pval) ])
		xlim([-180 180]); ylim([0 80])
		
		figure(8982);
		subplot(5,4,subNum); hold on
		plot( eye_pos_head_rot(:,4),eye_pos_head_rot(:,2),'*' )
		plot(eyey_headp.x,eyey_headp.f,'*-')
		ylabel('Eye - Vertical'); xlabel('Head - Pitch')
		lsline
		[rho,pval]=corr(eye_pos_head_rot(:,2), eye_pos_head_rot(:,4));
		title(['r= ' num2str(rho) ', p= ' num2str(pval) ])
		xlim([-40 40]); ylim([0 60])
	end
	
	
	eye_pos_head_rot_AllSubs=[eye_pos_head_rot_AllSubs; ...
		eye_pos_head_rot zeros(size(eye_pos_head_rot,1),1)+subNum];
	
	eye_pos_head_rot_THRESH_AllSubs=[eye_pos_head_rot_THRESH_AllSubs; ...
		eye_pos_head_rot_THRESH zeros(size(eye_pos_head_rot_THRESH,1),1)+subNum];
	
	%these may or may not fill depending on above (it's faster to not do
	%the kernel fit
	F_x_PerSub_TrialList=[F_x_PerSub_TrialList; F_x_TrialList];
	delta_eye_x_PerSub_TrialList=[delta_eye_x_PerSub_TrialList; delta_eye_x_TrialList;];
	F_y_PerSub_TrialList=[F_y_PerSub_TrialList; F_y_TrialList];
	delta_eye_y_PerSub_TrialList=[delta_eye_y_PerSub_TrialList; delta_eye_y_TrialList;];
	
	%these should always fill - can be used for kernel fit or for nn fit
	Kernel_PerSubCondTrialList=[Kernel_PerSubCondTrialList; KernelCondTrialList zeros(size(KernelCondTrialList,1),1)+subNum];
	Fx_pred_PerTrial_PerSub=[Fx_pred_PerTrial_PerSub; Fx_pred_PerTrial];
	Fy_pred_PerTrial_PerSub=[Fy_pred_PerTrial_PerSub; Fy_pred_PerTrial];
	
	LookPropMatrixRAW_H_PerSub(:,:,:,subNum)=LookPropMatrixRAW_H;
	
    %horizontal
    [fitx_r,fitx_x,fitx_y, fitx_mserror, fit_predx] = ...
        kernel_final_fit_perSubject(Fx_pred_PerTrial_PerSub,0);
    
    %vertical
    [fity_ry,fity_x,fity_y, fity_mserror,fit_predy] = ...
        kernel_final_fit_perSubject(Fy_pred_PerTrial_PerSub,1);

    pred_Dist=calcDist([Fx_pred_PerTrial_PerSub(:,7) ...
        Fy_pred_PerTrial_PerSub(:,7)], [fit_predx fit_predy]);
    
    predStruct(subNum).DistPerSub=pred_Dist;
    
    perSub_rmse(subNum,:)=[fity_mserror.predict_FRAME_AVE ...
        fitx_mserror.predict_FRAME_AVE mean(pred_Dist) std(pred_Dist)];
    
   %hist(pred_Dist,100)
    %clear out stray variables for new data set
	CleanSweep
	
%    keyboard
end

%-------------------------------
toc
%max_move_HeadAng, head_time, eye_time, eye_time_ff
headSpace

if(~isempty(ms_error_TrialList))
	figure(9292); clf; hold on
	%plot(mean(EyeDeviation_PerSubCond_AVE,2))
	%errorbar(1:12, mean(EyeDeviation_PerSubCond_MEAN_XY,2), ...
	%	std(EyeDeviation_PerSubCond_MEAN_XY,[],2)./sqrt(size(EyeDeviation_PerSubCond_MEAN_XY,2)))
	%boxplot(EyeDeviation_PerSubCond_MEAN_XY') % central bias
	boxplot(EyeDeviation_PREDICT_PerSubCond_MEAN_XY') %kernel
	
	xlabel('Condition [1:4-Small] [5:8-Medium] [9:12-Large]')
	ylabel('RMS Error (Degrees)')
	xlim([0 13]); ylim([0 30])
	%title('Central Bias - Peak of Fix PDF')
	set(gca,'FontSize',24)
	title('Kernel Method -6DOF')
	
	figure(9191);clf;
	subplot(2,1,1); hold on;
	errorbar(1:12, nanmedian(EyeDeviation_PREDICT_PerSubCond_MEAN_XY,2),...
		nanstd(EyeDeviation_PREDICT_PerSubCond_MEAN_XY,[],2)./sqrt(size(EyeDeviation_PREDICT_PerSubCond_MEAN_XY,2)),'LineWidth',3)
	
	% 	errorbar(1:12, mean(EyeDeviation_PerSubCond_MEAN_XY,2), ...
	% 		std(EyeDeviation_PerSubCond_MEAN_XY,[],2)./sqrt(size(EyeDeviation_PerSubCond_MEAN_XY,2)),'LineWidth',3)
	%
	ylim([0 20])
	xlabel('Condition [1:4-Small] [5:8-Medium] [9:12-Large]')
	ylabel('RMS Error (Degrees)')
	xlim([0 13]); ylim([0 30])
	set(gca,'FontSize',24)
	legend('Kernel') %, 'Central Bias')
	
	subplot(2,1,2); hold on;
	plot(EyeDeviation_PREDICT_PerSubCond_MEAN_XY ,'LineWidth',3)
	ylim([0 20])
	xlabel('Condition [1:4-Small] [5:8-Medium] [9:12-Large]')
	ylabel('RMS Error (Degrees)')
	xlim([0 13]); ylim([0 30])
	set(gca,'FontSize',24)
end

latency_length_list=[];
for mmm=1:size(eh_lat,3) %subjecgt
	for ppp=1:size(eh_lat,2) %condition
		a=max_move_HeadAng(:,ppp,mmm);
		b=eh_lat(:,ppp,mmm);
		
		idx=~(isnan(a) | isnan(b));
		if(sum(idx)>0)
			latency_length_list=[latency_length_list; a(idx) b(idx) ...
				zeros(sum(idx),1)+ppp zeros(sum(idx),1)+mmm];
		end
	end
end


%idx=latency_length_list(:,4)==8;
figure(92911)
plot(latency_length_list(:,1), latency_length_list(:,2),'*')
ylabel('llatency')
EvalCentralBias_AcrossSub

nn_fit_teesid

ModelFitCompare

nanmean(nanmean(percent_of_trial_used,1),3)

ideal_errors

percent_trials_used

keyboard
%nn_fit
%average across trial types
% for conditionNum=1:length(n)
% 	ave_Subs(:,:,conditionNum)=mean(LookProp_AllSubs(:,:,conditionNum,:),4);
% 	ave_Subs_HeadThresh(:,:,conditionNum)=mean(LookProp_AllSubs_HeadThresh(:,:,conditionNum,:),4);
% end

%lets plot only certain portions
%six total types of conditions
%0 0 slow small
%1 0 fast small
%0 1 slow med
%1 1 fast med
%0 2 slow large
%1 2 fast large