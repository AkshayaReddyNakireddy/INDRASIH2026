clc;
clear;
close all;

%% Load vehicle parameters

vehicle = vehicleParameters();

%% Generate candidate paths

paths = generateCandidatePaths(vehicle);

%% ============================================================
% TEST OBSTACLE
% =============================================================

obstacles(1).TrackID = 1;
obstacles(1).Position = [25 0];

%% ============================================================
% COLLISION CHECKING
% =============================================================

for i = 1:length(paths)

    [collision, clearance] = ...
        checkPathCollision(paths(i), obstacles, vehicle);

    paths(i).collision = collision;
    paths(i).minimumClearance = clearance;

end

%% ============================================================
% SELECT BEST PATH
% =============================================================

[selectedPath, selectedIndex] = selectBestPath(paths);

%% ============================================================
% DISPLAY ALL PATHS
% =============================================================

disp("========================================");
disp("       FINAL PATH EVALUATION");
disp("========================================");

for i = 1:length(paths)

    disp("Path:");
    disp(paths(i).name);

    disp("Collision:");

    if paths(i).collision
        disp("YES");
    else
        disp("NO");
    end

    disp("Minimum Clearance:");
    disp(paths(i).minimumClearance);

    disp("----------------------------------------");

end

disp("Selected Path:");
disp(selectedPath);

disp("Selected Path Index:");
disp(selectedIndex);

disp("========================================");