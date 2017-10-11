% a drop struct manages the data associated with a particular "drop" 
% in the cba app
% pskirko 6.13.01

function drop_struct = cba_new_drop_struct(t, t_lim, fix)

drop_struct = struct('t', t, 't_win', t_lim, 'fix', fix);

