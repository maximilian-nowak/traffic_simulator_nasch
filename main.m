%main script
% set all parameters here

close all
clear all

% prompt parameter input routine
% [density, roadLen, lanes, rounds, randomPos] = inputParams();

vmax = 7;  % 5:=135 km/h

% single lane
lanes = 1;
density = 40;

% double lane
% lanes = 2;
% density = 100;


roadLen = 100;
rounds = 100;
randomPos = true;
pHesitation = 0.30;
randomLane = randomPos;

if lanes == 2
    doubleLaneTraffic(vmax, lanes, density, roadLen, rounds, randomPos, randomLane, pHesitation);
else
    singleLaneTraffic(vmax, lanes, density, roadLen, rounds, randomPos, pHesitation);
end


