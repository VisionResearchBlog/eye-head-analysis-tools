%FAST_SAVE saves data to MAT file
%   FAST_SAVE(FILENAME, ALL) saves the ALL matrix to the file
%   FILENAME (EXCLUDING the .mat suffix). 
%  
%   used in conjunction with FAST_LOAD

% $Id: fast_save.m,v 1.2 2001/08/16 19:05:10 pskirko Exp $
% pskirko 8.16.01

function fast_save(filename, ALL)

% saves ALL as MAT file for quick retrieval

save([filename, '.mat'], 'ALL');