clear all; clc


data_dir='C:\Users\bs16044\Documents\GLANCE\EyeHead_Exp\tobii_data\data\';
loadFileList
viz=1;

%Tobii Camera 25hz - see bottom of file for data description
%82 deg. horizontal / 52 deg. vertica
thresh_gyro=rad2deg(0.5)/5;% Paper has 0.5 rads? seems high 3; %deg/sec head rotation threshold
thresh_accelerometer=3; %m/s also from paper
fov_x=82; fov_y=52;
maxVidResX=1920;
maxVidResY=1080;
pix_c= 3; %factor for size of bins = c*1deg
%this assumes lens is homogeneous which may not be true
pix2deg_X=maxVidResX/fov_x; pix2deg_Y=maxVidResY/fov_y;

for subNum=1:size(file_list,1)
    
    fn1=file_list{subNum,1};
    fn2=file_list{subNum,2};
    dat=readtable([data_dir fn1]);
    matdat=load([data_dir fn2]);
    
    MarkTrialType;
    
    t=dat.RecordingTimestamp/1000;
    
    % eye & IMU are on different frame rates so many empty entries (which come
    % up as nans)
    nan_idx=~isnan(dat.GazePointX);
    GazePointX=dat.GazePointX(nan_idx);
    GazePointY=dat.GazePointY(nan_idx);
    GazePointTime=t(nan_idx);
    
    nan_idx=~isnan(dat.GyroX);
    GyroX=dat.GyroX(nan_idx);
    GyroY=dat.GyroY(nan_idx);
    GyroZ=dat.GyroZ(nan_idx);
    GyroAbsolute=sqrt(GyroX.^2+GyroY.^2+GyroZ.^2);
    GyroTime=t(nan_idx);
    
    nan_idx=~isnan(dat.AccelerometerX);
    AccelerometerX=dat.AccelerometerX(nan_idx);
    AccelerometerY=dat.AccelerometerY(nan_idx);
    AccelerometerZ=dat.AccelerometerZ(nan_idx);
    AccelerometerAbsolute=sqrt(AccelerometerX.^2+...
        AccelerometerY.^2+(AccelerometerZ).^2)-9.8;
    AccelerometerTime=t(nan_idx);
    
    %---- get right event times for aligning conditions & data
    %for both standard eye time & gyro time
    EventList=[];
    for i=1:length(dat.Event)
        if(length(dat.Event{i})==17)
            EventList(end+1)=i;
        end
    end
    
    %event list is in terms of global time but we need to line up
    %with eye gaze time
    EventList_T=[];
    for i = 1:length(EventList)
        [val,idx]=min(abs(t(EventList(i))-GazePointTime));
        EventList_T(i)=idx;
        
        [val,idx]=min(abs(t(EventList(i))-GyroTime));
        EventList_T_gyro(i)=idx;
        
    end
    
    EventIdx=[]; EventIdx_gyro=[];
    %intermediate
    for i=1:(length(EventList_T)-1)
        EventIdx(end+1,:)= [EventList_T(i) EventList_T(i+1)-1];
        EventIdx_gyro(end+1,:)= [EventList_T_gyro(i) EventList_T_gyro(i+1)-1];
    end
    
    %last entry
    EventIdx(end+1,:)=[EventList_T(end) length(GazePointTime)];
    EventIdx_gyro(end+1,:)=[EventList_T_gyro(end) length(GyroTime)];
    
    %-----end event alignment ---
    
    %ok so 1 pixel bins is too much
    %could use hist3([GazePointX GazePointY]), but instead try
    
    [LookPropMatrixRAW,LookPropMatrixPERC] = ...
        spatialhist(GazePointX,GazePointY,...
        maxVidResX,maxVidResY,...
        pix2deg_X*pix_c,pix2deg_Y*pix_c);
    
    for i = 1:length(AccelerometerX)
        Integrate_ACC_X(i)=sum(AccelerometerX(1:i));
        Integrate_ACC_Y(i)=sum(AccelerometerY(1:i));
        Integrate_ACC_Z(i)=sum(AccelerometerZ(1:i));
    end
    
    
    for i = 1:length(GyroX)
        Integrate_GYRO_X(i)=sum(GyroX(1:i));
        Integrate_GYRO_Y(i)=sum(GyroY(1:i));
        Integrate_GYRO_Z(i)=sum(GyroZ(1:i));
    end
    
    if(viz)
        figure(1); clf;
        subplot(5,1,1); hold on;
        title('Eye Position, ')% num2str(smp_rate(1)) 'Hz' ])
        plot(GazePointTime,GazePointX)
        plot(GazePointTime,GazePointY)
        ylabel('Pixel Position')
        legend('X','Y')
        
        
        subplot(5,1,2); hold on;
        title('Gyro') %, ' num2str(smp_rate(2)) 'Hz' ])
        plot(GyroTime,GyroX)
        plot(GyroTime,GyroY)
        plot(GyroTime,GyroZ)
        plot(GyroTime,GyroAbsolute)
        legend('X','Y','Z','ABS')
        ylabel('Angular Velocity (deg/sec)')
        
        subplot(5,1,3); hold on;
        title('Integrated Gyro') %, ' num2str(smp_rate(2)) 'Hz' ])
        plot(GyroTime,Integrate_GYRO_X)
        plot(GyroTime,Integrate_GYRO_Y)
        plot(GyroTime,Integrate_GYRO_Z)
        legend('X','Y','Z','ABS')
        ylabel('Angle (deg)')

        subplot(5,1,4); hold on;
        plot(AccelerometerTime,AccelerometerX)
        plot(AccelerometerTime,AccelerometerY)
        plot(AccelerometerTime,AccelerometerZ)
        plot(AccelerometerTime,AccelerometerAbsolute-9.8)
        legend('X','Y','Z','ABS')
        title('Accelerometer') %, ' num2str(smp_rate(3)) 'Hz' ])
        ylabel('Linear Acceleration (m/s^2)')
        xlabel('Time (s)')
        
        subplot(5,1,5); hold on;
        plot(AccelerometerTime,Integrate_ACC_X)
        plot(AccelerometerTime,Integrate_ACC_Y)
        plot(AccelerometerTime,Integrate_ACC_Z)
        legend('X','Y','Z')
        title('Integrated Accelerometer') %, ' num2str(smp_rate(3)) 'Hz' ])
        ylabel('Linear Velocity (m/s)')
        xlabel('Time (s)')

        
        figure(2); clf; hold on
        plot(GyroTime,GyroAbsolute)
        plot([0 GyroTime(end)],[thresh_gyro thresh_gyro],'Color','r')
        legend('ABS','Threshold')
        ylabel('Angular Velocity (deg/sec)')
        xlabel('Time (s)')
        
        figure(3); clf
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
        
    end
    
    %go in oder along conditions
    [idx,n]=sortrows(blockOrder);
    
    CondLabels={'Slow,Small'
        'Fast,Small'
        'Slow,Medium'
        'Fast,Medium'
        'Slow,Large'
        'Fast,Large'};
    
    %map gaze & gyro
    %only consider time when head is still
    %map gyro time to eye time
    %since gyro has 2x samples just find closest to eye & use that one
    Gyro2GazeTimeMapping=[];
    Accelerometer2GazeTimeMapping=[];
    for i=1:length(GazePointTime)
        [VAL,IDX]=min(abs(GazePointTime(i)-GyroTime));
        Gyro2GazeTimeMapping(i)=IDX;
        
        [VAL,IDX]=min(abs(GazePointTime(i)-AccelerometerTime));
        Accelerometer2GazeTimeMapping(i)=IDX;
        
    end
    
    if(viz)
        figure(4); clf
        figure(5); clf
    end
    
    plotidx=[1 4 2 5 3 6];
    %given our different types of conditions lets plot them separately
    for conditionNum=1:length(n)
        
        idx_rng=EventIdx(n(conditionNum),1):EventIdx(n(conditionNum),2);
        
        [LookPropMatrixRAW,LookPropMatrixPERC] = ...
            spatialhist(GazePointX(idx_rng),GazePointY(idx_rng),...
            maxVidResX,maxVidResY,...
            pix2deg_X*pix_c,pix2deg_Y*pix_c);
        
        if(viz)
            figure(4);
            subplot(2,3,plotidx(conditionNum));
            imagesc(LookPropMatrixPERC); hold on
            title(CondLabels{conditionNum})
            colorbar
            
            if(conditionNum==1)
                xlabel('Vert Position (Degrees)')
                ylabel('Horz Position (Degrees)')
            end
            
            [v1,i1]=max(LookPropMatrixPERC,[],1);
            [v1,i1]=max(v1);
            [v2,i2]=max(LookPropMatrixPERC,[],2);
            [v2,i2]=max(v2);
            scatter(i1,i2, 40, 'r','filled', 'o')
            
        end
        
        Gyro_InGazeTime=GyroAbsolute(Gyro2GazeTimeMapping);
        Accelerometer_InGazeTime=AccelerometerAbsolute(Accelerometer2GazeTimeMapping);
        
        %now use gyro timing wrt to gaze as we have converted time base
        below_gyro_thresh=Gyro_InGazeTime(idx_rng)<=thresh_gyro;
        below_accelerometer_thresh=Accelerometer_InGazeTime(idx_rng)<=thresh_accelerometer;
        below_thresh=find(below_gyro_thresh&below_accelerometer_thresh);
        x=GazePointX(idx_rng(below_thresh));
        y=GazePointY(idx_rng(below_thresh));
        
        %plot only time when head was below threshold
        [LookPropMatrixRAW_H,LookPropMatrixPERC_H] = ...
            spatialhist(x,y, maxVidResX, maxVidResY,...
            pix2deg_X*pix_c,pix2deg_Y*pix_c);
        
        if(viz)
            figure(5);
            subplot(2,3,plotidx(conditionNum));
            imagesc(LookPropMatrixPERC_H); hold on
            title(CondLabels{conditionNum})
            colorbar;
            
            if(conditionNum==1)
                xlabel('Vert Position (Degrees)')
                ylabel('Horz Position (Degrees)')
            end
            [v1,i1]=max(LookPropMatrixPERC,[],1);
            [v1,i1]=max(v1);
            [v2,i2]=max(LookPropMatrixPERC,[],2);
            [v2,i2]=max(v2);
            scatter(i1,i2, 40, 'r','filled', 'o')
        end
        
        LookProp_AllSubs(:,:,conditionNum,subNum)=LookPropMatrixPERC;
        LookProp_AllSubs_HeadThresh(:,:,conditionNum,subNum)=LookPropMatrixPERC_H;
    end
    
    
    keyboard
end

figure(6); clf;  figure(7); clf;
%average across trial types
for conditionNum=1:length(n)
    ave_Subs(:,:,conditionNum)=mean(LookProp_AllSubs(:,:,conditionNum,:),4);
    ave_Subs_HeadThresh(:,:,conditionNum)=mean(LookProp_AllSubs_HeadThresh(:,:,conditionNum,:),4);
    
    figure(6);
    subplot(2,3,plotidx(conditionNum))
    imagesc(ave_Subs(:,:,conditionNum)); hold on
    title(CondLabels{conditionNum})
    colorbar;
    
    if(conditionNum==1)
        xlabel('Vert Position (Degrees)')
        ylabel('Horz Position (Degrees)')
    end
    
    figure(7);
    subplot(2,3,plotidx(conditionNum))
    imagesc(ave_Subs_HeadThresh(:,:,conditionNum)); hold on;
    title(CondLabels{conditionNum})
    colorbar;
    if(conditionNum==1)
        xlabel('Vert Position (Degrees)')
        ylabel('Horz Position (Degrees)')
    end
    
end

keyboard

%lets plot only certain portions

%six total types of conditions
%0 0 slow small
%1 0 fast small
%0 1 slow med
%1 1 fast med
%0 2 slow large
%1 2 fast large

% files contain:
%     'ProjectName'
%     'ExportDate'
%     'ParticipantName'
%     'RecordingName'
%     'RecordingDate'
%     'RecordingStartTime'
%     'RecordingDuration'
%     'RecordingFixationFilterName'
%     'SnapshotFixationFilterName'
%Above aren't too useuful

%     'RecordingTimestamp'
%     'GazePointX'
%     'GazePointY'

%     'Gaze3DPositionLeftX'
%     'Gaze3DPositionLeftY'
%     'Gaze3DPositionLeftZ'
%     'Gaze3DPositionRightX'
%     'Gaze3DPositionRightY'
%     'Gaze3DPositionRightZ'
%     'Gaze3DPositionCombinedX'
%     'Gaze3DPositionCombinedY'
%     'Gaze3DPositionCombinedZ'

%     'GazeDirectionLeftX'
%     'GazeDirectionLeftY'
%     'GazeDirectionLeftZ'
%     'GazeDirectionRightX'
%     'GazeDirectionRightY'
%     'GazeDirectionRightZ'

%     'PupilPositionLeftX'
%     'PupilPositionLeftY'
%     'PupilPositionLeftZ'
%     'PupilPositionRightX'
%     'PupilPositionRightY'
%     'PupilPositionRightZ'

%     'PupilDiameterLeft'
%     'PupilDiameterRight'

%     'EyeMovementType'
%     'GazeEventDuration'
%     'EyeMovementTypeIndex'

%     'FixationPointX'
%     'FixationPointY'

%     'Event'
%     'RecordingMediaName'
%     'RecordingMediaWidth'
%     'RecordingMediaHeight'

%     'GyroX'
%     'GyroY'
%     'GyroZ'

%     'AccelerometerX'
%     'AccelerometerY'
%     'AccelerometerZ'
%