function TC=float2TC(float)
% function TC=float2TC(float)
%
% Converts floating point time to [HH,MM,SS,FF] format.
%
% pilardi 8/02

h=floor(float/3600);
m=floor(mod(float,3600)/60);
s=floor(mod(float,60));
f=floor((float-floor(float))*30);

TC=[h m s f];