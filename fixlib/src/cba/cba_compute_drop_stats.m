% computes some statistics associated with incoming drop data

function [mean_number, std_number, mean_duration, std_duration] = ...
   cba_compute_drop_stats(drop_structs)

n = length(drop_structs);

number = zeros(n,1);
duration = []; %idx = 1;

for i=1:n
   drop_struct = drop_structs{i};
   fix = drop_struct.fix;
   m = size(fix, 1);
   number(i) = m;
   duration = [duration; fix(:,2) - fix(:,1)];
end

mean_number = mean(number);
std_number = std(number);

mean_duration = mean(duration);
std_duration = std(duration);

hist(duration);