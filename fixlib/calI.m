function [table, wall, conveyor, blockPlane] = calI(bricksFile, fixFile)

  
    global wallGazeIntersection tableGazeIntersection ...
      conveyorGazeIntersection blockPlaneGazeIntersection
    
  load (bricksFile);load (fixFile);  
  

  %First process fix_hi_frames
  
  %first we need to tabulate the frames that each fixation begins
  %and ends on
  
%  keyboard
  high = findInt(fix_hi_frames);
  mid =  findInt(fix_mid_frames);
  low = findInt(fix_low_frames);
  hmm = findInt(hmm_fix_frames);
  adap = findInt(adap_vel_fix_frames);
  vel = findInt(vel_fix_frames);
  
  save ([bricksFile(1:16),'.i.mat'], 'high', 'mid', 'low', 'hmm', ...
	'adap', 'vel');
  
  
%  keyboard
  
  return
  
  
  

function [data] = findInt(fixes)
  global wallGazeIntersection tableGazeIntersection ...
      conveyorGazeIntersection blockPlaneGazeIntersection
  
  once = 0;
  %step through each fixation
  for i = 1:size(fixes)
    init  = fixes(i, 1);
    final = fixes(i, 2);
    delta_t = (final - init)+1;
 
   
   if (~once)
     wallXYZ_ave = sum(wallGazeIntersection(init:final,:))/delta_t;
     tableXYZ_ave = sum(tableGazeIntersection(init:final, :))/delta_t;
     conveyorXYZ_ave = sum(conveyorGazeIntersection(init:final, :))/delta_t;
     blockPlaneXYZ_ave = sum(blockPlaneGazeIntersection(init:final, :))/delta_t;
     once = 1;
     
   else
     wallXYZ_ave(end+1,:) = sum(wallGazeIntersection(init:final,:))/delta_t;
     tableXYZ_ave(end+1,:) = sum(tableGazeIntersection(init:final, :))/delta_t;
     conveyorXYZ_ave(end+1,:) = sum(conveyorGazeIntersection(init:final, :))/delta_t;
     blockPlaneXYZ_ave(end+1,:) = sum(blockPlaneGazeIntersection(init:final, :))/delta_t;
   end
   
     data =  struct('wall', wallXYZ_ave, 'table', tableXYZ_ave, ...
		'conveyor', conveyorXYZ_ave, 'blockPlane', ...
		blockPlaneXYZ_ave );   
  end
  return
  
  