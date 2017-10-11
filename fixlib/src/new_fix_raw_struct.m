%NEW_FIX_RAW_STRUCT initialize raw fix struct
%   FS = NEW_FIX_RAW_STRUCT initializes the raw struct.
%   
%   This struct encapsulates parameters for running the "fixation
%   finder" (see FIX_FINDER_VT).  It is used by some high-level
%   scripts, so you need to know what the parameters do:
%  
%          - fix
%               type: 2 x 1 matrix (e.g. [1 2; 2 5; 6 23];)
%               this is the fixation data
%          - name 
%               type: text
%               can't remember what this does, probably vestigial
%          - type 
%            always: 'raw'

% $Id: new_fix_raw_struct.m,v 1.2 2001/08/16 19:05:27 pskirko Exp $
% pskirko 7.5.01

function fs = new_fix_raw_struct(fix)

fs = struct('type', 'raw', 'name', [], 'fix', fix);