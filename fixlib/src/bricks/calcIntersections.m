function [table, wall, conveyor, blockPlane] = calcIntersections(bricksFile, fixFile)
  
  load (bricksFile);load (fixFile);  
  

  %First process fix_hi_frames
  
  %first we need to tabulate the frames that each fixation begins
  %and ends on
  
  %step through each fixation
  for i = 1:size(fix_hi_frames)
    init  = fix_hi_frames(i, 1);
    final = fix_hi_frames(i, 2);
   
    wallXYZ_sum = 0; tableXYZ_sum = 0; conveyorXYZ_sum = 0; ...
	blockPlaneXYZ_sum = 0;
    
    %now step through values from init to final
    for j = init:final,
     wallXYZ_sum = wallGazeIntersection(j, :) + wallXYZ_sum;
     tableXYZ_sum = tableGazeIntersection(j, :) + tableXYZ_sum;
     conveyorXYZ_sum = conveyorGazeIntersection(j, :) + conveyorXYZ_sum;
     blockPlaneXYZ_sum = blockPlaneGazeIntersection(j, :) + blockPlaneXYZ_sum;
    end
    
     wallXYZ_ave(i,:) = wallXYZ_sum/(final-init);
     tableXYZ_ave(i,:) = tableXYZ_sum/(final-init);
     conveyorXYZ_ave(i,:) = conveyorXYZ_sum/(final-init);  
     blockPlaneXYZ_ave(i,:) = blockPlaneXYZ_sum/(final-init);
  end

   high =  struct('wall', wallXYZ_ave, 'table', tableXYZ_ave, ...
		  'conveyor', conveyorXYZ_ave, 'blockPlane', ...
		  blockPlaneXYZ_ave );
   
 clear wallXYZ_ave tableXYZ_ave conveyorXYZ_ave blockPlaneXYZ_ave;
  
  %next process hmm_fix_frames
  
  %first we need to tabulate the frames that each fixation begins
  %and ends on
  
  %step through each fixation
  for i = 1:size(hmm_fix_frames)
    init  = hmm_fix_frames(i, 1);
    final = hmm_fix_frames(i, 2);
   
    wallXYZ_sum = 0; tableXYZ_sum = 0; conveyorXYZ_sum = 0; ...
	blockPlaneXYZ_sum = 0;
    
    %now step through values from init to final
    for j = init:final,
     wallXYZ_sum = wallGazeIntersection(j, :) + wallXYZ_sum;
     tableXYZ_sum = tableGazeIntersection(j, :) + tableXYZ_sum;
     conveyorXYZ_sum = conveyorGazeIntersection(j, :) + conveyorXYZ_sum;
     blockPlaneXYZ_sum = blockPlaneGazeIntersection(j, :) + blockPlaneXYZ_sum;
    end
    
     wallXYZ_ave(i,:) = wallXYZ_sum/(final-init);
     tableXYZ_ave(i,:) = tableXYZ_sum/(final-init);
     conveyorXYZ_ave(i,:) = conveyorXYZ_sum/(final-init);  
     blockPlaneXYZ_ave(i,:) = blockPlaneXYZ_sum/(final-init);
  end

   hmm =  struct('wall', wallXYZ_ave, 'table', tableXYZ_ave, ...
		  'conveyor', conveyorXYZ_ave, 'blockPlane', ...
		  blockPlaneXYZ_ave );
   
  clear wallXYZ_ave tableXYZ_ave conveyorXYZ_ave blockPlaneXYZ_ave;  
  
   %next process vel_fix_frames
  
  %first we need to tabulate the frames that each fixation begins
  %and ends on
  
  %step through each fixation
  for i = 1:size(vel_fix_frames)
    init  = vel_fix_frames(i, 1);
    final = vel_fix_frames(i, 2);
   
    wallXYZ_sum = 0; tableXYZ_sum = 0; conveyorXYZ_sum = 0; ...
	blockPlaneXYZ_sum = 0;
    
    %now step through values from init to final
    for j = init:final,
     wallXYZ_sum = wallGazeIntersection(j, :) + wallXYZ_sum;
     tableXYZ_sum = tableGazeIntersection(j, :) + tableXYZ_sum;
     conveyorXYZ_sum = conveyorGazeIntersection(j, :) + conveyorXYZ_sum;
     blockPlaneXYZ_sum = blockPlaneGazeIntersection(j, :) + blockPlaneXYZ_sum;
    end
    
     wallXYZ_ave(i,:) = wallXYZ_sum/(final-init);
     tableXYZ_ave(i,:) = tableXYZ_sum/(final-init);
     conveyorXYZ_ave(i,:) = conveyorXYZ_sum/(final-init);  
     blockPlaneXYZ_ave(i,:) = blockPlaneXYZ_sum/(final-init);
  end

   vel =  struct('wall', wallXYZ_ave, 'table', tableXYZ_ave, ...
		  'conveyor', conveyorXYZ_ave, 'blockPlane', ...
		  blockPlaneXYZ_ave );  
   
 clear wallXYZ_ave tableXYZ_ave conveyorXYZ_ave blockPlaneXYZ_ave;  
   
    %process adap_vel_fix_frames
  
  %first we need to tabulate the frames that each fixation begins
  %and ends on
  
  %step through each fixation
  for i = 1:size(adap_vel_fix_frames)
    init  = adap_vel_fix_frames(i, 1);
    final = adap_vel_fix_frames(i, 2);
   
    wallXYZ_sum = 0; tableXYZ_sum = 0; conveyorXYZ_sum = 0; ...
	blockPlaneXYZ_sum = 0;
    
    %now step through values from init to final
    for j = init:final,
     wallXYZ_sum = wallGazeIntersection(j, :) + wallXYZ_sum;
     tableXYZ_sum = tableGazeIntersection(j, :) + tableXYZ_sum;
     conveyorXYZ_sum = conveyorGazeIntersection(j, :) + conveyorXYZ_sum;
     blockPlaneXYZ_sum = blockPlaneGazeIntersection(j, :) + blockPlaneXYZ_sum;
    end
    
     wallXYZ_ave(i,:) = wallXYZ_sum/(final-init);
     tableXYZ_ave(i,:) = tableXYZ_sum/(final-init);
     conveyorXYZ_ave(i,:) = conveyorXYZ_sum/(final-init);  
     blockPlaneXYZ_ave(i,:) = blockPlaneXYZ_sum/(final-init);
  end

   adap_vel =  struct('wall', wallXYZ_ave, 'table', tableXYZ_ave, ...
		  'conveyor', conveyorXYZ_ave, 'blockPlane', ...
		  blockPlaneXYZ_ave );   
   
    clear wallXYZ_ave tableXYZ_ave conveyorXYZ_ave blockPlaneXYZ_ave;  
    
       
   
   
   %process fix_mid_frames
  
  %first we need to tabulate the frames that each fixation begins
  %and ends on
  
  %step through each fixation
  for i = 1:size(fix_mid_frames)
    init  = fix_mid_frames(i, 1);
    final = fix_mid_frames(i, 2);
   
    wallXYZ_sum = 0; tableXYZ_sum = 0; conveyorXYZ_sum = 0; ...
	blockPlaneXYZ_sum = 0;
    
    %now step through values from init to final
    for j = init:final,
     wallXYZ_sum = wallGazeIntersection(j, :) + wallXYZ_sum;
     tableXYZ_sum = tableGazeIntersection(j, :) + tableXYZ_sum;
     conveyorXYZ_sum = conveyorGazeIntersection(j, :) + conveyorXYZ_sum;
     blockPlaneXYZ_sum = blockPlaneGazeIntersection(j, :) + blockPlaneXYZ_sum;
    end
    
     wallXYZ_ave(i,:) = wallXYZ_sum/(final-init);
     tableXYZ_ave(i,:) = tableXYZ_sum/(final-init);
     conveyorXYZ_ave(i,:) = conveyorXYZ_sum/(final-init);  
     blockPlaneXYZ_ave(i,:) = blockPlaneXYZ_sum/(final-init);
  end

   mid =  struct('wall', wallXYZ_ave, 'table', tableXYZ_ave, ...
		  'conveyor', conveyorXYZ_ave, 'blockPlane', ...
		  blockPlaneXYZ_ave );   
   
    clear wallXYZ_ave tableXYZ_ave conveyorXYZ_ave blockPlaneXYZ_ave;  
   
   
%   process fix_low_frames
  
  %first we need to tabulate the frames that each fixation begins
  %and ends on
  
  %step through each fixation
  for i = 1:size(fix_low_frames)
    init  = fix_low_frames(i, 1);
    final = fix_low_frames(i, 2);
   
    wallXYZ_sum = 0; tableXYZ_sum = 0; conveyorXYZ_sum = 0; ...
	blockPlaneXYZ_sum = 0;
    
    %now step through values from init to final
    for j = init:final,
     wallXYZ_sum = wallGazeIntersection(j, :) + wallXYZ_sum;
     tableXYZ_sum = tableGazeIntersection(j, :) + tableXYZ_sum;
     conveyorXYZ_sum = conveyorGazeIntersection(j, :) + conveyorXYZ_sum;
     blockPlaneXYZ_sum = blockPlaneGazeIntersection(j, :) + blockPlaneXYZ_sum;
    end
    
     wallXYZ_ave(i,:) = wallXYZ_sum/(final-init);
     tableXYZ_ave(i,:) = tableXYZ_sum/(final-init);
     conveyorXYZ_ave(i,:) = conveyorXYZ_sum/(final-init);  
     blockPlaneXYZ_ave(i,:) = blockPlaneXYZ_sum/(final-init);
  end

   low =  struct('wall', wallXYZ_ave, 'table', tableXYZ_ave, ...
		  'conveyor', conveyorXYZ_ave, 'blockPlane', ...
		  blockPlaneXYZ_ave );   
   
    clear wallXYZ_ave tableXYZ_ave conveyorXYZ_ave blockPlaneXYZ_ave;  
    
    
    
   save ([bricksFile, '.inter.mat'], 'high', 'mid', 'low', 'adap_vel', 'vel', 'hmm');