%CBA_CHANGES_BY_NOTICED sorts size changes into noticed/unnoticed 
%   [YES, NO] = CBA_CHANGES_BY_NOTICED(T, SIZE, TOID, NOTICED) takes
%   the time T, size data SIZE, touched object id data TOID, and
%   noticed data NOTICED (produced by CBA_LOAD_NOTICED), and
%   divides all size changes according to whether or not they were
%   noticed.  Those noticed go in YES, else they go in NO.
%
%   NOTE! SIZE is raw size data, not the list of size changes.  

%   $Id: cba_changes_by_noticed.m,v 1.2 2001/08/15 16:48:50 pskirko Exp $
%   pskirko 8.14.01


function [yn_changes, nn_changes] = cba_changes_by_noticed(t, ...
						  o_size, ...
						  toid, noticed)
n = length(t);

%size_changes = zeros(n,1);
%size_changes = []; idx = 1;
yn_changes = []; y_idx = 1;
nn_changes = []; n_idx = 1;

start_touch = []; 
%end_touch = [];
prev = [];

curr_min = Inf; curr_max = -Inf;

for i=1:n
  curr_size = o_size(i);
  
  if(curr_size ~= 0)
    if(curr_size < curr_min) curr_min = curr_size; end
    if(curr_size > curr_max) curr_max = curr_size; end
  end
  
  if(curr_size ~= 0)
    if(isempty(start_touch)) % start new touch
      start_touch = i;
    end
  else 
    if(~isempty(start_touch)) 
      
      % touch is from start touch to prev
      % sr = o_size(start_touch:prev);
      %      if(max(sr) - min(sr) ~=0) % size change occurred
      if(curr_max ~= curr_min)
	
	% check to see if noticed
	cond1 = noticed >= t(start_touch);
	cond2 = noticed <= t(i);
	
	cond3 = cond1 & cond2;
	
	if(sum(cond3) ~= 0) % noticed
	  yn_changes(y_idx,:) = [t(start_touch), t(i)];%go one past
	  y_idx = y_idx+1;
	else
	  nn_changes(n_idx,:) = [t(start_touch), t(i)];%go one past
	  n_idx = n_idx+1;
	end
	
%	size_changes(idx,:) = [t(start_touch), t(i)];%go one past
%	idx = idx+1;
	start_touch  = [];
	prev = [];
	curr_min = Inf;
	curr_max = -Inf;
	
	%size_changes(start_touch:prev) = 1;
      else
	start_touch  = [];
	prev = [];
	curr_min = Inf;
	curr_max = -Inf;
	%size_changes(start_touch:prev) = -1;
      end
    end
    
  end
  
  prev = i;
end
