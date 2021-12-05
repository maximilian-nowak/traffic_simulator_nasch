%Hauptskript zur Steuerung der Nagel-Schreckenberg Simulation.

close all
clear all

vmax = 5;  % 5:=135 km/h
% [density, roadLen, lanes, rounds, randomPos] = inputParams();
density = 35;
roadLen = 100;
lanes = 2;
rounds = 100;
randomPos = false;
troedelMax = 0.3;
randomLane = randomPos;

if lanes == 2
    doubleLaneTraffic(vmax, lanes, density, roadLen, rounds, randomPos, randomLane, troedelMax);
else
    singleLaneTraffic(vmax, lanes, density, roadLen, rounds, randomPos, troedelMax);
end

