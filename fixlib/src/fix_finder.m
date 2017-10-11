% FIX_FINDER This .m file acts as a central .m file to process data
%   with several fixation finding algorithms. You specify a file
%   and some parameters, and this program computes the fixations and
%   saves the results in a ".fix" and a ".mat" file (conveniently labeled with
%   said parameters). Please note that within matlab you can enter
%   ">>type README.fix_finder" to find a somewhat redundant but more
%   comprehensive explanation
%
%  Currently fix_finder.m is run as follows:
%
%  fix_finder('experiment_type', method, vel_thresh, t_thresh, 
%              clump_space_thresh, clump_t_thresh, viz_results, 'datafilename')
%
%  Here is a list of the possible parameters (some of which require
%  editing the fix_finder.m file:
%
%  filename =  '(name of datafile goes here');  <--Command line
%
%  Experiment type = 'cba' (Jochen Triesch), <-- Command Line
%                    'bricks' (Jason Droll),
%                    'bfx' (Pili Aivar),
%                    'baufix' (Neil Mennie);
%
%  eye data type (asl, eih, gaze)
%  (Example)  eye_data_type =              'eih';%
%  Note : Eye in head(eih) seems to work best.
%
%  This will graph the output:
%  visualizing results (1 = Yes ,0 = No)
%  (Example)  viz_results =                1; <-command line
%
%  Method defines the algorithm(s) that will be  used for fixation detection:
%  1:        velocity threshold
%  2:        adaptive velocity threshold
%  4:        adaptive acceleration threshold
%  8:        2 state hidden markov model with single gaussian
%  x+y+z:    Scoring based on three algorithms: ie. 1+2+8 = 11 does scoring using 1,2,8
%
%
%  Time threshold (ie. The output will not contain
%  fixations shorter than the specified duration
%    (Example)  t_thresh =                   50; % ms <- command line
%
%  Velocity threshold (ie. A fixation will be identified if a data point falls
%  under the specified velocity AND if it lasts for the length of t_thresh)
%    (Example)  vel_thresh =                115; % deg/sec <- command line
%
%
%  Clumping can be use to group together fixations that occur within
%  a certain time and space threshold of one another:
%
%  Clumping parameters (use [] to disable)
%  (Example)   clump_space_thresh =         1.5; % deg < - command line
%  (Example)   clump_t_thresh =             50; % ms <- command line
%  The above settings will "clump" together fixations that occur within
%  50ms of one another and are separated by less than or equal to 1.5deg
%
%  This parameter will filter out possible blinks and track losses:
%  track loss parameters (use [] to disable)
%    track_loss_pupil_thresh =    0; %0, if the ASL tracker is setup accordingly
%
%  Turn this parameter on to save the results of the algorithms:
%  save_dot_fix_file =          1; % 1 to save, else 0
%  save_mat_file =              1; % 1 to save, else 0
%
%  Note:  Saving data for a one algorithm analysis will result in a
%  text .fix that is used in the Fixation_Browser VCR program.  Additionally
%  a .mat file can be savd so that the results may be easily accesed in matlab.
%  If multiple algoritms are used there are individual .fix files for
%  each algorithm and the mat file saved will contain results for
%  all algorithms and for confidence testing.  In addition each
%  level of confidence will have it's own .fix file (Hi, Med, Low)
%  and .mat file. Of course you can save only .mat or only .fix
%  files too.
%
%  Reestimation: The HMM model uses two probability distributions to
%  identify a velocity as being from a moving eye or non-moving eye.
%  By default the HMM uses distribution and transition values
%  estimated over  a certain experimental data set which sometimes
%  may not be completely correct for individuals or new experiments.
%  As such, reestimation is useful to find new means and standard
%  deviations for these distributions and the transition probablities
%  within and between them.  Please note this can be a lengthy computation
%  for even small data files.
%
%  reestimate = 0; % 1 to reestimate


function [fix, fix_frames, vel, fixlabels_text, fixlabels_id, save_data_filename] = ...
    fix_finder(filename,experiment_type, method, vel_thresh,...
    t_thresh, clump_space_thresh, clump_t_thresh, viz_results, asl_h,...
    asl_v, asl_pupil, t, tc, fixlabels, winsize,m,b)


%close all;

% 1. SET PARAMETERS
%**********************************************************************************
%filename =  'MD_G2_071101.dat';

%Experiment type = 'cba' (Jochen Triesch),
%                  'bricks' (Jason Droll),
%                  'bfx' (Pili Aivar),
%                  'baufix' (Neil Mennie);
%experiment_type = 'cba';

% eye data type (asl, eih, gaze)
eye_data_type =              'eih';

% visualizing results (1 = Yes ,0 = No)
%viz_results =                1;

%manual = 0; %hand coded data

% method defines the algorithm for fixation detection
% 1:        velocity threshold
% 2:        adaptive velocity threshold
% 4:        adaptive acceleration threshold
% 8:        2 state hidden markov model with single gaussian
% x+y+z:    Scoring based on three algorithms: 1+2+8 = 11 does scoring using 1,2,8
%method      = 1;

%Time threshold (ie. The output will not contain
%fixations shorter than the specified duration
%t_thresh =                   50; % ms

%Velocity threshold (ie. A fixation will be identified if a data point falls
%under the specified velocity AND if it lasts for the length of t_thresh)
%vel_thresh =                50; % deg/sec

% clumping parameters (use [] to disable)
%    clump_space_thresh =         []; % deg
%    clump_t_thresh =             []; % ms

% track loss parameters (use [] to disable)
track_loss_pupil_thresh =    []; %0, if the ASL tracker is setup accordingly

save_dot_fix_file =          0; % 1 to save, else 0
save_mat_file =              0; % 1 to save, else 0

reestimate = 0; % 1 to reestimate

%the adapdtive finders have a window size for averaging and gain & offset
%parameters: winsize,m,b

%**********************************************************************************
%The above variables are the only things you really need to set. Read below
%for the actual function calls and the setup for confidence scoring
%**********************************************************************************


% set up names for datafile of results
if(method == 1)
    method_string = 'Velocity';
elseif(method == 2)
    method_string = 'AdaptAccel';
elseif(method == 3)
    method_string = 'AAt.Vt';
elseif(method == 4)
    method_string = 'AdaptVel';
elseif(method == 5)
    method_string = 'AVt.Vt';
elseif(method == 8)
    method_string = 'HMM';
else
    method_string = 'All';
end

if (isempty(clump_space_thresh))&(isempty(clump_t_thresh))
    save_data_filename = [filename, '_meth=', method_string , '_time', int2str(t_thresh),...
        '_vel', int2str(vel_thresh), '.data.fix'];
else
    save_data_filename = [filename, '_meth=', method_string , '_time', ...
        int2str(t_thresh), '_vel', int2str(vel_thresh), '_clump_space', ...
        int2str(clump_space_thresh), '_clump_t', int2str(clump_t_thresh), '.data.fix'];
end


% 2. READ IN DATA
%**********************************************************************************
%for the apartment exp

%[eih_h, eih_v,asl_h,asl_v] = asl2angle(asl_h, asl_v);
%[eih_h, eih_v,asl_h,asl_v] = arrington2angle(asl_h, asl_v);
[eih_h, eih_v] = smi2angle(asl_h, asl_v);

if(strcmp(eye_data_type, 'asl'))
    pos_h = asl_h;
    pos_v = asl_v;
elseif(strcmp(eye_data_type, 'eih'))
    pos_h = eih_h;
    pos_v = eih_v;
elseif(strcmp(eye_data_type, 'gaze'))
    gaze_h = eih_h + fastrak_h;
    gaze_v = eih_v + fastrak_p;
    pos_h = gaze_h;
    pos_v = gaze_v;
else
    error(['bad eye_data_type: ', eye_data_type]);
end


% DO ANALYSIS
%**********************************************************************************
% method defines the algorithm for fixation detection
% 1:        velocity threshold
% 2:        adaptive velocity threshold
% 4:        adaptive acceleration threshold
% 8:        2 state hidden markov model with single gaussian
% x+y+z:    scoring based on three algorithms: 1+2+8 = 11 does scoring using 1,2,8

switch method;
    %velocity threshold
    case 1
        [fix, fix_frames, vel] = fix_finder_vt(  t, [pos_h pos_v], [asl_h, asl_v, asl_pupil], ...
            clump_space_thresh, ...
            clump_t_thresh, ...
            track_loss_pupil_thresh, ...
            t_thresh, ...
            vel_thresh  );

        %adaptive acceleration threshold
    case 2
        [fix, fix_frames] = fix_finder_adaptive_at(  t, [pos_h pos_v], [asl_h,asl_v,asl_pupil], ...
            clump_space_thresh, ...
            clump_t_thresh, ...
            track_loss_pupil_thresh, ...
            t_thresh  );

        %adaptive velocity threshold
    case 4
        [fix, fix_frames, avel_thresh,vel] = fix_finder_adaptive_vt(  t, [pos_h pos_v], [asl_h,asl_v,asl_pupil], ...
            clump_space_thresh, ...
            clump_t_thresh, ...
            track_loss_pupil_thresh, ...
            t_thresh, ...
            vel_thresh, winsize, m, b );
        
        %2 state hidden markov model with single gaussian
    case 8
        [fix, fix_frames] = fix_finder_hmm(  t, [pos_h pos_v], [asl_h, asl_v,asl_pupil], ...
            clump_space_thresh, ...
            clump_t_thresh, ...
            track_loss_pupil_thresh, ...
            t_thresh, reestimate, experiment_type );

        %scoring based on three algorithms: 1+2+8 = 11 (1011) does scoring using 1,2,8
    otherwise

        %get binary representation
        method_str  = dec2base( method, 2,4);
        state_vec   = 0.*t;

        %velocity threshold
        if method_str(1) == '1'
            [vel_fix vel_fix_frames] = fix_finder_vt(  t, [pos_h pos_v], [asl_h, asl_v, asl_pupil], ...
                clump_space_thresh, ...
                clump_t_thresh, ...
                track_loss_pupil_thresh, ...
                t_thresh, ...
                vel_thresh  );

            %convert to state vector
            state_vec   = state_vec + convert_t_fix( t , vel_fix )';
        end

        %adaptive acceleration threshold
        if method_str(2) == '1'
            [adap_accel_fix adap_accel_fix_frames ] = fix_finder_adaptive_at(  t, [pos_h pos_v], [asl_h,asl_v,asl_pupil], ...
                clump_space_thresh, ...
                clump_t_thresh, ...
                track_loss_pupil_thresh, ...
                t_thresh  );

            %convert to state vector
            state_vec   = state_vec + convert_t_fix( t , adap_accel_fix )';
        end

        %adaptive velocity threshold
        if method_str(3) == '1'
            [adap_vel_fix adap_vel_fix_frames] = fix_finder_adaptive_vt( t, [pos_h pos_v], [asl_h,asl_v,asl_pupil], ...
                clump_space_thresh, ...
                clump_t_thresh, ...
                track_loss_pupil_thresh, ...
                t_thresh, ...
                vel_thresh  );

            %convert to state vector
            state_vec   = state_vec + convert_t_fix( t , adap_vel_fix )';
        end

        %2-state hidden markov model with single gaussian
        if method_str(4) == '1'
            %FIRST DEFINE PARAMETERS
            [hmm_fix hmm_fix_frames] = fix_finder_hmm(  t, [pos_h pos_v], [asl_h, asl_v,asl_pupil], ...
                clump_space_thresh, ...
                clump_t_thresh, ...
                track_loss_pupil_thresh, ...
                t_thresh, reestimate, experiment_type   );

            %convert to state vector
            state_vec   = state_vec + convert_t_fix( t , hmm_fix )';
        end

        %***********************************************************************************
        %find three confidence levels
        states          = 3 - state_vec;
        [fix_hi fix_hi_frames ] = to_fix( t,states,0.5,10 );
        [fix_hi fix_hi_frames ] = remove_short_fixations( fix_hi , fix_hi_frames, 50, t);
        fix_hi_frames = average_pos(fix_hi_frames, [asl_h, asl_v]);

        [fix_mid fix_mid_frames ] = to_fix( t,states,1.5,10 );
        [fix_mid fix_mid_frames ] = remove_short_fixations( fix_mid , fix_mid_frames, ...
            50, t);
        fix_mid_frames = average_pos(fix_mid_frames, [asl_h, asl_v]);

        [fix_low fix_low_frames ] = to_fix( t,states,2.5,10 );
        [fix_low fix_low_frames ] = remove_short_fixations( fix_low , fix_low_frames, ...
            50, t);
        fix_low_frames = average_pos(fix_low_frames, [asl_h, asl_v]);
        %***********************************************************************************

end;%switch

%For multiple aglorithms by default set the return array 'fix' to the
%agreement struct
if (method ~= 1)&(method ~= 2)&(method ~= 4)&(method ~= 8)

    %for now only uses agreement not raw output from each alg
    fix.lo = fix_low; fix.mid = fix_mid; fix.hi = fix_hi;
    fix_frames.lo = fix_low_frames; fix_frames.mid = fix_mid_frames; fix_frames.hi = fix_hi_frames;
end





%**********************************************************************************
% 3. Label RESULTS -

% for i=1:length(fix)
% 
%     labels_tmp = fixlabels(fix_frames(i,1):fix_frames(i,2));
%     tmp=unique(labels_tmp);
%     %label fixation with most common label
%     clear count;
%     for j = 1:length(tmp)
%         count(j)=sum(labels_tmp==tmp(j));
%     end
%     [srtd,idx]=sort(count);
% 
%     fixlabels_text(i) = getTag(tmp(idx(end)));
%     fixlabels_id(i,1) = tmp(idx(end));
% 
%     %add 2nd label
%     if(length(tmp)>1)
%         fixlabels_id(i,2) = tmp(idx(end-1));
%     end
%     
%    
%     %    [val,idx]=max(count);
%     %    fixlabels_text(i) = getTag(tmp(idx));
%     %    fixlabels_id(i) = tmp(idx);
% 
%     
% end
fixlabels_text=[];
fixlabels_id=[];

%keyboard
%**********************************************************************************
% 4. Save RESULTS -

%ok we need to address the multiple algorithms here

if(save_dot_fix_file)

    if(method ~= 11)
        save_dot_fix(save_data_filename, fix, tc, fix_frames,fixlabels_text); %depending on
        % the algorithms run different files need to be made - need to make a
        % switch statement here
    elseif(method == 11)
        save_dot_fix([save_data_filename, '.hmm.fix'], hmm_fix, tc, fix_frames);
        save_dot_fix([save_data_filename, '.vel.fix'], vel_fix, tc, fix_frames);
        save_dot_fix([save_data_filename, '.adap_vel.fix'], adap_vel_fix, tc, fix_frames);
        save_dot_fix([save_data_filename, '.hi'], fix_hi, tc, fix_frames);
        save_dot_fix([save_data_filename, '.mid'],fix_mid, tc, fix_frames);
        save_dot_fix([save_data_filename, '.low'], fix_low, tc, fix_frames);
    end
end

if(save_mat_file)
    tmp_name = filename(1:(length(filename)-9));
    if(method ~= 11)
        save([save_data_filename, '.mat'], 'fix', 'fix_frames');
        % save_dot_fix note
    elseif(method == 11)

        save([tmp_name, '.3algs.mat'], 'fix_hi', 'fix_mid', ...
            'fix_low', 'vel_fix', 'adap_vel_fix', 'hmm_fix', 'vel_fix_frames', ...
            'adap_vel_fix_frames', 'hmm_fix_frames', 'fix_hi_frames', ...
            'fix_mid_frames', 'fix_low_frames');
    end
end



%**********************************************************************************
% 5. VISUALIZE RESULTS


if(~viz_results) 
        return; 
end



if (length(find(dec2base( method, 2 )=='1'))==1) %&(experiment_type~='aptexp')
    %only one algorithm
    fs      = new_fill_struct(  fix/1000,  [0 , vel_thresh], [ 0 0.7 0 ] , method_string);
    ps      = new_plot_struct([t/1000, vel], '-k' , [eye_data_type, ' vel']);
    as      = new_axes_struct([t(1), t(end)]/1000, [0, 150]);
    ts      = new_timeplot_struct(t/1000, 5, {{ps}}, {{fs}}, as);
    browser(ts);

elseif(experiment_type=='aptexp')
    

    %only one algorithm
    %[4, 30, 47, 53]
    %'bed stand', 'coffeemaker', 'wall planter with flowers', 'kettle on
    %table'
    colors = [1 0 0; 0 1 0; 0 0 1; .5 .5 .5; 1 1 1];
    fs1= new_fill_struct(  fix(fixlabels_id==4,:)/1000,  [0 , 20], colors(1,:) , 'bed stand');
    fs2= new_fill_struct(  fix(fixlabels_id==30,:)/1000,  [20 , 40], colors(2,:) , 'coffeemaker');
    fs3= new_fill_struct(  fix(fixlabels_id==47,:)/1000,  [40 , 60], colors(3,:) , 'wall planter');
    fs4= new_fill_struct(  fix(fixlabels_id==53,:)/1000,  [60 , 80], colors(4,:) , 'kettle');
    ps      = new_plot_struct([t/1000, vel], '-k' , [eye_data_type, ' vel']);
    
    if(method==4)
        ps2      = new_plot_struct([t/1000, avel_thresh], '-r' , ['thresh']);
    else
        ps2      = new_plot_struct([t/1000, zeros(length(t),1)+vel_thresh], '-r' , ['thresh']);
    end
    
    as      = new_axes_struct([t(1), t(500)]/1000, [0, 200]);
    ts      = new_timeplot_struct(t/1000, 5, {{ps,ps2}}, {{fs1,fs2,fs3,fs4}}, as);
    %ts      = new_timeplot_struct(t/1000, 5, {{ps}}, {{fs1,fs2,fs3,fs4}}, as);
    
    browser(ts);

else

    %three algorithms were used
    fs      = new_fill_struct(  fix_low,  [0  , 33],  [ 0.69 0.926 0.706 ] ,  'low');
    fs1     = new_fill_struct(  fix_mid,  [33  ,66 ],  [ 0 0.843 0.510  ] ,  'mid');
    fs2     = new_fill_struct(  fix_hi ,  [66  , 100],  [ 0.149 0.726 0  ] , 'high');
    ps      = new_plot_struct([t, vel], '-k' , [eye_data_type, ' vel']);
    as      = new_axes_struct([t(1), t(200)], [0, 200]);
    ts      = new_timeplot_struct(t, 2000, {{ps}}, {{fs,fs1,fs2}}, as);
    browser(ts);

    fs      = new_fill_struct(  hmm_fix,  [0  , 33],  [ 0.69 0.926 0.706 ] , 'HMM');
    fs1     = new_fill_struct(  adap_vel_fix,  [33  , 66],  [ 0 0.926 0 ] ,  'AdaptiveVelocity');
    fs2     = new_fill_struct(  vel_fix,  [66  , 100 ],  [ 0 0 0.706 ] ,  'Velocity');
    ps      = new_plot_struct([t, vel], '-k' , [eye_data_type, ' vel']);
    as      = new_axes_struct([t(1), t(200)], [0, 200]);
    ts      = new_timeplot_struct(t, 2000, {{ps}}, {{fs,fs1,fs2}}, as);
    browser(ts);

end





