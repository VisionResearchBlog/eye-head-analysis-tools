
%-----------------------------------------------
%make files into something neil can use in spss
%-----------------------------------------------  

% this is really ugly since different array variables hold
% overlapping information yet also slightly different analyses
% this needs to be cleaned up and split apart...bad bad bad


function [eye_hand_data, non_action_fix, piece1_data, piece2_data, ...
	  piece3_data, piece4_data, area9_data, area10_data, piece3_head, piece4_head, ...
	  piece3_head_lah, piece4_head_lah, piece3_head_norm, piece4_head_norm, p3_acc, p4_acc] =...
      spss(model_n_Reach_fixation_summary, mod_num, hand, fixArray, ...
	   time, reaches, handVel, head)

  global Piece1 Piece2 Piece3 Piece4

  non_action_fix = zeros(1, 20);

  Reach_list = unique(model_n_Reach_fixation_summary(:,3));

  for i = 2:size(Reach_list, 1)
    
    %ok first we need a few basic pieces of info common to all reaches
    tmp1 = find(model_n_Reach_fixation_summary(:,3) == Reach_list(i,1));
    reach_num = model_n_Reach_fixation_summary(tmp1(1,1),3); % reach#
    reach_i = model_n_Reach_fixation_summary(tmp1(1,1),4); %reach_init
    reach_f = model_n_Reach_fixation_summary(tmp1(1,1),5); %reach_fin
    reach_dur =  reach_f - reach_i;
    area_i = model_n_Reach_fixation_summary(tmp1(1,1),6); 
    area_f = model_n_Reach_fixation_summary(tmp1(1,1),7);
    saccade_i = 0;
    clear tmp1 maxVel accel meanVel lah_head_i lah_head_f lah_head_eye_T ...
	lah lah_head_list;
    
    f_dur = 0; g_dur = 0; fs_dur = 0; gs_dur = 0;
    
    %now screen for fix_type LAH
    tmp1 = find((model_n_Reach_fixation_summary(:,3) == Reach_list(i,1))&(model_n_Reach_fixation_summary(:,8) == 1));
    %do same for guiding
    tmp2 = find((model_n_Reach_fixation_summary(:,3) == Reach_list(i,1))&(model_n_Reach_fixation_summary(:,8) == 2));
    
    %test for continuity
    if (~(isempty(tmp2)))&(length(tmp2) ~= 1)
      test2 = model_n_Reach_fixation_summary(tmp2(2:end,1),10) -...
	      model_n_Reach_fixation_summary(tmp2(1:end-1,1), 10);
      if ( (sum(test2(:,1))/length(test2)) == 1 )
	guide_inter = 0;  num_inter = 0;
      else guide_inter = 1;
	num_inter = sum(test2(:,1)) - size(test2,1);
      end
    else guide_inter = 0;
      num_inter = 0;
    end
    
    %find bounds for fixation search
    if (~(isempty(tmp2)))&(size(tmp2,1) ~= 1)	
      
      f_min = min(model_n_Reach_fixation_summary(tmp2(:,1),10));
      f_max = max(model_n_Reach_fixation_summary(tmp2(:,1),10));
      
      %these bounds apply to all fixations	
      for j = f_min:f_max,
	
	%fixation time
	tmp_dur = time(fixArray(j, 2))-time(fixArray(j, 1));    
	f_dur = f_dur + tmp_dur;
	
	%saccade time
	if(j ~= 1)
	  tmp_dur = time(fixArray(j, 1))-time(fixArray(j-1, 2));   
	  fs_dur = fs_dur + tmp_dur;
	  
	  % a new array variable called non_action_fix will hold info on the
          % irrelevant (non-guiding) portions of fixations
	  if(num_inter > 0)
	    non_action_fix(i, 1 ) = mod_num;
	    non_action_fix(i, 2 ) = hand;
	    non_action_fix(i, 3 ) = reach_num;
	    non_action_fix(i, 4 ) = area_f;
	    non_action_fix(i, 5 ) = size(tmp2, 1);%number fixes
	    non_action_fix(i, 6 ) = num_inter;%num irrel_fixes
	    non_action_fix(i, j - f_min + 7 ) = fixArray(j,5);
	  end
	end
      end
      
      %these bounds apply to guiding fixations
      for k = 1:size(tmp2,1)
	
	tmp_dur =  time(fixArray(model_n_Reach_fixation_summary(tmp2(k,1), 10), 2))...
	    -time(fixArray(model_n_Reach_fixation_summary(tmp2(k,1), 10), 1));    
	g_dur = g_dur + tmp_dur;
	
	
	if(model_n_Reach_fixation_summary(tmp2(k,1), 10) ~= 1)
	  %saccade time
	  tmp_dur = time(fixArray(model_n_Reach_fixation_summary(tmp2(k,1), 10), 1))...
		    -time(fixArray(model_n_Reach_fixation_summary(tmp2(k,1), 10)-1, 2));    
	  
	  gs_dur = gs_dur + tmp_dur;
	end
      end
      
      if(f_min~=1)
	total = time(fixArray(f_max, 2))-time(fixArray(f_min-1, 2));
      else
	total = time(fixArray(f_max, 2));	
      end
    end %end moreData collection
    
    
    if ~isempty(tmp1)
      lah_i = (model_n_Reach_fixation_summary(max(tmp1), 1)); 
      
      if((model_n_Reach_fixation_summary(max(tmp1), 10) - 1)>0)
	lah_saccade_i = ...
	    time(fixArray(model_n_Reach_fixation_summary(max(tmp1), 10) -1, 2))-0.05;
      else
	lah_saccade_i = 0;
      end
      
      
      lah_f = (model_n_Reach_fixation_summary(max(tmp1), 2)); %lah look_end
      lah_dur = lah_f - lah_i;
      num_lah = size(tmp1, 1);
      T = reach_i - lah_f;
      
      if(size(tmp1,1)>1)
	%determine if the last two look aheads are 2 adjacent fixations
	if(model_n_Reach_fixation_summary(tmp1(end,1),10) - model_n_Reach_fixation_summary(tmp1(end-1,1),10) == 1)
	  pu_connect = 1;
	else
	  pu_connect = 0; 
	end
	
	plah_i = (model_n_Reach_fixation_summary(tmp1(end-1), 1)); %penultimate_init
	plah_f = (model_n_Reach_fixation_summary(tmp1(end-1), 2)); %penultimate_final
	
	plah_dur = plah_f - plah_i;   
	T2 = reach_i -plah_f; 
	
      else
	plah_i = 0; plah_f = 0; plah_dur = 0; T2 = 0; pu_connect = 0;
      end
      
    else
      %fill up variables so matlab doesn't complain
      lah_saccade_i = 0; lah_i = 0; lah_f = 0; num_lah = 0; lah_dur = 0; T=0;
      plah_i = 0; plah_f = 0; plah_dur = 0; lah_inter = 0; T2 = 0;
      pu_connect = 0;
    end
    
    
    if ~isempty(tmp2) 
      
      if(model_n_Reach_fixation_summary(min(tmp2), 10) ~= 1)
	%find initiation time of saccade for first guiding fix
	saccade_i = time(fixArray(model_n_Reach_fixation_summary(min(tmp2), 10) -1, 2))-0.05;      
      else
	saccade_i = 0; %empty so we can examining first fixation
      end
      
      guide_i = (model_n_Reach_fixation_summary(min(tmp2), 1)); %guiding_init
      guide_f = (model_n_Reach_fixation_summary(max(tmp2), 2)); %guiding_end
      
      guide_dur = guide_f - guide_i;
      num_guiding = size(tmp2, 1);                                                     
      
    else 
      %fill up variables so matlab doesn't complain
      guide_i = 0; guide_f = 0; num_guiding = 0; guide_dur = 0; ...
		guide_inter = 0;
    end
    

    
%-------------------------------------------------------------------------
    %find accuracy of fixations 
    if((area_f == Piece3)&(num_guiding >0))      
   
      fixNum = model_n_Reach_fixation_summary(min(tmp2),10);
      fix_idx = fixNum - 1; guide_log = [];
      fixArea = fixArray(fix_idx, 5);
      p3_vec = [50 -6.5];
      %coordinates of first guiding fix
      coord3 = fixArray(fixNum,3:4)/10;
      norm_coord3 = (coord3 - p3_vec);
      p3_dist = sqrt( (coord3(1,1) - p3_vec(1,1))^2 + ...
		      (coord3(1,2) - p3_vec(1,2))^2 );
     
      while(fixArea ~= 11)
	%step back in time examining fixations prior to the first guiding	
        guide_log(end+1,:) = fixArray(fix_idx,3:4)/10;
	if(fix_idx-1>=1)
	fix_idx = fix_idx - 1;	fixArea = fixArray(fix_idx, 5);
	else 
	  break
	end
      end
      
     
      if (~exist('guide_log', 'var')||isempty(guide_log))
	guide_log =  norm_coord3; mean_inter = [0 0]; mean_inter_dist = 0; 
	numB = 0; first_fix = [0 0]; first_fix_dist = 0;
      else 
	numB = size(guide_log,1);
	mean_inter = mean(guide_log,1);
	mean_inter_dist = sqrt( (mean_inter(1,1) - p3_vec(1,1))^2 + ...
			        (mean_inter(1,2) - p3_vec(1,2))^2 );	
	first_fix_dist = sqrt( (guide_log(end,1) - p3_vec(1,1))^2 + ...
			   (guide_log(end,2) - p3_vec(1,2))^2 );
      
	first_fix = guide_log(end,:);
      end
      
       
    elseif((area_f == Piece4)&(num_guiding >0))
      fixNum = model_n_Reach_fixation_summary(min(tmp2),10);
      fix_idx = fixNum - 1; guide_log = [];
      fixArea = fixArray(fix_idx, 5);  
      p4_vec = [-50 -6.5];
      %coordinates of first guiding fix
      coord4 = fixArray(fixNum,3:4)/10;
      norm_coord4 = (coord4 - p4_vec);
      p4_dist = sqrt( (coord4(1,1) - p4_vec(1,1))^2 + ...
		      (coord4(1,2) - p4_vec(1,2))^2 );
      
      while(fixArea ~= 11)
	%step back in time examining fixations prior to the first guiding	
        guide_log(end+1,:) = fixArray(fix_idx,3:4)/10; 
	if(fix_idx-1>=1)
	  fix_idx = fix_idx - 1;	fixArea = fixArray(fix_idx, 5);
	else 
	  break
	end
      end
      
     
      if (~exist('guide_log', 'var')||isempty(guide_log))
	guide_log =  norm_coord4; mean_inter = [0 0]; mean_inter_dist = 0;
	numB = 0; first_fix = [0 0]; first_fix_dist = 0;
	
      else
	numB = size(guide_log,1);
	mean_inter = mean(guide_log,1);
	mean_inter_dist = sqrt( (guide_log(1,1) - p4_vec(1,1))^2 + ...
			        (guide_log(1,2) - p4_vec(1,2))^2 );
	first_fix_dist = sqrt( (guide_log(end,1) - p4_vec(1,1))^2 + ...
			       (guide_log(end,2) - p4_vec(1,2))^2 );
	first_fix = guide_log(end,:);
      end 
    end

    
    %calc eye-hand latencies
    D = reach_i - saccade_i;
    D2 = reach_f - guide_f;
    f_tot = f_dur+fs_dur;
    o_dur = f_dur-g_dur;
    os_dur = fs_dur-gs_dur;
    
    %get rid of zero entries
    if(g_dur == 0)
      g_dur = guide_f - guide_i;
    end
    
    if(gs_dur == 0)
      gs_dur = guide_i - saccade_i;
    end
    
    
    %--------------------------------------------
    %in this section several basic reach 
    %metrics will be calculated
    
    %find average velocity
    meanVel = sum(handVel(reaches(reach_num, 1):reaches(reach_num, 2)))/...
	      (reaches(reach_num, 2) - reaches(reach_num, 1));
    
    %find peak velocity
    maxVel = max(handVel(reaches(reach_num, 1):...
			 reaches(reach_num, 2)));
    
    
    for idx = reaches(reach_num, 1):(reaches(reach_num, 2)-1)
      accel(idx - reaches(reach_num, 1) + 1 ,1) =  (handVel(idx+1) - handVel(idx))/(time(idx+1)-time(idx));
    end

    
    accel = smooth(accel, 5);
    
    %convert from mm to cm
    maxAccel = max(abs(accel))/10;
    maxVel = maxVel/10;
    meanVel = meanVel/10;
    
    if(num_lah > 0) lah = 1;
    else lah = 0;
    end
    
    if(num_guiding > 0) guide = 1;
    else guide = 0;
    end
    
    %---------end reach analysis----------------
    
    %Calculate head-eye-hand latencies here: Given a reach now 
    %find the head movement temporally associated with that reach    
    if((area_f == 5)|(area_f == 8))  
      if(area_f == 5)
	if(~exist('head3Mov', 'var'))
	  head3Mov = [0 0 0];
	end
	condR = (head(:,4) == 2); %2 means rightward
	headR_tmp = head(find(condR), :);
	[Y, I] = min(abs(head(find(condR), 1) - reach_i));
	head3Mov(end+1, :) = [headR_tmp(I, 1:2) area_f];
	head_i = headR_tmp(I, 1);  head_f = headR_tmp(I, 2);	
	PeakVel_Reach = headR_tmp(I, 9);  
	Reach_Hdg = headR_tmp(I, 8); 
	Reach_Mag = headR_tmp(I, 8) - headR_tmp(I, 7);	
      elseif(area_f == 8)
	if(~exist('head4Mov', 'var'))
	  head4Mov = [0 0 0];
	end
	condL = (head(:,4) == 3); %3 means leftward
	headL_tmp = head(find(condL), :);
	[Y, I] = min(abs(head(find(condL), 1) - reach_i));  
	head4Mov(end+1, :) = [headL_tmp(I, 1:2) area_f];      
	head_i = headL_tmp(I, 1);  head_f = headL_tmp(I, 2);	
	PeakVel_Reach = headL_tmp(I, 9);  
	Reach_Hdg = headL_tmp(I, 8); 
	Reach_Mag = headL_tmp(I, 8) - headL_tmp(I, 7);
      end
      
      %calculate the important deltas
      
      %hand-eye
      hand_eye_T = reach_i - saccade_i;
      %hand-head
      hand_head_T = reach_i - head_i;
      %head-eye    
      head_eye_T = head_i - saccade_i;    
      
      %find the head movement associated with LAH (if exists)
      if((lah)&(area_f == 5))
	condR = (head(:,4) == 2);
	[Y, I] = min(abs(head(find(condR), 1) - lah_i));    
	lah_head_i = headR_tmp(I, 1);  lah_head_f = headR_tmp(I, 2);   
	lah_head_eye_T = lah_saccade_i - lah_head_i;
	lah_head_list = [headR_tmp(I, 1:2) lah_saccade_i lah_f lah_head_eye_T];
	PeakVel_LAH = headR_tmp(I, 9);  
	LAH_Hdg = headR_tmp(I, 8); 
	LAH_Mag = headR_tmp(I, 8) - headR_tmp(I, 7);
      elseif((lah)&(area_f == 8))
	condL = (head(:,4) == 3);
	[Y, I] = min(abs(head(find(condL), 1) - lah_i));     
	lah_head_i = headL_tmp(I, 1);  lah_head_f = headL_tmp(I, 2);   
	lah_head_eye_T = lah_saccade_i - lah_head_i;
	lah_head_list = [headL_tmp(I, 1:2) lah_saccade_i lah_f lah_head_eye_T];
	PeakVel_LAH = headL_tmp(I, 9);  
	LAH_Hdg = headL_tmp(I, 8); 
	LAH_Mag = headL_tmp(I, 8) - headL_tmp(I, 7);
      else
	lah_head_i = 0; lah_head_f = 0; lah_head_eye_T = 0;
      end
      
    end 


    if(~exist('lah_head_list', 'var'))
      lah_head_list = [0 0 0 0 0];
    end     
    %-End-Head-Analysis-----------------------------------------
    
    %is this necessary maybe just pass an empty variable?
    if ~exist('piece1_data', 'var')
      %piece1_data = [];
      piece1_data = [mod_num hand 0 0 0 0 0 0 0];
    end
    if ~exist('piece2_data', 'var')
      %piece2_data = [];
      piece2_data = [mod_num hand 0 0 0 0 0 0 0]; 
    end
    if ~exist('piece3_data', 'var')
      %piece3_data = [];
      piece3_data = [mod_num hand 0 0 0 0 0 0 0];
    end
    if ~exist('piece4_data', 'var')
      %piece4_data = [];
      piece4_data = [mod_num hand 0 0 0 0 0 0 0];
    end
    if ~exist('area9_data', 'var')
      %area9_data = [];
      area9_data = [mod_num hand 0 0 0 0 0 0 0];
    end
    if ~exist('area10_data', 'var')
      %area10_data = [];
      area10_data = [mod_num hand 0 0 0 0 0 0 0];
    end
    if ~exist('piece3_head_lah', 'var')
      piece3_head_lah = [0 0 0 0 0 0 0 0 0 0];
    end
    if ~exist('piece4_head_lah', 'var')
      piece4_head_lah = [0 0 0 0 0 0 0 0 0 0];
    end
    if ~exist('piece3_head_norm', 'var')
      piece3_head_norm = zeros(1,6);
    end
    if ~exist('piece4_head_norm', 'var')
      piece4_head_norm = zeros(1,6);
    end
    
    
    
    
    %discerning the ultimate and the penultimate 
    if(i == 2)
      eye_hand_data = [mod_num hand area_i area_f reach_num reach_i reach_f reach_dur...
		       num_guiding saccade_i guide_i guide_f num_inter g_dur gs_dur o_dur os_dur D D2 num_lah...
		       lah_i lah_f lah_dur T plah_i plah_f plah_dur T2 pu_connect];  
      
      
      %initialize emptiness
      piece3_head = zeros(1,18); p3_acc = [];
      piece4_head = zeros(1,18); p4_acc = [];
      
      %to add to the piece_data we need to qualify:
      if( (T<= 10) & ((reach_f - saccade_i)>0) & (area_i == 11) & (gs_dur <= 1))
	
	switch area_f
	  
	 case Piece1
	  piece1_data = [mod_num hand lah guide reach_dur T...
			 maxVel meanVel maxAccel];
	  
	 case Piece2
	  piece2_data = [mod_num hand lah guide reach_dur T...
			 maxVel meanVel maxAccel];
	  
	 case Piece3  
	  piece3_data = [mod_num hand lah guide reach_dur T...
			 maxVel meanVel maxAccel];
	  
	  piece3_head = [mod_num hand reach_i reach_f lah T saccade_i ...
			 guide_f head_i head_f hand_eye_T hand_head_T ...
			 head_eye_T lah_head_list];
	  
	 case Piece4  
	  piece4_data = [mod_num hand lah guide reach_dur T...
			 maxVel meanVel maxAccel];		     
	  
	  piece4_head = [mod_num hand reach_i reach_f lah T saccade_i ...
			 guide_f head_i head_f hand_eye_T hand_head_T ...
			 head_eye_T lah_head_list];
	  
	 case 9
	  area9_data = [mod_num hand lah guide reach_dur T...
			maxVel meanVel maxAccel];
	  
	 case 10
	  area10_data = [mod_num hand lah guide reach_dur T...
			 maxVel meanVel maxAccel];	  
	end      
      end
      
      
    elseif(i > 2)
      eye_hand_data(end+1,:) = [mod_num hand area_i area_f reach_num reach_i reach_f reach_dur...
		    num_guiding saccade_i guide_i guide_f num_inter g_dur gs_dur o_dur os_dur... 
		    D D2 num_lah lah_i lah_f lah_dur T plah_i plah_f plah_dur T2 pu_connect];

      %to add to the piece_data we ne to qualify:
      if( (T<= 10) & ((reach_f - saccade_i)>0) & (area_i == 11) & (gs_dur <= 1))
	
	switch area_f
	  
	 case Piece1
	  piece1_data(end+1, :) = [mod_num hand lah guide reach_dur T...
		    maxVel meanVel maxAccel];
	  
	 case Piece2
	  piece2_data(end+1, :) = [mod_num hand lah guide reach_dur T...
		    maxVel meanVel maxAccel];
	  
	 case Piece3 
	  
	  piece3_data(end+1, :) = [mod_num hand lah guide reach_dur T...
		    maxVel meanVel maxAccel];
	  piece3_head(end+1, :) = [mod_num hand reach_i reach_f lah T saccade_i ...
		    guide_f head_i head_f hand_eye_T hand_head_T head_eye_T lah_head_list];

          if(lah)
	    piece3_head_lah(end+1,:) = [mod_num 3 hand T PeakVel_LAH PeakVel_Reach LAH_Hdg ...
		    Reach_Hdg LAH_Mag Reach_Mag];                                        
	    
          elseif(~lah)    
	    piece3_head_norm(end+1,:) = [mod_num 3 hand PeakVel_Reach...
		    Reach_Hdg Reach_Mag];
	    
	  end
	  
	  if(num_guiding>0)  	    
	    
	    p3_acc(end+1, :) =  [mod_num 3 hand reach_i reach_num lah first_fix first_fix_dist ...
		    numB mean_inter mean_inter_dist coord3 p3_dist];
	    
	  end
	  
	 case Piece4
	  
	  piece4_data(end+1, :) = [mod_num hand lah guide reach_dur T...
		    maxVel meanVel maxAccel];
	  piece4_head(end+1, :) = [mod_num hand reach_i reach_f lah T saccade_i ...
		    guide_f head_i head_f hand_eye_T hand_head_T head_eye_T lah_head_list];
	  
          if(lah)
	    piece4_head_lah(end+1,:) = [mod_num 4 hand T PeakVel_LAH PeakVel_Reach LAH_Hdg ...
		    Reach_Hdg LAH_Mag Reach_Mag];

	  elseif(~lah)    
	    piece4_head_norm (end+1,:)= [mod_num 4 hand PeakVel_Reach...
		    Reach_Hdg Reach_Mag];
	  end       
	  
	  if(num_guiding>0)      
	    p4_acc(end+1, :) =  [mod_num 4 hand reach_i reach_num lah first_fix first_fix_dist...
		    numB mean_inter mean_inter_dist coord4 p4_dist];
	 
	  end
	 case 9
	  area9_data(end+1, :) = [mod_num hand lah guide reach_dur T...
		    maxVel meanVel maxAccel];
	  
	 case 10
	  area10_data(end+1, :) = [mod_num hand lah guide reach_dur T...
		    maxVel meanVel maxAccel];	  
	  
	  
	end
      end
    end
  end %for i
  

  if ~exist('eye_hand_data', 'var')
    eye_hand_data = [mod_num hand 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
		     0 0 0 0 0 0];
  end
  
  %cmon who programmed this?  
  
  if ~exist('piece4_head_lah', 'var')
    piece4_head_lah = [0 0 0 0 0 0 0 0 0 0];
  end  
  
  if ~exist('piece3_head_lah', 'var')
    piece3_head_lah = [0 0 0 0 0 0 0 0 0 0];
  end
  %is this necessary maybe just pass an empty variable?
  if ~exist('piece1_data', 'var')
    %piece1_data = [];
    piece1_data = [mod_num hand 0 0 0 0 0 0 0];
  end
  if ~exist('piece2_data', 'var')
    %piece2_data = [];
    piece2_data = [mod_num hand 0 0 0 0 0 0 0]; 
  end
  if ~exist('piece3_data', 'var')
    %piece3_data = [];
    piece3_data = [mod_num hand 0 0 0 0 0 0 0];
  end
  if ~exist('piece4_data', 'var')
    %piece4_data = [];
    piece4_data = [mod_num hand 0 0 0 0 0 0 0];
  end
  if ~exist('area9_data', 'var')
    %area9_data = [];
    area9_data = [mod_num hand 0 0 0 0 0 0 0];
  end
  if ~exist('area10_data', 'var')
    %area10_data = [];
    area10_data = [mod_num hand 0 0 0 0 0 0 0];
  end
  if ~exist('piece3_head_lah', 'var')
    piece3_head_lah = [0 0 0 0 0 0 0 0 0 0];
  end
  if ~exist('piece4_head_lah', 'var')
    piece4_head_lah = [0 0 0 0 0 0 0 0 0 0];
  end
  if ~exist('piece3_head', 'var')  
    piece3_head = zeros(1,18); 
  end
  if ~exist('piece4_head', 'var')
    piece4_head = zeros(1,18);
  end
  if ~exist('piece3_head_norm', 'var')
    piece3_head_norm = zeros(1,6);
  end
  if ~exist('piece4_head_norm', 'var')
    piece4_head_norm = zeros(1,6);
  end

  if ~exist('p3_acc','var')
    p3_acc = [];
  end
  
  if ~exist('p4_acc','var')
    p4_acc = [];
  end
  
  %keyboard
  
  
  return












  