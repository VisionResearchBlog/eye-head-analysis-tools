%COMPUTE_MS2TC millisecond -> timecode
%   TC = COMPUTE_MS2TC(MS) converts the millisecond value in MS in
%   a timecode value TC, (e.g. 1000 -> [0, 0, 1, 0])

% $Id: compute_ms2tc.m,v 1.2 2001/08/16 19:04:55 pskirko Exp $
% pskirko 8.16.01

function tc = compute_ms2tc(ms_in)

  ms = ms_in;
    
  ms_f = mod(round(ms),1000);
  tc_f = 0.03*ms_f;  
  ms   = ms - ms_f;
  
  ms_s = mod(round(ms), 60000);
  tc_s = 0.001*ms_s;
  ms   = ms - ms_s;

  ms_m = mod(round(ms), 3600000);
  tc_m = (1.666666e-5)*ms_m;
  ms   = ms - ms_m;

  tc_h = 2.777777e-7*ms;

  tc = [tc_h tc_m tc_s tc_f]; 


