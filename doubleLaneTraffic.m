function doubleLaneTraffic(vmax, lanes, density, roadLen, rounds, randomPos, RandomLane, pHesitationMax)
%doubleLaneTraffic traffic simulation as per nagel-schreckenberg model
%(double lane).

    L = 1;  % define lane 1 as left
    R = 2;  % define lane 2 as right
    
    cellToKmh = 27;  % 1 = 27 km/h
    [cars, road] = getCars(density, lanes, roadLen, randomPos, RandomLane, pHesitationMax);
    roadGap = roadLen * (2/35);  %dependant on ratio to road length

    displayRoadMap = true;
    roadMapTrace = zeros(2, roadLen);
    roadMapTrace(1:2, :) = road(1:2, :);

    % -- Initialize plot --
    figure('Name','Cellular Automaton','NumberTitle','off')
    title({'Traffic simulation as per Nagel-Schreckenberg model'},{'(double lane)'});
    description = ['cells=', num2str(roadLen), ', rounds=', num2str(rounds),', density=', num2str(density), ', pmax=', num2str(pHesitationMax), ', vmax=', num2str(vmax)];

    xlim([0, roadLen]);
    ylim([-(roadLen), roadLen]);
    hold on
    plot([0, roadLen], [0, 0], '--k')
    plot([0, roadLen], [roadGap, roadGap], '--k')
    for j = 1:length(cars)
        if cars(j).lane == L
            y = roadGap;
        else
            y = 0;
        end
        cars(j).plot = plot(cars(j).pos -0.5, y, 'Color', cars(j).color, 'marker', 'o', 'LineWidth', 1);
        cars(j).plot.DataTipTemplate.DataTipRows(1) = dataTipTextRow('Id', repmat({cars(j).id},numel('XData'),1));
        cars(j).plot.DataTipTemplate.DataTipRows(2) = dataTipTextRow('P(tr)', repmat({round(cars(j).pHesitation,2)},numel('XData'),1));
        cars(j).plot.ZData = cars(j).speed * cellToKmh;
        cars(j).plot.DataTipTemplate.DataTipRows(3) = dataTipTextRow('km/h', 'ZData');
    end
    hold off
    axis([0 roadLen -roadLen roadLen]);
    xlabel({description});
    yticklabels({''});
    %---------------------
    
    disp("-- Press key to start simulation --")
    pause();

    for n=1:rounds
        newPositions = zeros(2, roadLen);
        for j = 1:length(cars)
            % -- step 1: increase speed if speed < vmax
            if cars(j).speed < vmax 
                cars(j).speed = cars(j).speed + 1;
            end

            % -- step 2: slow down if gap is not big enough
            reduceSpeedTo = cars(j).speed;
            oldLane = cars(j).lane;
            laneSwitchingAllowed = true;
            for s = 1 : cars(j).speed
                nextPos = cars(j).pos + s;
                if nextPos > roadLen
                    nextPos = nextPos - roadLen;
                end
                curPos = nextPos - 1;
                if nextPos == 1
                    curPos = roadLen;
                end
                if cars(j).lane == R
                    if road(R, nextPos)
                        if road(L, nextPos) || road(L, curPos)
                            reduceSpeedTo = (s-1);
                            break;
                        else
                            if laneSwitchingAllowed
                                cars(j).lane = L;
                                laneSwitchingAllowed = false;
                            end
                        end
                    end
                else
                    if road(L, nextPos)
                        reduceSpeedTo = (s-1);
                        break;
                    end
                    if s == cars(j).speed && ~road(R, curPos) && ~road(R, nextPos) && laneSwitchingAllowed
                        cars(j).lane = R;
                        laneSwitchingAllowed = false;
                    end
                end
            end
            cars(j).speed = reduceSpeedTo;

            % -- step 3: factor in hesitation probability
            if cars(j).speed > 0 && cars(j).pHesitation > rand()
                cars(j).speed = cars(j).speed - 1;
            end

            % -- step 4: move all cars to new position
%             road(oldLane, cars(j).pos) = 0;
            if cars(j).pos + cars(j).speed > roadLen
                cars(j).pos = cars(j).pos +  cars(j).speed - roadLen;
            else
                cars(j).pos = cars(j).pos +  cars(j).speed;
            end
%             road(cars(j).lane, cars(j).pos) = 1;
            newPositions(cars(j).lane, cars(j).pos) = 1;
            
            % -- draw:
            if cars(j).lane == L
                cars(j).plot.XData = cars(j).pos-0.5;
                cars(j).plot.YData = roadGap;
            else
                cars(j).plot.XData = cars(j).pos-0.5;
                cars(j).plot.YData = 0;
            end
            cars(j).plot.ZData = cars(j).speed * cellToKmh;
        end
        road = newPositions;
        roadMapTrace((length(roadMapTrace(:, 2))+1):(length(roadMapTrace(:, 2))+2), :) = road(1:2, :);
        drawnow
        pause(0.2);
    end
    if displayRoadMap
    %     pause();
        figure('Name','Cellular Automaton','NumberTitle','off');
        imshow(~roadMapTrace, 'InitialMagnification', 'fit');
        title(['traffic progression map:', {['(', description, ')']}, {''}]);
        % resized = imresize(~roadMapTrace, 9);
        % imwrite(resized,'roadMapTrace.png')
    end
end

