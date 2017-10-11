%NEW_FIX_EDITABLE_STRUCT initialize editable fix struct
%   FS = NEW_FIX_EDITABLE_STRUCT initializes the editable struct.
%   
%   This struct encapsulates parameters for loading, editing, and
%   saving ".fix" files in eyeviz.  Thus, it uses the ".fix" format
%   (see LOAD_DOT_FIX)
%  
%          - in_file
%               type: filename
%               data is initially loaded from this .fix file
%          - name 
%               type: text
%               can't remember what this does, probably vestigial
%          - out_file
%               type: filename
%               data is saved to this .fix file. If left empty, no
%               data will be saved
%          - type 
%               always: 'editable'

% $Id: new_fix_editable_struct.m,v 1.2 2001/08/16 19:05:23 pskirko Exp $
% pskirko 7.5.01

function fs = new_fix_editable_struct

fs = struct('type', 'editable', 'name', [], 'in_file', [], 'out_file', ...
	    []);