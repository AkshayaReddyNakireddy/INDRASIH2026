clc;
clear;
close all;

%% ============================================================
% PREDICTED TRAJECTORY COLLISION TEST
% =============================================================

disp("========================================");
disp("   PREDICTED TRAJECTORY COLLISION TEST");
disp("========================================");

%% ============================================================
% LOAD VEHICLE PARAMETERS
% ============================================================

vehicle = vehicleParameters();

%% ============================================================
% GENERATE CANDIDATE PATHS
% ============================================================

paths = generateCandidatePaths(vehicle);

%% ============================================================
% CREATE PREDICTED OBJECTS
% ============================================================

predictedObjects(1).TrackID = 1;

predictedObjects(1).Trajectory = [
    25     0
    22     0
    19     0
    16     0
    13     0
];
tracks(1).PredictedTime = [
    0
    1
    2
    3
    4
 ];

%% ============================================================
% DISPLAY OBJECT
% ============================================================

disp("Predicted Object Track ID:");
disp(predictedObjects(1).TrackID);

disp("Predicted Trajectory [X Y] (m):");
disp(predictedObjects(1).Trajectory);

disp("========================================");

%% ============================================================
% CHECK EACH CANDIDATE PATH
% ============================================================

for i = 1:length(paths)

    [collision, clearance] = ...
        checkPredictedPathCollision( ...
        paths(i), ...
        predictedObjects, ...
        vehicle, ...
        vehicle.cruise_speed);

    paths(i).collision = collision;

    paths(i).minimumClearance = clearance;

    paths(i).cost = ...
        calculatePathCost(paths(i));

    disp("Path:");
    disp(paths(i).name);

    disp("Predicted Collision:");

    if collision
        disp("YES");
    else
        disp("NO");
    end

    disp("Minimum Predicted Clearance (m):");
    disp(clearance);

    disp("Path Cost:");

    if isinf(paths(i).cost)
        disp("INF");
    else
        disp(paths(i).cost);
    end

    disp("----------------------------------------");

end

%% ============================================================
% SELECT BEST PATH
% ============================================================

[selectedPath, selectedIndex] = ...
    selectBestPath(paths);

disp("========================================");
disp("       PREDICTED PATH RESULT");
disp("========================================");

disp("Selected Path:");
disp(selectedPath);

disp("Selected Path Index:");
disp(selectedIndex);

%% ============================================================
% PLOT
% ============================================================

figure;

hold on;
grid on;

%% Candidate paths

plot( ...
    paths(1).x, ...
    paths(1).y, ...
    'LineWidth', 2);

plot( ...
    paths(2).x, ...
    paths(2).y, ...
    'LineWidth', 2);

plot( ...
    paths(3).x, ...
    paths(3).y, ...
    'LineWidth', 2);

%% Predicted trajectory

trajectory = ...
    predictedObjects(1).Trajectory;

plot( ...
    trajectory(:,1), ...
    trajectory(:,2), ...
    'ko-', ...
    'LineWidth', 2, ...
    'MarkerSize', 6);

%% Selected path

if selectedIndex > 0

    plot( ...
        paths(selectedIndex).x, ...
        paths(selectedIndex).y, ...
        'LineWidth', 4);

end

xlabel("Forward Distance (m)");

ylabel("Lateral Distance (m)");

title("Predicted Trajectory Collision Checking");

legend( ...
    "LEFT", ...
    "CENTER", ...
    "RIGHT", ...
    "Predicted Object", ...
    "Selected Path", ...
    "Location", ...
    "best");

hold off;

disp("========================================");
disp("       TEST COMPLETED");
disp("========================================");