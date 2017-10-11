%STP_SHIFT_TIME shifts time to start at 0

% $Id: stp_shift_time.m,v 1.1 2001/08/15 16:36:04 pskirko Exp $
% pskirko 8.15.01

function t = stp_shift_time(t_in)

t = t_in - t_in(1);
