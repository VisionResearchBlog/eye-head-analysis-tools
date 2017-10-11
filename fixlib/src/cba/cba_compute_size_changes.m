%CBA_COMPUTE_SIZE_CHANGES computes size changes
%   SC = CBA_COMPUTE_SIZE_CHANGES(T, SIZE, TOID) computes the size
%   changes from the time T, size data SIZE, and touched object id 
%   data TOID.  SC is a n x 2 matrix of start and end times for
%   object touches which are size changes

%   $Id: cba_compute_size_changes.m,v 1.2 2001/08/15 16:50:34 pskirko Exp $
%   pskirko 8.14.01

function size_changes = cba_compute_size_changes(t, o_size, toid)

n = length(t);

%size_changes = zeros(n,1);
size_changes = []; idx = 1;

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
	size_changes(idx,:) = [t(start_touch), t(i)];%go one past
	idx = idx+1;
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
