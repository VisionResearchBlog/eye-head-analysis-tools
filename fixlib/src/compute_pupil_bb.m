
%**************************************************************
%*      compute_pupil_bb
%*
%*      computes square bounding box for pupil, plus a little
%*      padding
%*      
%* 
%*      pskirko 7.10.01
%**************************************************************

function bb = compute_pupil_bb(pupil)

tmp = max(pupil);
tmp = 1.1*tmp;
bb = [-tmp, tmp];