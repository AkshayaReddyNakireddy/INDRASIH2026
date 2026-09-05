clc;
clear;
close all;

disp("========================================");
disp("       SCENARIO 5 - NO SAFE PATH");
disp("========================================");

%% Vehicle parameters

vehicle = vehicleParameters();

%% Generate candidate paths

paths = generateCandidatePaths(vehicle);

%% Create obstacles blocking all three paths
%
% At x = 25 m the candidate paths have reached their
% final lateral positions:
%
% LEFT   ≈ +3.1 m
% CENTER =  0 m
% RIGHT  ≈ -3.1 m

objects(1).TrackID = 1;
objects(1).ClassID = 5;
objects(1).Position = [25 3.1];
objects(1).Velocity = [0 0];

objects(2).TrackID = 2;
objects(2).ClassID = 5;
objects(2).Position = [25 0];
objects(2).Velocity = [0 0];

objects(3).TrackID = 3;
objects(3).ClassID = 5;
objects(3).Position = [25 -3.1];
objects(3).Velocity = [0 0];

%% Check every candidate path

for i = 1:length(paths)

    [collision, clearance] = ...
        checkPathCollision( ...
        paths(i), ...
        objects, ...
        vehicle);

    paths(i).collision = collision;
    paths(i).minimumClearance = clearance;

    paths(i).cost = calculatePathCost(paths(i));

end

%% Select safest available path

[selectedPath, selectedIndex] = ...
    selectBestPath(paths);

%% Display path results

disp("========================================");
disp("       PATH SAFETY RESULTS");
disp("========================================");

for i = 1:length(paths)

    disp("Path:");
    disp(paths(i).name);

    disp("Collision:");
    disp(paths(i).collision);

    disp("Minimum Clearance (m):");
    disp(paths(i).minimumClearance);

    disp("----------------------------------------");

end

%% Verify all paths are blocked

if ~paths(1).collision
    error("FAIL: LEFT path should be blocked.");
end

if ~paths(2).collision
    error("FAIL: CENTER path should be blocked.");
end

if ~paths(3).collision
    error("FAIL: RIGHT path should be blocked.");
end

%% Verify no path is selected

if selectedIndex ~= 0
    error("FAIL: No safe path should be selected.");
end

if selectedPath ~= "NONE"
    error("FAIL: Selected path should be NONE.");
end

%% Final result

disp("========================================");
disp("       SCENARIO 5 VERIFICATION");
disp("========================================");

disp("Selected Path:");
disp(selectedPath);

disp("Selected Index:");
disp(selectedIndex);

disp("========================================");
disp("SCENARIO 5 - NO SAFE PATH PASSED");
disp("========================================");