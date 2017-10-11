% add 2 tc

function tc3 = compute_tcadd(tc1, tc2)

h1 = tc1(1);
m1 = tc1(2);
s1 = tc1(3);
f1 = tc1(4);

h2 = tc2(1);
m2 = tc2(2);
s2 = tc2(3);
f2 = tc2(4);

h3 = 0;
m3 = 0;
s3 = 0;
f3 = 0;

tmp = f1+f2;
f3 = mod(tmp, 30);
if tmp/30 > 1
s3 = 1;
end

tmp = s1 + s2;
s3 = s3 + mod(tmp, 60);
if tmp/60 > 1
m3 = 1;
end

tmp = m1 + m2;
m3 = m3 + mod(tmp, 60);
if tmp/60 > 1
h3 = 1;
end

tmp = h1 + h2;
h3 = h3 + mod(tmp, 24); %?? or 12??

tc3 = [h3 m3 s3 f3];
