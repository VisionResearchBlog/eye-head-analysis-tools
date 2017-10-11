%FAST_LOAD load all data from MAT file
%   ALL = FAST_LOAD(FILENAME) loads the ALL matrix from the data
%   file FILENAME (EXCLUDING the .mat suffix). If load fails -1
%   returned.
%
%   used in conjunction with FAST_SAVE

% $Id: fast_load.m,v 1.3 2001/08/16 19:05:09 pskirko Exp $
% pskirko 8.16.01

function ALL = fast_load(filename)

ans = [];

try,
  ans = load([filename, '.mat']); 
catch,
  ALL = -1;  
end

if(isstruct(ans)) % load succeeded
  ALL = ans.ALL;
end