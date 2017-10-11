function tmp  = baufix_plot(segments, type, xy_average, dataFile)

global Piece1 Piece2 Piece3 Piece4;

figure(2)

if(isempty(segments))&(strcmp(type, 'legend'))

    % My hack for legend creation since the
    % legend function wants to label all data points

    temp1 = [0 0 0 0]';

    %specifies label colors for regions 0-12

    fill(temp1, temp1, [ 0   1   0]);  hold on;
    fill(temp1, temp1, [ 0   0   1]);  hold on;
    fill(temp1, temp1, [1    1   0]);  hold on;
    fill(temp1, temp1, [.5    .9   .9]);  hold on;
    fill(temp1, temp1, [.75  0 .75]); hold on;
    fill(temp1, temp1, [.75 .95 .5]); hold on;
    fill(temp1, temp1, [0   .75 .75]); hold on;
    fill(temp1, temp1, [.5  .5  .5]); hold on;
    fill(temp1, temp1, [ 1   0   0]);  hold on;
    fill(temp1, temp1, [.5   0  .1]);  hold on;
    fill(temp1, temp1, [ 1  .8  .4]);  hold on;
    fill(temp1, temp1, [ 1  .5   0]);  hold on;
    fill(temp1, temp1, [.1  .1  .1]);  hold on;
    legend('Piece 1',...
        'Piece 2',...
        'Piece 3', ...
        'Piece 4',...
        'Nuts',...
        'Bolts', ...
        'Work Space',...
        'Put Down Area',...
        'Distractor 1',...
        'Distractor 2',...
        'Distractor 3', ...
        'Distractor 4',...
        'Unidentified');

    Piece1 = 2;
    Piece2 = 3;
    Piece3 = 5;
    Piece4 = 8;

    set(gca, 'YTickLabel', ['LH Reaches'; 'Fixations '; 'RH Reaches';]);
    set(gca, 'YTick', [0.5 1.5 2.5 ]);
    %3.5 4.5]);
    xlabel('Seconds');

    hold on;
    return

elseif(strcmp(type, 'fix'))    y = [ 1 1 2 2 ]'; column = 5;
elseif(strcmp(type, 'fix'))    y = [ 1 1 2 2 ]'; column = 5;
elseif(strcmp(type, 'lhand'))  y = [ 0 0 1 1 ]'; column = 4;
elseif(strcmp(type, 'rhand'))  y = [ 2 2 3 3 ]'; column = 4;
    %  elseif(strcmp(type, 'head'))  y = [ 3 3 4 4 ]'; column = 4;
    %  elseif(strcmp(type, 'head2'))  y = [ 4 4 5 5 ]'; column = 3;
end

% Now, Plot the fixations with colors for each scene plane
for i = 1:length(segments);

    x = [segments(i,1) segments(i,2) segments(i,2) segments(i,1)]';

    switch segments(i, column)

        case 0,  color = [.1 .1 .1];
        case 1,  color = [ 1  0  0];
        case 2,  color = [ 0  1  0];
        case 3,  color = [ 0  0  1];
        case 4,  color = [.5  0 .1];
        case 5,  color = [ 1  1  0];
        case 6,  color = [ 1  .8 .4];
        case 7,  color = [ 1 .5  0];
        case 8,  color = [ .5 .9 .9];
        case 9,  color = [.75 0 .75];
        case 10, color = [.75 .95 .5];
        case 11, color = [0 .75 .75];
        case 12, color = [.5 .5 .5];
    end


    % if (segments(i, column) == Piece1)|(segments(i, column) == Piece2)|...
    %(segments(i, column) == Piece3)|(segments(i, column) == Piece4)|...
    %(segments(i, column) == 12)|(segments(i, column) == 9)|(segments(i, column) == 10)


    h = fill(x, y, color);
    hold on;
    %else hold on;
    % end
end




if(strcmp(type, 'fix_plot'))

    %   %show raw eye x & y
    %     figure(2)
    %     plot(ScenePlaneXY(:,1), -ScenePlaneXY(:,2), '+');
    %     hold on;



    figure(3);

    for i = 1:length(xy_average)
        %show eye fixation x & y

        if xy_average(i,3) == 1
            plot(xy_average(i,1), xy_average(i,2), 'r*');
            hold on;

        elseif xy_average(i,3) == 2
            plot(xy_average(i,1), xy_average(i,2), 'k*');
            hold on;

        elseif xy_average(i,3) == 3
            plot(xy_average(i,1), xy_average(i,2), 'g*');
            hold on;

        elseif xy_average(i,3) == 4
            plot(xy_average(i,1), xy_average(i,2), 'co');
            hold on;

        elseif xy_average(i,3) == 5
            plot(xy_average(i,1), xy_average(i,2), 'mo');
            hold on;

        elseif xy_average(i,3) == 6
            plot(xy_average(i,1), xy_average(i,2), 'c*');
            hold on;

        elseif xy_average(i,3) == 7
            plot(xy_average(i,1), xy_average(i,2), 'm*');
            hold on;

        elseif xy_average(i,3) == 8
            plot(xy_average(i,1), xy_average(i,2), 'ro');
            hold on;

        elseif xy_average(i,3) == 9
            plot(xy_average(i,1), xy_average(i,2), 'ko');
            hold on;

        elseif xy_average(i,3) == 10
            plot(xy_average(i,1), xy_average(i,2), 'go');
            hold on;

        elseif xy_average(i,3) == 11
            plot(xy_average(i,1), xy_average(i,2), 'rd');
            hold on;

        elseif xy_average(i,3) == 12
            plot(xy_average(i,1), xy_average(i,2), 'bo');
            hold on;

        elseif xy_average(i,3) == 0
            plot(xy_average(i,1), xy_average(i,2), 'b*');
            hold on; end

    end
    set(gca, 'Xlim', [-850 850]);
    set(gca, 'Ylim', [-500 500]);
    hold on

    table = [605 300; 605 -300; -605 -300; -605 300; 605 300];
    plot(table(:,1),table(:,2))
    hold off;

end

return









