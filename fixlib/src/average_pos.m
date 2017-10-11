function fix_frames = average_pos(fix_frames, raw_asl)


%step through each fixation
% for i = 1:size(fix_frames)
%     init  = fix_frames(i, 1);
%     final = fix_frames(i, 2);
%     
%     X_sum = 0; Y_sum = 0;
%     %now step through values from init to final
%     for j = init:final,
%         X_sum = raw_asl(j, 1) + X_sum;
%         Y_sum = raw_asl(j, 2) + Y_sum;
%     end
%     
%     fix_frames(i,3) = X_sum/(final-init);
%     fix_frames(i,4) = Y_sum/(final-init);
% end

for i = 1:size(fix_frames)
    fix_frames(i,3:4)= mean(raw_asl(fix_frames(i,1):fix_frames(i,2), 1:2));
end

%keyboard
return
