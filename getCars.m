function [carList, road] = getCars(density, lanes, roadLen, randomPos, randomLane, pHesitationMax)
%getCars returns a list of 'car' objects.
    L = 1;
    R = 2;

    carList = [];
    road = zeros(2, roadLen);

    for j = 1:density
        if lanes == 1 && j >= roadLen
            %can't have more cars than size of the road
            break;
        elseif lanes == 2 && j >= roadLen*2
            break;
        end

        while 1
            lane = R;
            if randomLane
                lane = round(rand()*1)+1;
            end
            pos = j;
            if randomPos
                pos = round(rand()*(roadLen-1), 0)+1;
            end

            if ~road(lane, pos)
                break;
            end

        end

        % update road positions
        road(lane, pos) = 1;

        % add car to list
        rgb = rand(1,3);
        carList = [carList struct('id', j, 'lane', lane, 'pos', pos, 'speed', 0, 'pHesitation', rand()*pHesitationMax, 'color', rgb, 'plot', 0)];
    end
end
