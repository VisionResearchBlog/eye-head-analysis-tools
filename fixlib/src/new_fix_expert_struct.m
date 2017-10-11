%NEW_FIX_EXPERT_STRUCT initialize expert fix struct
%   FS = NEW_FIX_EXPERT_STRUCT initializes the expert struct.
%   
%   WARNING: there is also cba_new_fix_expert_struct, which I think
%            should be destroyed in favor of this, since it doesn't 
%            offer any extra functionality.
%
%   This struct encapsulates parameters for loading fixations from
%   an "expert file".  Note this is not the same as a ".fix" file,
%   the latter being produced by computers.  Each experiment has
%   its own expert file format.
%  
%          - data_type            
%               type: ?
%               vestigial, I think.
%          - filename
%               type: filename
%               the file to load
%          - ms_offset
%               type: scalar
%               this value (in ms) is added to all the fixation
%               values (which are also in ms) in order to offset
%               them by some amount, hence offset
%          - name 
%               type: text
%               can't remember what this does, probably vestigial
%          - type 
%               always: 'expert'

% $Id: new_fix_expert_struct.m,v 1.2 2001/08/16 19:05:25 pskirko Exp $
% pskirko 7.5.01

function fs = new_fix_expert_struct(filename)

if nargin == 0 filename = []; end

fs = struct('type', 'expert', 'filename', filename, 'name', [], ...
	    'data_type', [], 'ms_offset', 0);