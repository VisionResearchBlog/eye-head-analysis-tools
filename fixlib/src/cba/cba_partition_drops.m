%sorts drops according to size change/no size change condition

function [w_change, wo_change ] = cba_partition_drops(drops, 	size_changes)

if(isempty(size_changes))
  w_change = [];
  wo_change = drops;
  return;
end

if(isempty(drops))
  w_change = [];
  wo_change = [];
  return;
end

%need to shift drops slightly to left..hack
%drops = drops - 50;

n_drops = size(drops,1);
n_ch = size(size_changes,1);

%find drops occurring within a size change
%watch matrix power! no for loops!

dropmat = repmat(drops', [n_ch, 1]);

startmat = repmat(size_changes(:,1), [1, n_drops]);
endmat = repmat(size_changes(:,2), [1, n_drops]);

cond1 = dropmat >= startmat;
cond2 = dropmat <= endmat;

result = cond1 & cond2;

% take all drops with a 1 in the row

result = sum(result,1);

w_change = drops(find(result' ~= 0));
wo_change = drops(find(result' == 0));
