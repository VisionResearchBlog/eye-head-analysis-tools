function TC=sgitime2TC(sgitime,local2TC_slope,local2TC_offset)
% TC=sgitime2TC(sgitime,local2TC_slope,local2TC_offset)
% 
% Converts from sgi local clock time to VCR timecode using slope and
% offset.
%
% pilardi 8/02

vcrtime=sgitime*local2TC_slope+local2TC_offset;

TC=float2TC(vcrtime);
