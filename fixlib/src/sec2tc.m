function tc=min2tc(sec)
% function TC=float2TC(float)
%
% Converts floating point time to [HH,MM,SS,FF] format.
%
% pilardi 8/02

h=floor(min/3600);
m=floor(mod(min,3600)/60);
s=floor(mod(min,60));
f=floor((min-floor(min))*30);

TC=[h m s f]