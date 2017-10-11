% should be deprecated and replaced with new_fix_expert_struct

function fs = cba_new_fix_expert_struct(ms_start_of_data, ...
					filename);

if nargin < 2 filename = []; end

fs = struct('type', 'expert', 'ms_start_of_data', ms_start_of_data, ...
	    'filename', filename, 'name', []);