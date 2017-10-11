%COMPUTE_PLOTTABLE_CENTROID prepare centroids for eyeviz
%   CENTROID = COMPUTE_PLOTTABLE_CENTROID(T, FIX, CENTROID_IN)
%   converts the centroids for the fixations FIX into the "point
%   struct"-style format used by eyeviz.  see cba_run.m for an example.
%
%   WARNING! code currently only works with 2-dimensional centroids (x,y)

% $Id: compute_plottable_centroid.m,v 1.2 2001/08/16 19:04:57 pskirko Exp $
% pskirko 8.16.01

function centroid_out = compute_plottable_centroid(t, fix, centroid)

% makes centroids usable in eyeviz
n = length(t);

if(isempty(fix))
  centroid_out = NaN.*ones(n, 2); % 2 is sorta a hack
  return;
end

m = size(centroid,2);
centroid_out = NaN.*ones(n, m);

for i=1:n
  % look for valid centroid 
  curr_t = t(i);
  tmp = (curr_t >= fix(:,1)) & (curr_t <= fix(:,2));
  tmp = find(tmp);
  
  if(~isempty(tmp)) % found centroid
    idx = min(tmp);
    centroid_out(i,:) = [centroid(idx, 1:m)]; 
  end
  
end
