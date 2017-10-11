%CORRECT_VEL_FOR_TRACK_LOSS removes velocity artifacts due to track loss
%Corrects the velocity track losses and blinks.
%
%Constantin Rothkopf July 2002
%pilardi 2/02


function [vel,state] = correct_arrington_vel_for_track_loss(  t, vel_in, raw_asl, pupil_thresh  )

%used modifiable constants
MAX_ASL_COORD_HORZ      =1; %260; %max asl coordinates (260,240) = true
%res but we need some slack
MAX_ASL_COORD_VERT      =1; %240;
DEGREES_HORZ            =86; %max visual angle in degrees
DEGREES_VERT            =69;
DEGS_PER_ASL_HORZ       =DEGREES_HORZ/MAX_ASL_COORD_HORZ;
DEGS_PER_ASL_VERT       =DEGREES_VERT/MAX_ASL_COORD_VERT;
ANGLE_THRESH            =2.5; %on fixation error, end fixation if above threshold
LOW_PUPIL_TIME_LIMIT    =200; %on low_pupil, end fixation if above threshold

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
    pupil_thresh=0;
end

%label low pupil and bad track
low_pupil       = pupil <= pupil_thresh;
bad_track_horz  = or(x(:,1)<0,x(:,1)>MAX_ASL_COORD_HORZ);
bad_track_vert  = or(x(:,2)<0,x(:,2)>MAX_ASL_COORD_VERT);
total_loss      = and( x(:,1) == 0 , x(:,2) == 0 );
bad_track       = (bad_track_horz)|(bad_track_vert)|(total_loss);

vel=vel_in;

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
                vel(start_loss-1:i)= 600; %maximum angular saccade velocity(Carpenter:'Eye Movements')
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
            delta_time=(t(start_loss-1)-t(i)); %time in millis
            if(delta_angle>ANGLE_THRESH)         %came up in new spot
                vel(start_loss-1:i)=600;%maximum angular saccade velocity(Carpenter:'Eye Movements')
                state(start_loss-1:i)=LOW_PUPIL_FIXATION_ENDED;
            elseif(delta_time>LOW_PUPIL_TIME_LIMIT) %took too long
                vel(start_loss-1:i)=600;%maximum angular saccade velocity(Carpenter:'Eye Movements')
                state(start_loss-1:i)=LOW_PUPIL_TIMEOUT;
            else                                 %fixation continued
                vel(start_loss-1:i)=0;
                state(start_loss-1:i)=LOW_PUPIL_FIXATION_CONTINUED;
            end
            start_loss=-1;
        end
    end
end



return


