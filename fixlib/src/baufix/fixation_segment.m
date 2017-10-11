%-------------------------------------------------------------------------%
%This function determines how fixations and reaches are related
%temporally and it determines the most experimentally valuable info
%-------------------------------------------------------------------------%
function [model_n_reach_fixation_associations, fixation_summary]...
      = fixation_segment(model_n_rReaches, model_n_lReaches, ...
			 model_n_fixations, time, hand)

  global Piece1 Piece2 Piece3 Piece4 EmptyDist1 EmptyDist2 FullDist1 ...
      FullDist2 fixation_summary;
  
  
  %sets hand to analyze
  
  if strcmp(hand, 'right')
   model_n_Reaches = model_n_rReaches; 
   other_hand = model_n_lReaches;
  elseif strcmp(hand, 'left')
    model_n_Reaches = model_n_lReaches; 
    other_hand = model_n_rReaches;  
  end
  
  
     %sets a bound in time for analyzing bins 9&10
  bound = 5;
  
  %Correct for fastrak latency (See Latency Appendix in 5.8ms ~6ms)
  %and convert frames into seconds

if (size(model_n_Reaches,1) == 1)
  model_n_Reaches = [time(model_n_Reaches(:, 1:2))'-0.006  model_n_Reaches(:,3:4)];  
else
  model_n_Reaches = [time(model_n_Reaches(:, 1:2))-0.006  model_n_Reaches(:,3:4)];  
end

if (size(other_hand,1) == 1) 
  other_hand = [time(other_hand(:, 1:2))'-0.006  other_hand(:,3:4)];  
else
  other_hand = [time(other_hand(:, 1:2))-0.006  other_hand(:,3:4)];  
end


  %Correct for ASL latency (According to ASL: 3 frame 60hz latency =  50ms)
  %and convert frames into seconds

  model_n_fixations = [time(model_n_fixations(:,1:2))-0.05  model_n_fixations(:,3:5)];
  
    fixation_summary = zeros(1,10); %initialize array
   
  %Now process the hand for model n
  for i = 1:size(model_n_Reaches,1)
    
    model_n_reach_fixation_associations(i,1) = 0; %total fixations
    model_n_reach_fixation_associations(i,2) = 0; %look aheads
    model_n_reach_fixation_associations(i,3) = 0; %guiding fixations
    model_n_reach_fixation_associations(i,4) = 0; %look backs
    
    Reach_bin = model_n_Reaches(i, 4);
    Start_bin = model_n_Reaches(i, 3);
    num_fixations = size(model_n_fixations,1);
    num_reaches = size(model_n_Reaches,1);
    
    %Examine only reaches on Pieces 1-4 and bins 9&10
    if ((model_n_Reaches(i, 4) == Piece1)|(model_n_Reaches(i, 4) == Piece2)|(model_n_Reaches(i, 4) == Piece3)|...
	(model_n_Reaches(i, 4) == Piece4)|(model_n_Reaches(i, 4) == 9)|(model_n_Reaches(i, 4) == 10))
      
%add the reach to our list regardless of whether fixations are on it or not
	      fixation_summary(end+1,3) = i;%reach number within model
	      fixation_summary(end,4) = model_n_Reaches(i,1);%reach start
	      fixation_summary(end,5) = model_n_Reaches(i,2);%reach end
	      fixation_summary(end,6) = Start_bin;  
	      fixation_summary(end,7) = Reach_bin;      
	      
%	      fixation_summary(end,9) = model_n_Reaches(i+1,1) - model_n_Reaches(i,2);%grab time	
      
            
      for j = 1:size(model_n_fixations,1)
	
	%this counts the number of reach_bin fixations per reach w/o temporal segmentation
	if (model_n_fixations(j, 5) == Reach_bin)

	  %make an entry to list all relevant fixations
	%    fixation_summary(end,1) = model_n_fixations(j, 1);%init fixation
	%    fixation_summary(end,2) = model_n_fixations(j, 2);%end fixation 
	%    fixation_summary(end,7) = Reach_bin;
	%    fixation_summary(end,10) = j; %fixation number
	  
	  %we must screen the data so that fixations are not
          %spuriously associated with multiple reaches:
	  %is there another reach that this fixation is closer to? 
	  %if so move on until we get to that reach and can analyze it
	  
	  %find center of reach and fixation
	  center_fix = (abs(model_n_fixations(j,2) - ...
			    model_n_fixations(j,1)))/2 + model_n_fixations(j,1);
	  center_reach = (abs(model_n_Reaches(i,2) - ...
			      model_n_Reaches(i,1)))/2 + model_n_Reaches(i,1);
	  center_delta = abs(center_fix - center_reach);
	  
	  test_delta = 9999; %need one large value to start
	  test_delta2 = 9999;

	   
	  for q = 1:size(model_n_Reaches,1)
	    if (model_n_Reaches(q,4) == Reach_bin)
	      test_center_reach = (abs(model_n_Reaches(q,2) - ...
				    model_n_Reaches(q,1)))/2 + model_n_Reaches(q,1);
	      test_delta(end+1) = abs(test_center_reach - ...
				      center_fix);
	    end  
	  end
	  
	  
	 for q = 1:size(other_hand,1)
	    if (other_hand(q,4) == Reach_bin)
	      test_center_reach2 = (abs(other_hand(q,2) - ...
				    other_hand(q,1)))/2 + other_hand(q,1);
	      test_delta2(end+1) = abs(test_center_reach2 - ...
				      center_fix);	            
	    end
	  end
	  
	  	  	  	    
	  %now test to see if there is a reach closer to this
          %fixation that it should be associated with
          if(min(test_delta) < center_delta)|(min(test_delta2) < ...
					      center_delta)   
	    continue %restart loop for next fixation
	  end
	  
	  
	  %In the fix_assoc array, column 1 is for total fixations,
          %2 is for LAHs, 3 is for Guiding, 4 is for LBs
	  model_n_reach_fixation_associations(i,1) = model_n_reach_fixation_associations(i,1) + 1;
	  
	  % Now start temporal segmentation: 
	  
	  % #1 - Examine Fixations preceding the reach start
	  
	  % Define: Look ahead - before in time w/ no overlap plus at least one
	  % intervening fixation on a non-Reach_bin.
		
	    if (model_n_fixations(j, 2) < model_n_Reaches(i,1))
	      
	      if ((Reach_bin == 9 )|(Reach_bin == 10))&...
		(abs(model_n_Reaches(i,1) - model_n_fixations(j, 2)) > bound)
	        continue
	      
	      end
	      	      	    	      
	    %Thus, if the end of a fixation is before the beginning of a reach
	    %we have a potential look ahead but we must test this:

	    counter = 0;
	    fix_index = j+1;
	    Reach_bin_counter = 0;

	    %find any fixations between the end of fixation 'j' and the
	    %beginning of reach 'i' and test to see if they are on or
	    %off the reach_bin 
	    
	    while((fix_index < num_fixations)&(model_n_fixations(fix_index,2) < model_n_Reaches(i,1)))
	      
	      if (model_n_fixations(fix_index,5) == Reach_bin)
		Reach_bin_counter = 1 + Reach_bin_counter;%intervening
							  %fixations on reach_bin
	      end
	      fix_index = fix_index +1;     
	      counter = counter + 1;%total number of intervening fixations
	    end %while
	    
	    
	    % case of the classic look ahead
	    if ((counter > 0)&(Reach_bin_counter == 0))
	      %fixation summary details all fixations the reaches
	      %involves and the analysis results
	      %I have abitrarily assigned the following number scheme
	      %to the fixation types:
	      % 0 = unknown, 1 = look ahead, 2 = guiding, 3 = look back
	      model_n_reach_fixation_associations(i,2) = ...
		  model_n_reach_fixation_associations(i,2) + 1;
              fixation_summary = save_data(i,j, model_n_Reaches, ...
					   model_n_fixations, ...
					   Start_bin, Reach_bin);      
	      fixation_summary(end,8) = 1;%LAH   
	      
	      
	      % case of one fixation on target before guiding fixation to same target    
	    elseif ((counter == 1)&(Reach_bin_counter ~= 0))
	      model_n_reach_fixation_associations(i,3) = ...
		  model_n_reach_fixation_associations(i,3) + 1;
	      fixation_summary = save_data(i,j, model_n_Reaches, ...
					   model_n_fixations, ...
					   Start_bin, Reach_bin);       
	      fixation_summary(end,8) = 2;%guiding	    
	      
	      
	      %no intermediate fixations therefore a guiding fixation      
	    elseif (counter == 0) 
	      model_n_reach_fixation_associations(i,3) = ...
		  model_n_reach_fixation_associations(i,3) + 1;
	      fixation_summary = save_data(i,j, model_n_Reaches, ...
					   model_n_fixations, ...
					   Start_bin, Reach_bin);    
	      fixation_summary(end,8) = 2;%guiding	    
	
	      
	      
	      % a series of look aheads? - we must check to see this isn't a
	      % string of guiding fixations
	    elseif (counter/Reach_bin_counter == 1)
	      model_n_reach_fixation_associations(i,3) = ...
		  model_n_reach_fixation_associations(i,3) + 1;
	      fixation_summary = save_data(i,j, model_n_Reaches, ...
					   model_n_fixations, ...
					   Start_bin, Reach_bin);    
	      fixation_summary(end,8) = 2; %guiding	    
	     
	      
	    elseif (counter/Reach_bin_counter ~= 1)
	      model_n_reach_fixation_associations(i,2) = ...
		  model_n_reach_fixation_associations(i,2) + 1;
	      fixation_summary = save_data(i,j, model_n_Reaches, ...
					   model_n_fixations, ...
					   Start_bin, Reach_bin);    
	      fixation_summary(end,8) = 1; %LAH	    
	      
	    end %end look ahead determination

	    
	    % #2 Examine fixations coinciding with the reach and
	    %    grabbing time(begining of reach i to end of i+2):  
	    %    Guiding/Grabbing/Retraction Fixations:
	  elseif ((model_n_Reaches(i,1) <= model_n_fixations(j, 1))&...
		  (model_n_Reaches(i+1,2) >= model_n_fixations(j, 1)))|...
		 ((model_n_Reaches(i,1) <= model_n_fixations(j, 2))&...
		  (model_n_Reaches(i+1,2) >= model_n_fixations(j, 2)))
	    
	    model_n_reach_fixation_associations(i,3) = ...
		model_n_reach_fixation_associations(i,3) + 1;
	    fixation_summary = save_data(i,j, model_n_Reaches, ...
					   model_n_fixations, ...
					   Start_bin, Reach_bin);    
	    fixation_summary(end,8) = 2;	    
          
	    	   
	    % #3 Examine post-reach fixations 
	    %look back (after in time w/ no overlap over reaching/grabbing/retraction time)
	  elseif (model_n_fixations(j, 1) > model_n_Reaches(i+1, 2))

	     if ((Reach_bin == 9 )|(Reach_bin == 10))&...
		(abs(model_n_fixations(j, 1) - model_n_Reaches(i+1,1)) > bound)
	        continue
	      
	      end
	   
	    
	    %Look backs should be treated as the converse of Look
	    %aheads, meaning just b/c the fixation happens after the
	    %reach we must still be positive we are not incorrectly
	    %calling a guiding fixation a look back
	    counter = 0;
	    fix_index = j-1;
	    Reach_bin_counter = 0;

	    %find any fixations between the beginning of fixation 'j' and the
	    %end of reach 'i''s grabbing period ie (i+1) and test to see if they are on or
	    %off the reach_bin 
	    
	    while((fix_index ~= 0)&(model_n_fixations(fix_index,1) > model_n_Reaches(i+1,2)))
	      
	      if (model_n_fixations(fix_index,5) == Reach_bin)
		Reach_bin_counter = 1 + Reach_bin_counter;%intervening
							  %fixations on reach_bin
	      end
	      
	      fix_index = fix_index  - 1;     
	      counter = counter + 1;%total number of intervening fixations
				   
	    end
	    
	    %guiding fixation
	    if(counter == 0)
	      model_n_reach_fixation_associations(i,3) = ...
		  model_n_reach_fixation_associations(i,3) + 1;
	      fixation_summary = save_data(i,j, model_n_Reaches, ...
					   model_n_fixations, ...
					   Start_bin, Reach_bin);    
	      fixation_summary(end,8) = 2;	%guiding	    
	     
	      
	      %classic look back  
	    elseif(counter > 0)&(Reach_bin_counter == 0)
	      model_n_reach_fixation_associations(i,4) = ...
		  model_n_reach_fixation_associations(i,4) + 1;
	      fixation_summary = save_data(i,j, model_n_Reaches, ...
					   model_n_fixations, ...
					   Start_bin, Reach_bin);    
	      fixation_summary(end,8) = 3;	%look back	    
	     
	      
	      % a series of look backs? - we must check to see this isn't a
	      % string of guiding fixations
	    elseif (counter/Reach_bin_counter == 1)
	      model_n_reach_fixation_associations(i,3) = ...
		  model_n_reach_fixation_associations(i,3) + 1;
	      fixation_summary = save_data(i,j, model_n_Reaches, ...
					   model_n_fixations, ...
					   Start_bin, Reach_bin);    
	      fixation_summary(end,8) = 2;	%guiding	    
	      
	      
	      
	    elseif (counter/Reach_bin_counter ~= 1)
	      model_n_reach_fixation_associations(i,4) = ...
		  model_n_reach_fixation_associations(i,4) + 1;
	      fixation_summary = save_data(i,j, model_n_Reaches, ...
					   model_n_fixations, ...
					   Start_bin, Reach_bin);    
	      fixation_summary(end,8) = 3;	%look back	    
	      
	    end %LB determination 	    
	    
	    else	        
	      fixation_summary(end,1) = model_n_fixations(j, 1);%init fixation
	      fixation_summary(end,2) = model_n_fixations(j, 2);%end  fixation
	      fixation_summary(end,10) = j; %fixation number
	      
	    end %if..elseif (testing fixations in time)
	    
	    
	    
	    
	end % %if fixation on reach bin
      end %for j(fixations)
    end %if reach to relevant bin
  end %for i(reaches)
  return %end of segment fixation function



function fixation_summary = save_data(i, j, model_n_Reaches, ...
				      model_n_fixations, Start_bin, ...
				      Reach_bin )     
              
      global fixation_summary      
   
              fixation_summary(end+1,1) = model_n_fixations(j, 1);%init fixation
	      fixation_summary(end,2) = model_n_fixations(j, 2);%end  fixation
	      fixation_summary(end,3) = i;%reach number within model
	      fixation_summary(end,4) = model_n_Reaches(i,1);%reach start
	      fixation_summary(end,5) = model_n_Reaches(i,2);%reach end
	      fixation_summary(end,6) = Start_bin;  
	      fixation_summary(end,7) = Reach_bin;      
	      fixation_summary(end,9) = model_n_Reaches(i+1,1) - ...
		  model_n_Reaches(i,2);%grab time	
	      fixation_summary(end,10) = j; %fixation number
return









