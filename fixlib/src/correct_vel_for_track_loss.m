%CORRECT_VEL_FOR_TRACK_LOSS removes velocity artifacts due to track loss
%Corrects the velocity track losses and blinks.
%
%Constantin Rothkopf July 2002
%pilardi 2/02
function [vel,state] = correct_vel_for_track_loss(  t, vel_in, raw_asl, pupil_thresh  )

%used modifiable constants

vidXsc=1280; vidYsc=960;
vidXeye=1707; vidYeye=1252; %ok so this was the trick turns out eye camera tracks
vidXdel=round((vidXeye-vidXsc)/2);
vidYdel=round((vidYeye-vidYsc)/2);
%more than the scene camerea

%video res is 1280x960, but we need some slack
MAX_ASL_COORD_HORZ      =vidXsc+vidXdel; %max asl coordinates (260,240) = true
MAX_ASL_COORD_VERT      =vidYsc+vidYdel;
MIN_ASL_COORD_HORZ      =-vidXdel; %max asl coordinates (260,240) = true
MIN_ASL_COORD_VERT      =-vidYdel;

DEGREES_HORZ            =80; %60; %max visual angle in degrees
DEGREES_VERT            =60; %46; %see above it's larger than scene cam
DEGS_PER_ASL_HORZ       =DEGREES_HORZ/vidXeye;
DEGS_PER_ASL_VERT       =DEGREES_VERT/vidYeye;
ANGLE_THRESH            =1; %max distance between fixes (before clump)
LOW_PUPIL_TIME_LIMIT    =100; %on low_pupil, end fixation if above threshold
MAX_VEL=101;

%fixation error states
BAD_TRACK_FIXATION_CONTINUED    =1; %track lost and picks up in
%  same spot (continue fixation).
BAD_TRACK_FIXATION_ENDED        =2; %track lost and picks up in
%  different spot (end fixation).
LOW_PUPIL_FIXATION_CONTINUED    =3; %low pupil temporarily and picks up in
%  same spot (continue fixation).
LOW_PUPIL_FIXATION_ENDED        =4; %low pupil temporarily and picks up in
%  different spot (end fixation).
LOW_PUPIL_TIMEOUT               =5; %low pupil for longer than threshold.

x=raw_asl(:,1:2);
pupil=raw_asl(:,3);

%default pupil threshold of zero if empty
if(isempty(pupil_thresh))
    pupil_thresh=0.5;
end

%label low pupil and bad track
low_pupil       = pupil <= pupil_thresh;
bad_track_horz  = or(x(:,1)<MIN_ASL_COORD_HORZ,x(:,1)>MAX_ASL_COORD_HORZ);
bad_track_vert  = or(x(:,2)<MIN_ASL_COORD_VERT,x(:,2)>MAX_ASL_COORD_VERT);
total_loss      = or( x(:,1) == 0 , x(:,2) == 0 );
bad_track       = (bad_track_horz)|(bad_track_vert)|(total_loss);

%sum(low_pupil)/length(raw_asl)
%sum(bad_track)/length(raw_asl)
%sum(low_pupil&bad_track)/length(raw_asl)


vel=vel_in;

%drop nans
vel(isnan(vel))=MAX_VEL;


state=zeros(length(t),1);
%correct for out of range eye positions
start_loss=-1;

for i=2:length(t)

    if(and(start_loss==-1,bad_track(i))) %beginning of bad track detected
        start_loss=i;
    elseif (start_loss~=-1)
        if (or(not(bad_track(i)),i==length(t))) %end of bad track detected
            delta_angle_horz=(x(start_loss-1,1)-x(i,1))*DEGS_PER_ASL_HORZ;
            delta_angle_vert=(x(start_loss-1,2)-x(i,2))*DEGS_PER_ASL_VERT;
            delta_angle=sqrt(delta_angle_horz^2+delta_angle_vert^2);
            if(delta_angle>ANGLE_THRESH) %fixation came up in new spot
                vel(start_loss-1:i)= MAX_VEL; %maximum angular saccade velocity(Carpenter:'Eye Movements')
                state(start_loss-1:i)=BAD_TRACK_FIXATION_ENDED;
            else                         %fixating in same spot
                vel(start_loss-1:i)=0;
                state(start_loss-1:i)=BAD_TRACK_FIXATION_CONTINUED;
            end
            start_loss=-1;
        end
    end
end

%correct for low pupil
start_loss=-1;
for i=2:length(t)
    if(and(start_loss==-1,low_pupil(i))) %beginning of low pupil detected
        start_loss=i;
    elseif (start_loss~=-1)
        if (or(and(not(low_pupil(i)),not(bad_track(i))),i==length(t)))
            delta_angle_horz=(x(start_loss-1,1)-x(i,1))*DEGS_PER_ASL_HORZ;
            delta_angle_vert=(x(start_loss-1,2)-x(i,2))*DEGS_PER_ASL_VERT;
            delta_angle=sqrt(delta_angle_horz^2+delta_angle_vert^2);
            delta_time=abs(t(start_loss-1)-t(i)); %time in millis
            
            if(delta_angle>ANGLE_THRESH)         %came up in new spot
                vel(start_loss:i)=MAX_VEL;%maximum angular saccade velocity(Carpenter:'Eye Movements')
                state(start_loss:i)=LOW_PUPIL_FIXATION_ENDED;
            elseif(delta_time>LOW_PUPIL_TIME_LIMIT) %took too long
                vel(start_loss:i)=MAX_VEL;%maximum angular saccade velocity(Carpenter:'Eye Movements')
                state(start_loss:i)=LOW_PUPIL_TIMEOUT;
            else                                 %fixation continued
                vel(start_loss:i)=0;
                state(start_loss:i)=LOW_PUPIL_FIXATION_CONTINUED;
            end
            start_loss=-1;
        end
        
    end

end

% figure(101); clf; hold on;
% plot(vel_in)
% plot(vel)
% plot(state*100)
%keyboard
return


