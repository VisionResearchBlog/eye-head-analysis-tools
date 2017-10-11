% timecodes to ms

function ms = compute_tc2ms(tc)

h = tc(1);
m = tc(2);
s = tc(3);
f = tc(4);

ms = 33.333333*f + 1000*s + 60000*m + 3600000*h;
  
