function [xy_average, bin] = label_bins(binEyeHV, fixations, binSizeX, binSizeY)

%Manual labeling of scene plane bins
  t_stop = length(fixations);
  for i = 1:t_stop
    t_initial = fixations(i,1);
    t_final = fixations(i,2);

    xy_average(i,1) = ((sum(binEyeHV(t_initial:t_final,1))/(t_final-t_initial)));
    xy_average(i,2) = (sum(binEyeHV(t_initial:t_final,2))/(t_final-t_initial));

    % Remember Y is negative going up and to the left all values are in mm

    %cut bin sizes in half to determine box sizes from command line
    sizeX = binSizeX/2;
    sizeY = binSizeY/2;

    hold on
    %we want to implement nathans box drawing idea here:
    plot(xy_average(:,1), -xy_average(:,2), '.b');

 
    
    % basic order is left,right,top, bottom

    %bin1 center_coords = (50, -26.5)
    if(((495-sizeX)<xy_average(i,1)) & ((495+sizeX)>xy_average(i,1)) & ...
       ((-265-sizeY)<xy_average(i,2)) & ((-265+sizeY)>xy_average(i,2)) )
      xy_average(i,3) = 1; 

      %bin2 center_coords = (16, -26.5)  
    elseif(((160-sizeX)<xy_average(i,1)) & ((160+sizeX)>xy_average(i,1)) & ...
	   ((-265-sizeY)<xy_average(i,2)) & ((-265+sizeY)>xy_average(i,2)) )
      xy_average(i,3) = 2; 
      
      %bin3 center_coords = (-17, -26.5)
    elseif(((-160-sizeX)<xy_average(i,1)) & ((-160+sizeX)>xy_average(i,1)) & ...
	   ((-265-sizeY)<xy_average(i,2)) & ((-265+sizeY)>xy_average(i,2)))
      xy_average(i,3) = 3;
      
      %bin4 center_coords = (-50, -26.5)
    elseif(((-495-sizeX)<xy_average(i,1)) & ((-495+sizeX)>xy_average(i,1)) & ...
	   ((-265-sizeY)<xy_average(i,2)) & ((-265+sizeY)>xy_average(i,2)))
      xy_average(i,3) = 4; 

      %bin5 center_coords = (50, -6.5)
    elseif( ((495-sizeX)<xy_average(i,1)) & ((495+sizeX)>xy_average(i,1)) & ...
	    ((-65-sizeY)<xy_average(i,2)) & ((-65+sizeY)>xy_average(i,2))) 
      xy_average(i,3) = 5; 

      %bin6 center_coords = (16, -6.5)
    elseif( ((160-sizeX)<xy_average(i,1)) & ((160+sizeX)>xy_average(i,1)) & ...
	    ((-65-sizeY)<xy_average(i,2)) & ((-65+sizeY)>xy_average(i,2))) 
      xy_average(i,3) = 6; 

      %bin7 center_coords = (-16, -6.5)
    elseif( ((-160-sizeX)<xy_average(i,1)) & ((-160+sizeX)>xy_average(i,1)) & ...
	    ((-65-sizeY)<xy_average(i,2)) & ((-65+sizeY)>xy_average(i,2)) )
      xy_average(i,3) = 7;   
      
      %bin8 center_coords = (-50, -6.5)
    elseif( ((-500-sizeX)<xy_average(i,1)) & ((-500+sizeX)>xy_average(i,1)) & ...
	    ((-65-sizeY)<xy_average(i,2)) & ((-65+sizeY)>xy_average(i,2)) )
      xy_average(i,3) = 8;   

      %bin9 center_coords = (-57.5, 19)
%    elseif( (-675<xy_average(i,1)) & (-475>xy_average(i,1)) & ...
%	    ( 325>xy_average(i,2)) & (65<xy_average(i,2)) )
%      xy_average(i,3) = 9;  
      
      %bin10 center_coords = (-36.5, 19)
%    elseif( (-465<xy_average(i,1)) & (-265>xy_average(i,1)) & ...
%	    ( 325>xy_average(i,2)) & (65<xy_average(i,2)) )
%      xy_average(i,3) = 10;  

       %bin9 center_coords = (-57.0, 19)
    elseif( ((-1000)<xy_average(i,1)) & ((-570+sizeY)>xy_average(i,1)) & ...
	    ( (190-sizeX)<xy_average(i,2)) & ((500)>xy_average(i,2)) )
      xy_average(i,3) = 9;  
      
      %bin10 center_coords = (-37.0, 19)
    elseif( ((-370-sizeY)<xy_average(i,1)) & ((-370+sizeY)>xy_average(i,1)) & ...
	    (( 190-sizeX)<xy_average(i,2)) & ((500)>xy_average(i,2)) )
      xy_average(i,3) = 10;    
          
      %bin11 center_coords = (0, 15)
    elseif( (-275<xy_average(i,1)) & (275>xy_average(i,1)) & ...
	    ( 0<xy_average(i,2)) & (300>xy_average(i,2)) )
      xy_average(i,3) = 11;  

      %bin12 center_coords = (50, 15)
    elseif( (605>xy_average(i,1)) & (275<xy_average(i,1)) & ...
	    ( 0<xy_average(i,2)) & (300>xy_average(i,2)) )
      xy_average(i,3) = 12; 
    end
    

  end

    
   % bin1 = boxPlot(1); bin2 = boxPlot(2); bin3 = boxPlot(3); bin4 = boxPlot(4);
   % bin5 = boxPlot(5); bin6 = boxPlot(6); bin7 = boxPlot(7); bin8 = boxPlot(8);
   % bin9 = boxPlot(9); bin10 = boxPlot(10); bin11 = boxPlot(11); bin12 = boxPlot(12);
  
%keyboard


    bin(1,1) = sum(xy_average(:,3) == 1);
    bin(1,2) = sum(xy_average(:,3) == 2);
    bin(1,3) = sum(xy_average(:,3) == 3);
    bin(1,4) = sum(xy_average(:,3) == 4); 
    bin(1,5) = sum(xy_average(:,3) == 5);
    bin(1,6) = sum(xy_average(:,3) == 6);
    bin(1,7) = sum(xy_average(:,3) == 7);
    bin(1,8) = sum(xy_average(:,3) == 8);
    bin(1,9) = sum(xy_average(:,3) == 9);
    bin(1,10) = sum(xy_average(:,3) == 10);
    bin(1,11) = sum(xy_average(:,3) == 11);
    bin(1,12) = sum(xy_average(:,3) == 12);
    bin(1,13) = sum(xy_average(:,3) == 0);
    
    return







