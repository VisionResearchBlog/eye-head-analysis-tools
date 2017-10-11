%CBA_SHIFT_TIME shifts time to ms starting at 0
%   T2 = CBA_SHIFT_TIME(T) converts T from sec. to ms, puts the 
%   result in T2, then shifts T2 so that T2(1) = 0

function t = cba_shift_time(t_in)

t = t_in;
t = t.*1000; 
t = t - t(1);
