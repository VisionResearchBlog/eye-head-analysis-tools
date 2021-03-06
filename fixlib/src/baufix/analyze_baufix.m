%  ANALYZE_BAUFIX.M -
%
%  Usage: 
%
%     analyze_baufix(dataFile, fixfile, binSizeX, binSizeY, sample_num)
%
%  This .m file has two main purposes: First it provides a simple
%  visualization for fixation, reach and head data. Second, it
%  processes the baufix data so that fixations can be identified and
%  labeled according to Neil Mennie's criteria specifying three
%  general types: Look-Ahead, Guiding/Grasping/Removal, and Look-Back.

function h = analyze_baufix(dataFile, fixfile, sample_num) 
%function [ AllFix, FixTypes] = analyze_baufix(dataFile, fixfile, sample_num) 


close all;

%define constants with global variables? what is like #define?  
  global Piece1 Piece2 Piece3 Piece4 EmptyDist1 EmptyDist2 ...
      FullDist1 FullDist2;
  
  setup = 2; % or 1
  debug = 1; % Use 1 to display graphs and data output
  
  if(setup == 1)
    %-----------------------------------%  
    %      Constants for SETUP 1
    %-----------------------------------%
    Piece1 = 3;
    Piece2 = 2;
    Piece3 = 8;
    Piece4 = 1;
    EmptyDist1 = 4;
    EmptyDist2 = 6;
    FullDist1 = 5;
    FullDist2 = 7;
    %-----------------------------------%


  elseif(setup == 2)
    %-----------------------------------%
    %      Constants for SETUP 2
    %-----------------------------------%
    Piece1 = 2;
    Piece2 = 3;
    Piece3 = 5;
    Piece4 = 8;
    EmptyDist1 = 4;
    EmptyDist2 = 7;
    FullDist1 = 1;
    FullDist2 = 6; 
    %-----------------------------------%  
  end

  
  load(dataFile); load(fixfile);
  
  clear fixations;
  
  fixations = fix_mid_frames(:,1:2);

  
  % Set up fixation and reach data  
  rReaches2 = [rReaches rReachLabels];
  lReaches2 = [lReaches lReachLabels];
  TC = sgitime2TC(time, local2TC_slope, local2TC_offset);
  head = [time fastrak];
  time2= [time TC];
  

  %Manual labeling of scene plane bins
  
  [xy_average bin_count] = label_bins(binEyeHV, fixations, 320, 180);

  findProbs(xy_average(:,3)+1)
  return
  
  %abrupt end just to get 
  
  %setup fixation list now that we have the average xy position  
  A2 = [fixations xy_average ];
  
  %arrays for plotting
  lReachArray = [time(lReaches)-0.006  lReachLabels ];
  rReachArray = [time(rReaches)-0.006  rReachLabels ];
  fixArray = [time(fixations)-0.05 xy_average ];

  
  
  
% keyboard
  
  %Indivdidual Model Analysis:
  %Segment data file into individual models by examining hand velocity
  %processed with gaussian averaging
  
  smooth_rHandVel = smooth(rHandVel, 5);
  smooth_lHandVel = smooth(lHandVel, 5);
  
  cond1 = ((smooth_rHandVel(:,1)<25)&(smooth_lHandVel(:,1)<25));
  
  reach_size = size(rHandVel, 1);
  index = 0;
  j = 1;
  
  
  %  for i = 1:reach_size,
  for i = 2000:reach_size, %ugly fix for incorrect segmentation at beginning
    if cond1(i,1) == 0
      index = 0; 
    elseif cond1(i,1) == 1
      index = index + 1;
    end
    
    if ((index == sample_num)&(j==1))
      model(j) = i;
      j = j + 1;
      index = 0;
      
      %my fix to stop segments too close together 
    elseif ((index == sample_num)&(j>1)&...
	    ((i - model(j-1))>1500))
      model(j) = i;
      j = j + 1;
      index = 0;  
      
    elseif index > sample_num
      index = index + 1;
    end   
  end


%  keyboard
  
  %now we have markers for the inter-trial pauses
  %now find the beginning and end of the pause
  
  %Model1 always begins with first data sample
  segment(1,1) = 1;
  
  %keyboard
 
  for n = 1:4
    
    for i = model(n):reach_size
      if (cond1(i,1) == 0)
	segment(n+1,1) = i;
	break 
      end
    end
    
    segment(n,2) = model(n)-sample_num;
  end

  %Model 5 ends with the end of file:
  segment(5,2) = reach_size;

  
  %the pause time is useful but now we have to check the for the last
  %reach to area 12 to find the true end of trial:

  

  for i = 1:5,

    tmp1 = [abs(rReaches2(:,1:2) - segment(i,2)) rReaches2(:,3:4) (1:length(rReaches2))'];
    tmp2 = [abs(lReaches2(:,1:2) - segment(i,2)) lReaches2(:,3:4) (1:length(lReaches2))'];
    
    
    
    condA = find(tmp1(:,4) == 12);
    condB = find(tmp2(:,4) == 12);
    
    tmp1 = tmp1(condA, :);
    tmp2 = tmp2(condB, :);
    
    [val1, row1] = min(tmp1(:,2));
    [val2, row2] = min(tmp2(:,2));
    
    
    if (val1 > 1000) % sometimes reach to 12 isn't found
      segment2(i,2) = (segment(i,2));
    else
      segment2(i,2) = (rReaches2(tmp1(row1, 5), 2));
    end
    
  end


  %ok now we have the true end when the hand has finished reaching to 12
  segment3 = [ 1,                segment2(1,2);...
	       segment2(1,2)+1,  segment2(2,2);...
	       segment2(2,2)+1,  segment2(3,2);...
	       segment2(3,2)+1,  segment2(4,2);...
	       segment2(4,2)+1,  segment2(5,2)];
  

  %The variable segment now holds begin and end times for all 5 models
  %Now we can segment reaches and fixations for each model

  model_1_fixations = partition(A2, 1, segment3);
  model_1_rReaches  = partition(rReaches2, 1, segment3);
  model_1_lReaches  = partition(lReaches2, 1, segment3);

  model_2_fixations = partition(A2, 2, segment3);
  model_2_rReaches  = partition(rReaches2, 2, segment3);
  model_2_lReaches  = partition(lReaches2, 2, segment3);

  model_3_fixations = partition(A2, 3, segment3);
  model_3_rReaches  = partition(rReaches2, 3, segment3);
  model_3_lReaches  = partition(lReaches2, 3, segment3);

  model_4_fixations = partition(A2, 4, segment3);
  model_4_rReaches  = partition(rReaches2, 4, segment3);
  model_4_lReaches  = partition(lReaches2, 4, segment3);

  model_5_fixations = partition(A2, 5, segment3);
  model_5_rReaches  = partition(rReaches2, 5, segment3);
  model_5_lReaches  = partition(lReaches2, 5, segment3);



  %process each model and hand for fixation/reach associations
  [model_1_rReach_fixation_associations, model_1_rReach_fixation_summary] ...
      = fixation_segment(model_1_rReaches, model_1_lReaches, ...
			 model_1_fixations, time, 'right');
  [model_1_lReach_fixation_associations, model_1_lReach_fixation_summary] ...
      = fixation_segment(model_1_rReaches, model_1_lReaches, ...
			 model_1_fixations, time, 'left');
  [model_2_rReach_fixation_associations, model_2_rReach_fixation_summary] ...
      = fixation_segment(model_2_rReaches, model_2_lReaches, ...
			 model_2_fixations, time, 'right');
  [model_2_lReach_fixation_associations, model_2_lReach_fixation_summary] ...
      = fixation_segment(model_2_rReaches, model_2_lReaches, ...
			 model_2_fixations, time, 'left');
  [model_3_rReach_fixation_associations, model_3_rReach_fixation_summary] ...
      = fixation_segment(model_3_rReaches, model_3_lReaches, ...
			 model_3_fixations, time, 'right');
  [model_3_lReach_fixation_associations, model_3_lReach_fixation_summary] ...
      = fixation_segment(model_3_rReaches, model_3_lReaches, ...
			 model_3_fixations, time, 'left');
  [model_4_rReach_fixation_associations, model_4_rReach_fixation_summary] ...
      = fixation_segment(model_4_rReaches, model_4_lReaches, ...
			 model_4_fixations, time, 'right');
  [model_4_lReach_fixation_associations, model_4_lReach_fixation_summary] ...
      = fixation_segment(model_4_rReaches, model_4_lReaches, ...
			 model_4_fixations, time, 'left');
  [model_5_rReach_fixation_associations, model_5_rReach_fixation_summary] ...
      = fixation_segment(model_5_rReaches, model_5_lReaches, ...
			 model_5_fixations, time, 'right');
  [model_5_lReach_fixation_associations, model_5_lReach_fixation_summary] ...
      = fixation_segment(model_5_rReaches, model_5_lReaches, ...
			 model_5_fixations, time, 'left');
  
  
  model_1_rHand_result = [model_1_rReaches model_1_rReach_fixation_associations ...
		    ((model_1_rReach_fixation_associations(:,2)) + (model_1_rReach_fixation_associations(:,3)) ...
		     + (model_1_rReach_fixation_associations(:,4)))];
  
  model_1_lHand_result = [model_1_lReaches model_1_lReach_fixation_associations ...
		    ((model_1_lReach_fixation_associations(:,2)) + (model_1_lReach_fixation_associations(:,3)) ...
		     + (model_1_lReach_fixation_associations(:,4)))];
  
  model_2_rHand_result = [model_2_rReaches model_2_rReach_fixation_associations ...
		    ((model_2_rReach_fixation_associations(:,2)) + (model_2_rReach_fixation_associations(:,3)) ...
		     + (model_2_rReach_fixation_associations(:,4)))];

  model_2_lHand_result = [model_2_lReaches model_2_lReach_fixation_associations ...
		    ((model_2_lReach_fixation_associations(:,2)) + (model_2_lReach_fixation_associations(:,3)) ...
		     + (model_2_lReach_fixation_associations(:,4)))];
  
  model_3_rHand_result = [model_3_rReaches model_3_rReach_fixation_associations ...
		    ((model_3_rReach_fixation_associations(:,2)) + (model_3_rReach_fixation_associations(:,3)) ...
		     + (model_3_rReach_fixation_associations(:,4)))];

  model_3_lHand_result = [model_3_lReaches model_3_lReach_fixation_associations ...
		    ((model_3_lReach_fixation_associations(:,2)) + (model_3_lReach_fixation_associations(:,3)) ...
		     + (model_3_lReach_fixation_associations(:,4)))];
  
  model_4_rHand_result = [model_4_rReaches model_4_rReach_fixation_associations ...
		    ((model_4_rReach_fixation_associations(:,2)) + (model_4_rReach_fixation_associations(:,3)) ...
		     + (model_4_rReach_fixation_associations(:,4)))];

  model_4_lHand_result = [model_4_lReaches model_4_lReach_fixation_associations ...
		    ((model_4_lReach_fixation_associations(:,2)) + (model_4_lReach_fixation_associations(:,3)) ...
		     + (model_4_lReach_fixation_associations(:,4)))];

  model_5_rHand_result = [model_5_rReaches model_5_rReach_fixation_associations ...
		    ((model_5_rReach_fixation_associations(:,2)) + (model_5_rReach_fixation_associations(:,3)) ...
		     + (model_5_rReach_fixation_associations(:,4)))];
  
  model_5_lHand_result = [model_5_lReaches model_5_lReach_fixation_associations ...
		    ((model_5_lReach_fixation_associations(:,2)) + (model_5_lReach_fixation_associations(:,3)) ...
		     + (model_5_lReach_fixation_associations(:,4)))];



  %Display total fixations for all trials via two counting methods
  single_model(1,:) = count(model_1_fixations, model_1_lHand_result, model_1_rHand_result);
  single_model(2,:) = count(model_2_fixations, model_2_lHand_result, model_2_rHand_result);
  single_model(3,:) = count(model_3_fixations, model_3_lHand_result, model_3_rHand_result);
  single_model(4,:) = count(model_4_fixations, model_4_lHand_result, model_4_rHand_result);
  single_model(5,:) = count(model_5_fixations, model_5_lHand_result, model_5_rHand_result);

  
  model_bins(1:10, 1) = [82; 76; 82; 76; 82; 76; 82; 76; 82; 76;];
  model_bins(1,2:19) = bin_fix_count(model_1_rReach_fixation_summary);
  model_bins(2,2:19) = bin_fix_count(model_1_lReach_fixation_summary);
  model_bins(3,2:19) = bin_fix_count(model_2_rReach_fixation_summary);
  model_bins(4,2:19) = bin_fix_count(model_2_lReach_fixation_summary); 
  model_bins(5,2:19) = bin_fix_count(model_3_rReach_fixation_summary);
  model_bins(6,2:19) = bin_fix_count(model_3_lReach_fixation_summary);  
  model_bins(7,2:19) = bin_fix_count(model_4_rReach_fixation_summary);
  model_bins(8,2:19) = bin_fix_count(model_4_lReach_fixation_summary);
  model_bins(9,2:19) = bin_fix_count(model_5_rReach_fixation_summary);
  model_bins(10,2:19)= bin_fix_count(model_5_lReach_fixation_summary);
 
  keyboard

  %analyze head now
  %might need to break out but for now we plot head stuff here
  % in wrong place
  [head_seg, head_vel, head_mod_segment] = head_analysis(fastrak(:,6), time, segment3); 
 
 
  
  %UGLY!! - this should be made into a simpler function
  [eye_hand_data1, non_action_fix1, piece1_data1, piece2_data1, piece3_data1,...
   piece4_data1, area9_data1, area10_data1, head3Mov1, head4Mov1, head3lah1,...
   head4lah1, head3norm1, head4norm1, p3_acc1, p4_acc1] =...
      spss(model_1_rReach_fixation_summary, 1, 82, model_1_fixations, ...
	   time, model_1_rReaches, rHandVel, head_seg);
  
   [eye_hand_data2, non_action_fix2, piece1_data2, piece2_data2, piece3_data2,...
    piece4_data2, area9_data2, area10_data2, head3Mov2, head4Mov2, head3lah2,...
    head4lah2, head3norm2, head4norm2, p3_acc2, p4_acc2] =...
      spss(model_1_lReach_fixation_summary, 1, 76, model_1_fixations, ...
	   time, model_1_lReaches, lHandVel, head_seg);
  
  [eye_hand_data3, non_action_fix3, piece1_data3, piece2_data3, piece3_data3,...
   piece4_data3, area9_data3, area10_data3, head3Mov3, head4Mov3, head3lah3,...
   head4lah3, head3norm3, head4norm3, p3_acc3, p4_acc3] =...
      spss(model_2_rReach_fixation_summary, 2, 82, model_2_fixations, ...
	   time, model_2_rReaches, rHandVel, head_seg);

  [eye_hand_data4, non_action_fix4, piece1_data4, piece2_data4, piece3_data4,...
   piece4_data4, area9_data4, area10_data4, head3Mov4, head4Mov4, head3lah4,...
   head4lah4, head3norm4, head4norm4, p3_acc4, p4_acc4] =...
      spss(model_2_lReach_fixation_summary, 2, 76, model_2_fixations, ...
	   time, model_2_lReaches,lHandVel, head_seg);
  
  [eye_hand_data5, non_action_fix5, piece1_data5, piece2_data5, piece3_data5,...
   piece4_data5, area9_data5, area10_data5, head3Mov5, head4Mov5, head3lah5,...
   head4lah5, head3norm5, head4norm5, p3_acc5, p4_acc5] =...
      spss(model_3_rReach_fixation_summary, 3, 82, model_3_fixations, ...
	   time, model_3_rReaches, rHandVel, head_seg);  
  
  [eye_hand_data6, non_action_fix6, piece1_data6, piece2_data6, piece3_data6,...
   piece4_data6, area9_data6, area10_data6, head3Mov6, head4Mov6, head3lah6,...
   head4lah6, head3norm6, head4norm6, p3_acc6, p4_acc6] =...
      spss(model_3_lReach_fixation_summary, 3, 76, model_3_fixations, ...
	   time, model_3_lReaches, lHandVel, head_seg);
  
  [eye_hand_data7, non_action_fix7, piece1_data7, piece2_data7, piece3_data7,...
   piece4_data7, area9_data7, area10_data7 head3Mov7, head4Mov7, head3lah7,...
   head4lah7, head3norm7, head4norm7, p3_acc7, p4_acc7] =...
      spss(model_4_rReach_fixation_summary, 4, 82, model_4_fixations, ...
	   time, model_4_rReaches, rHandVel, head_seg);
  
  [eye_hand_data8, non_action_fix8, piece1_data8, piece2_data8, piece3_data8,...
   piece4_data8, area9_data8, area10_data8 head3Mov8, head4Mov8, head3lah8,...
   head4lah8, head3norm8, head4norm8, p3_acc8, p4_acc8] =...
      spss(model_4_lReach_fixation_summary, 4, 76, model_4_fixations, ...
	   time, model_4_lReaches, lHandVel, head_seg);
  
  [eye_hand_data9, non_action_fix9, piece1_data9, piece2_data9, piece3_data9,...
   piece4_data9, area9_data9, area10_data9 head3Mov9, head4Mov9, head3lah9,...
   head4lah9, head3norm9, head4norm9, p3_acc9, p4_acc9] =...
      spss(model_5_rReach_fixation_summary, 5, 82, model_5_fixations, ...
	   time, model_5_rReaches, rHandVel, head_seg);
  
  [eye_hand_data10, non_action_fix10, piece1_data10, piece2_data10, piece3_data10,...
   piece4_data10, area9_data10, area10_data10 head3Mov10, head4Mov10, head3lah10,...
   head4lah10, head3norm10, head4norm10, p3_acc10, p4_acc10] =...
      spss(model_5_lReach_fixation_summary, 5, 76, model_5_fixations, ...
	   time, model_5_lReaches, lHandVel, head_seg);
    
  eye_hand_data = [eye_hand_data1; eye_hand_data2; eye_hand_data3; ...
		   eye_hand_data4; eye_hand_data5; eye_hand_data6; ...
		   eye_hand_data7; eye_hand_data8; eye_hand_data9; eye_hand_data10; ];
  
  non_action_fix = [non_action_fix1; non_action_fix2; non_action_fix3; non_action_fix4; non_action_fix5;...
		    non_action_fix6; non_action_fix7; non_action_fix8; non_action_fix9; non_action_fix10;];
  
  non_action_fix = non_action_fix(find(non_action_fix(:,1)), :);
  
  
  piece1_data = [piece1_data1; piece1_data2; piece1_data3; piece1_data4; ...
		 piece1_data5; piece1_data6; piece1_data7; piece1_data8; ...
		 piece1_data9; piece1_data10;];
  
  piece2_data = [piece2_data1; piece2_data2; piece2_data3; piece2_data4; ...
		 piece2_data5; piece2_data6; piece2_data7; piece2_data8; ...
		 piece2_data9; piece2_data10;];
  
  piece3_data = [piece3_data1; piece3_data2; piece3_data3; piece3_data4; ...
		 piece3_data5; piece3_data6; piece3_data7; piece3_data8; ...
		 piece3_data9; piece3_data10;];
  
  piece4_data = [piece4_data1; piece4_data2; piece4_data3; piece4_data4; ...
		 piece4_data5; piece4_data6; piece4_data7; piece4_data8; ...
		 piece4_data9; piece4_data10;];
  
  
  area9_data = [area9_data1; area9_data2; area9_data3; area9_data4; ...
		area9_data5;  area9_data6;  area9_data7;  area9_data8; ...
		area9_data9;  area9_data10;];
  
  area10_data = [area10_data1; area10_data2; area10_data3; area10_data4; ...
		 area10_data5;  area10_data6;  area10_data7;  area10_data8; ...
		 area10_data9;  area10_data10;];
  
  head4Mov = [head4Mov1; head4Mov2; head4Mov3; head4Mov4; head4Mov5; ...
	      head4Mov6; head4Mov7; head4Mov8; head4Mov9; head4Mov10;]; 
  
  head3Mov = [head3Mov1; head3Mov2; head3Mov3; head3Mov4; head3Mov5; ...
	      head3Mov6; head3Mov7; head3Mov8; head3Mov9; head3Mov10;];

 
 head_lah = [head3lah1; head4lah1; head3lah2; head4lah2; head3lah3; ...
             head4lah3; head3lah4; head4lah4; head3lah5; head4lah5; ...
             head3lah6; head4lah6; head3lah7; head4lah7; head3lah8; ...
             head4lah8; head3lah9; head4lah9; head3lah10; head4lah10]
     
 head_norm3 = [head3norm1;  head3norm2; head3norm3; head3norm4;  head3norm5; ...
               head3norm6;  head3norm7; head3norm8; head3norm9;  head3norm10;]
     
 head_norm4 = [head4norm1;  head4norm2; head4norm3; head4norm4;  head4norm5; ...
               head4norm6;  head4norm7; head4norm8; head4norm9;  head4norm10;]
 
% keyboard
 
 p34_acc = [ p3_acc1; p3_acc2; p3_acc3; p3_acc4; p3_acc5;...
	     p3_acc6; p3_acc7; p3_acc8; p3_acc9; p3_acc10;...
             p4_acc1; p4_acc2; p4_acc3; p4_acc4; p4_acc5; ...
	     p4_acc6; p4_acc7; p4_acc8; p4_acc9; p4_acc10;] 
  

     
  head_lah = head_lah(find(head_lah(:,3)), :)
  head3Mov = head3Mov(find(head3Mov(:,1)), :);
  head4Mov = head4Mov(find(head4Mov(:,1)), :);
  headMov = [head3Mov; head4Mov;];
  
  segment4 = time(segment3); 
  five_model_summary = sum(single_model);
  
  if(debug == 1)
    %debug   
    fixations_via_adding_model_fix = length(model_1_fixations) + ...
	length(model_2_fixations) + length(model_3_fixations) + ...
	length(model_4_fixations) + length(model_5_fixations);
    
    fixations_from_vrfat = length(fixations);
    model;
    
    disp '  Total  LAH  Guiding LB Empty1 Empty2 Full1 Full2'
    single_model

    disp '  Total  LAH  Guiding  LB Empty1 Empty2 Full1 Full2'
    five_model_summary = sum(single_model)
    
    disp '     [---Look-Aheads----------------]    [-------Guiding/Grab/Return----]    [---Look-Backs-----------------]'
    disp '     1     2     3     4     9     10    1     2     3     4     9     10    1    2     3      4     9     10'
    model_bins

    
    a = sum(model_bins);
    b(1,:) = a(1:6);
    b(2,:) = a(7:12);
    b(3,:) = a(13:18);
    bin_sum1234_9_10 = sum(b) 

    fix_type_sum(1,1) = sum(a(1:6));
    fix_type_sum(1,2) = sum(a(7:12));
    fix_type_sum(1,3) = sum(a(13:18));
    fix_type_sum

%    keyboard

    %plot train tracks!
   %([], 'legend', []);
    baufix_plot(fixArray, 'fix', []);
    baufix_plot(lReachArray, 'lhand', []);
    baufix_plot(rReachArray, 'rhand', []); 
%    baufix_plot(head_seg, 'head', []);
%    baufix_plot([headMov(:,9:10) headMov(:,5)], 'head2', []);
    
    
    figure(2)
    %hold on
    plotyy(0, 0, time, fastrak(:,6)) 
    %hold on
    %plotyy(0, 0, time(2:end), head_vel)    
    %baufix_plot([], 'fix_plot', xy_average);
    plotedit on
    
  end
  
  
  %massage head data to include filenames
  h3_tmp = num2cell(head3Mov);
  temp = cell(size(head3Mov,1),1);
  temp(:,1) = {filename};
  head3_cell = [ temp h3_tmp ];
      
  h4_tmp = num2cell(head4Mov);
  temp = cell(size(head4Mov,1),1);
  temp(:,1) = {filename};
  head4_cell = [ temp h4_tmp ]; 
  
  save_summary(dataFile, single_model, five_model_summary, model_bins, ...
	       model_1_rReach_fixation_summary, model_1_lReach_fixation_summary,...
      	       model_2_rReach_fixation_summary, model_2_lReach_fixation_summary,...
	       model_3_rReach_fixation_summary, model_3_lReach_fixation_summary,...
	       model_4_rReach_fixation_summary, model_4_lReach_fixation_summary,...
	       model_5_rReach_fixation_summary, model_5_lReach_fixation_summary,...
	       eye_hand_data, non_action_fix, segment4, piece1_data, ...
	       piece2_data, piece3_data, piece4_data, area9_data, ...
	       area10_data, head3Mov, head4Mov, filename, head_lah, ...
	       head_norm3, head_norm4, p34_acc);
  
  
  
  c1 = count_before([model_1_rReach_fixation_summary; model_1_lReach_fixation_summary]);
  c2 = count_before([model_2_rReach_fixation_summary; model_2_lReach_fixation_summary]);
  c3 = count_before([model_3_rReach_fixation_summary; model_3_lReach_fixation_summary]);
  c4 = count_before([model_4_rReach_fixation_summary; model_4_lReach_fixation_summary]);    
  c5 = count_before([model_5_rReach_fixation_summary; model_5_lReach_fixation_summary]);

  cnt = c1+c2+c3+c4+c5;
  %for chen
  % save( [filename(1:end-3) 'mat'], 'fixArray', 'rReachArray', 'lReachArray', 'head_seg', 'head_mod_segment', 'segment4');
%  keyboard
  AllFix = [
  [ ( time(model_1_fixations(:,2))-time(model_1_fixations(:,1)) ) model_1_fixations(:,5)];
  [ ( time(model_2_fixations(:,2))-time(model_2_fixations(:,1)) ) model_2_fixations(:,5)];
  [ ( time(model_3_fixations(:,2))-time(model_3_fixations(:,1)) ) model_3_fixations(:,5)];
  [ ( time(model_4_fixations(:,2))-time(model_4_fixations(:,1)) ) model_4_fixations(:,5)];
  [ ( time(model_5_fixations(:,2))-time(model_5_fixations(:,1)) ) model_5_fixations(:,5)];
            ];

FixTypes = [model_1_lReach_fixation_summary; model_1_rReach_fixation_summary;
    model_2_lReach_fixation_summary; model_2_rReach_fixation_summary;
    model_3_lReach_fixation_summary; model_3_rReach_fixation_summary;
    model_4_lReach_fixation_summary; model_4_rReach_fixation_summary;
    model_5_lReach_fixation_summary; model_5_rReach_fixation_summary; ];
            

  FixTypes = [ ( FixTypes(:,2)-FixTypes(:,1) ) FixTypes(:,7:8) ];
  FixTypes = FixTypes(find(FixTypes(:,1)>0), :);
  
  keyboard
  return 

  
  
  
%-------------------------------------------------------------------------%
%Start function definitions:
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%   This counts and sums the fixation types in in a variety of ways
%-------------------------------------------------------------------------%

function fix_count = count(model_n_fixations, model_n_lHand_result, model_n_rHand_result)

  global Piece1 Piece2 Piece3 Piece4 EmptyDist1 EmptyDist2 ...
      FullDist1 FullDist2;

  %setup logical conditions to filter with the find command
  emptyA = (model_n_fixations(:,5) == EmptyDist1);
  emptyB = (model_n_fixations(:,5) == EmptyDist2);
  
  fullA = (model_n_fixations(:,5) == FullDist1);
  fullB = (model_n_fixations(:,5) == FullDist2);

  total = ((model_n_fixations(:,5) == 1)|(model_n_fixations(:,5) == 2)|...
	   (model_n_fixations(:,5) == 3)|(model_n_fixations(:,5) == 4)|...
	   (model_n_fixations(:,5) == 5)|(model_n_fixations(:,5) == 6)|...	   
	   (model_n_fixations(:,5) == 7)|(model_n_fixations(:,5) == 8)|...
	   (model_n_fixations(:,5) == 9)|(model_n_fixations(:,5) == 10));


  active_bins_l = ((model_n_lHand_result(:,4) == Piece1)|(model_n_lHand_result(:,4) == Piece2)|...
		   (model_n_lHand_result(:,4) == Piece3)|(model_n_lHand_result(:,4) == Piece4)|...
                   (model_n_lHand_result(:,4) == 9)|(model_n_lHand_result(:,4) == 10));
  
  active_bins_r = ((model_n_rHand_result(:,4) == Piece1)|(model_n_rHand_result(:,4) == Piece2)|...
		   (model_n_rHand_result(:,4) == Piece3)|(model_n_rHand_result(:,4) == Piece4)|...
                   (model_n_rHand_result(:,4) == 9)|(model_n_rHand_result(:,4) == 10));

  empty2a = model_n_fixations(find(emptyA), :);
  empty2b = model_n_fixations(find(emptyB), :);
  full2a = model_n_fixations(find(fullA), :);
  full2b = model_n_fixations(find(fullB), :);

  total2 = model_n_fixations(find(total), :);
  active_bins_l2 = model_n_lHand_result(find(active_bins_l),:);
  active_bins_r2 = model_n_rHand_result(find(active_bins_r),:);

  lah_sum = sum(active_bins_l2(:,6))+sum(active_bins_r2(:,6));
  guiding_sum = sum(active_bins_l2(:,7))+sum(active_bins_r2(:,7));
  lb_sum = sum(active_bins_l2(:,8))+sum(active_bins_r2(:,8));

  total_sum = size(total2(:,1)); 
  fullA_sum =  size(full2a(:,1));
  fullB_sum =  size(full2b(:,1));
  emptyA_sum = size(empty2a(:,1));
  emptyB_sum = size(empty2b(:,1));

  fix_count = [ total_sum(1,1) lah_sum guiding_sum lb_sum...
		emptyA_sum(1,1) emptyB_sum(1,1) fullA_sum(1,1) fullB_sum(1,1) ];
  
  return


%-------------------------------------------------------------------------%
%Now we need to count things individually
%-------------------------------------------------------------------------%
function bin_fix_counter = ...
      bin_fix_count(model_n_Reach_fixation_summary)
  
  global Piece1 Piece2 Piece3 Piece4 EmptyDist1 EmptyDist2 ...
      FullDist1 FullDist2;

  %if no reaches exist the create an array of zeros
  if(model_n_Reach_fixation_summary == 0)
    model_n_Reach_fixation_summary(:,9) = 0;
  end
  
 

  for i = 1:3
    %reminder (:,8) = fix type  and (:,7) is the reach bin 
    cond1 =(model_n_Reach_fixation_summary(:,7) == Piece1)&(model_n_Reach_fixation_summary(:,8) == i);
    cond2 =(model_n_Reach_fixation_summary(:,7) == Piece2)&(model_n_Reach_fixation_summary(:,8) == i);
    cond3 =(model_n_Reach_fixation_summary(:,7) == Piece3)&(model_n_Reach_fixation_summary(:,8) == i);
    cond4 =(model_n_Reach_fixation_summary(:,7) == Piece4)&(model_n_Reach_fixation_summary(:,8) == i);
    cond5 =(model_n_Reach_fixation_summary(:,7) == 9 )&(model_n_Reach_fixation_summary(:,8) == i);
    cond6 =(model_n_Reach_fixation_summary(:,7) == 10)&(model_n_Reach_fixation_summary(:,8) == i);

    if (i == 1)
      bin_fix_counter (1,1) = sum(cond1); 
      bin_fix_counter (1,2) = sum(cond2);
      bin_fix_counter (1,3) = sum(cond3);
      bin_fix_counter (1,4) = sum(cond4);
      bin_fix_counter (1,5) = sum(cond5);
      bin_fix_counter (1,6) = sum(cond6);
      
    elseif (i == 2)
      bin_fix_counter (1,7) = sum(cond1); 
      bin_fix_counter (1,8) = sum(cond2);
      bin_fix_counter (1,9) = sum(cond3);
      bin_fix_counter (1,10) = sum(cond4);
      bin_fix_counter (1,11) = sum(cond5);
      bin_fix_counter (1,12) = sum(cond6);
      
    elseif (i == 3)
      bin_fix_counter (1,13) = sum(cond1); 
      bin_fix_counter (1,14) = sum(cond2);
      bin_fix_counter (1,15) = sum(cond3);
      bin_fix_counter (1,16) = sum(cond4);
      bin_fix_counter (1,17) = sum(cond5);
      bin_fix_counter (1,18) = sum(cond6);
      
    end
  end

  return


%-----------------------------------------------------
%Partition finds the relevant areas of reaches or
%fixations so we can process each model individually
%-----------------------------------------------------
function model_n_parts = partition(data, model_num, segment)

  if(model_num == 1)
    cond1 = data(:,1) >  segment(model_num, 1);
    cond2 = data(:,2) <  segment(model_num, 2);
    model_n_parts  = data(find(cond1 & cond2),:);
  else
    cond1 = data(:,1) >  segment(model_num-1,2);
    cond2 = data(:,2) <  segment(model_num,2);
    model_n_parts  = data(find(cond1 & cond2),:);
  end

  return

  
function count = count_before(Summ)
  
  global Piece3 Piece4
  
  % find when reach to three started
  beg = find(Summ(:,7)==Piece3);
  if ~isempty(beg)
    r_beg = Summ(beg(1),4); %set reach time
  else
    count = 0;
    r_beg = 999999;    
  end
  
  %now look at fixations on four - if lookahead are they before
  %the reach occured?
  
  four_lah = find((Summ(:,7)==Piece4)&(Summ(:,8)==1)&(Summ(:,1)<r_beg));

  if ~isempty(four_lah)
    count = size(four_lah,1);
  else
    count = 0;
    
  end
  
  
  return
  




































