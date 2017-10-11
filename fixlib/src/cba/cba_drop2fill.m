function fills = cba_drop2fill(drops, width)

% tmp hack
%if length(width) > 1 width = width(1); end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cba_drop2fill.m
%
% converts drop times into time durations
% so they can be visualized w/ browser prog.
%
% INPUTS:
%
% OUTPUTS: 
%
%
% pskirko 6.13.01
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radius  = width/2;

fills = [(drops - radius) (drops + radius)];
