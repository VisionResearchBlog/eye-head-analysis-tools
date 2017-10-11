
x = load('EyeData.mat');

figure(2030);
clf;

for i = 1:length(x.EyeInfo.subject)
    task = x.EyeInfo.subject(i).task;

    %this quivSub array has only saccade data (Nx4) setup for quiver x,y,u,v 
    %task = x.quivSub(i).task;
    
    for j = 1:length(task)
        if isempty(task(j).data)
            continue;
        end
        
        hold on;
        %since you need the difference you need to start at j==2
        samp = randi( [2 size(task(j).data, 1)], 10, 1); % plot 10 random vectors. You can try all vectors, but it's a bit messy
        
        % however even when i did all vectors it still looked like they were all pointing in the same direction.
        quiver(task(j).data(samp, 3), task(j).data(samp, 4), ...
            task(j).data(samp, 5)-task(j).data(samp-1, 5),...
            task(j).data(samp, 6)-task(j).data(samp-1, 6));
                    
        hold off;
    end
end
