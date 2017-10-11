function drops = cba_compute_drops(t, touched_object_id, pick_t_thresh)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cba_compute_drops.m
%
% computes the times at which an object
% was dropped --- based on when the 
% object id switch from "not -1" to -1
%
% this ms time is currently defined as
% the time of ms code _at_ the first
% appearance of -1 (after non -1's)
%
% pick_t_thresh is a minimum time
% duration for a pick.  picks that
% are shorter than this duration are
% flattened out
%
%
% OLD DO NOT READ
% t_thresh is a time threshhold you
% can use to "clump" drops to get rid
% of transient pick/drops.  0 turns this
% feature off.
%
% the is done at an intermediate stage
% in order to get rid of "false drops"
% ie. transient drops that occur when
% the subject is in fact picking 
% something up
%
% the threshold applies to consecutive
% non-drops--- thus a long string of 
% quick pick/drops (lots of spikes)
% would be connected into one long pick
%
% the clumping interprets the data
% by removing drops where possible--thus
% the first touch is connected to the 2nd,
% removing any -1's in between
%
% the code is hackery, hope there's no 
% artifacts 
%
%
% INPUTS:
%
% OUTPUTS: 
%
%
% pskirko 6.13.01
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cool matlab tricks!

tmp1 = (touched_object_id ~= -1);

if (pick_t_thresh > 0) % clumping
   n = length(t);
   prev_drop_t = -1;
   prev_drop_idx = -1;
   is_now_pick = 0;

   for i=1:n
      curr_drop = tmp1(i);
      curr_drop_idx = i;
      if(curr_drop == 0) % this is a drop
         curr_drop_t = t(i);
         if(prev_drop_t ~= -1) % clump maybe
            if((curr_drop_t - prev_drop_t < pick_t_thresh) & ...
               (is_now_pick == 1))
               tmp1(prev_drop_idx+1:curr_drop_idx-1) = 0;
               is_now_pick = 0;
            end
         end
         prev_drop_t = curr_drop_t;
         prev_drop_idx = curr_drop_idx;
      else % curr_drop == 1 is a pick
         is_now_pick = 1;
      end
   end
end


if 0 % old code
if(t_thresh > 0) % clumping
   n = length(t);
   prev_pick_t = -1;
   prev_pick_idx = -1;

   for i=1:n
      curr_pick = tmp1(i);
      curr_pick_idx = i;
      if(curr_pick == 1) % this is a pick
         curr_pick_t = t(i);
         if(prev_pick_t ~= -1) % clump maybe
            if(curr_pick_t - prev_pick_t < t_thresh)
               tmp1(prev_pick_idx+1:curr_pick_idx-1) = 1;
            end
         end
         prev_pick_t = curr_pick_t;
         prev_pick_idx = curr_pick_idx;
      end
   end
end
end

tmp2 = [0; tmp1];
tmp1 = [tmp1; 0];

drops = t(find(((tmp2 - tmp1) == 1)));
