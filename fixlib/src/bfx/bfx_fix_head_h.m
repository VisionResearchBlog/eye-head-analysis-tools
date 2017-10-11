function y = bfx_fix_head_h(x)

% maps head heading angle from [0, 360] to [-180, 180] where looking to right
%is positive and looking to left is negative.

% some warning

min = min(x);
max = max(x);

if min > 0 | max < 180
disp('warning: conversion probably unnecessary: check data');
end

y = mod((x+180), 360) - 180;
