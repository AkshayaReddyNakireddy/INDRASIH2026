clc;
clear;
close all;

%% ============================================================
% LOAD VEHICLE PARAMETERS
% =============================================================

vehicle = vehicleParameters();

%% ============================================================
% GENERATE CANDIDATE PATHS
% =============================================================

paths = generateCandidatePaths(vehicle);

%% ============================================================
% CREATE MULTIPLE TEST OBSTACLES
% ============================================================
%
% Coordinate system:
%
% X = forward distance (m)
% Y = lateral distance (m)
%
% Obstacle 1 blocks CENTER
% Obstacle 2 blocks LEFT
% Obstacle 3 blocks RIGHT
%
% This scenario intentionally creates a situation where
% NO SAFE PATH is available.
%
% Expected result:
%
% LEFT   -> COLLISION
% CENTER -> COLLISION
% RIGHT  -> COLLISION
%              |
%              v
%        NO SAFE PATH
%              |
%              v
%             STOP
%
% =============================================================

obstacles(1).TrackID = 1;
obstacles(1).Position = [25 0];

obstacles(2).TrackID = 2;
obstacles(2).Position = [28 3];

obstacles(3).TrackID = 3;
obstacles(3).Position = [28 -3];

%% ============================================================
% INITIAL DECISION
% ============================================================
%
% We start with CRUISE.
% If no safe path exists, the planner will override this
% decision to STOP.
%
% =============================================================

decision = "CRUISE";
targetSpeed = vehicle.cruise_speed;

%% ============================================================
% DISPLAY TEST INFORMATION
% =============================================================

disp("========================================");
disp("       MULTI-OBSTACLE PLANNING");
disp("========================================");

disp("Number of Obstacles:");
disp(length(obstacles));

disp("Initial Decision:");
disp(decision);

disp("Initial Target Speed (km/h):");
disp(targetSpeed);

disp("========================================");

%% ============================================================
% COLLISION CHECKING
% =============================================================

for i = 1:length(paths)

    [collision, clearance] = ...
        checkPathCollision( ...
        paths(i), ...
        obstacles, ...
        vehicle);

    %% Store collision information

    paths(i).collision = collision;

    paths(i).minimumClearance = clearance;

    %% Calculate path cost

    paths(i).cost = calculatePathCost(paths(i));

    %% Display path information

    disp("Path:");
    disp(paths(i).name);

    if collision
        disp("Collision:");
        disp("YES");
    else
        disp("Collision:");
        disp("NO");
    end

    disp("Minimum Clearance (m):");
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
% SELECT BEST SAFE PATH
% =============================================================

[selectedPath, selectedIndex] = ...
    selectBestPath(paths);

%% ============================================================
% NO-SAFE-PATH SAFETY OVERRIDE
% ============================================================
%
% If selectBestPath returns index 0, it means:
%
%   LEFT   -> unsafe
%   CENTER -> unsafe
%   RIGHT  -> unsafe
%
% Therefore the vehicle must STOP.
%
% =============================================================

if selectedIndex == 0

    decision = "STOP";

    targetSpeed = vehicle.stop_speed;

else

    %% A safe path exists

    switch selectedPath

        case "LEFT"
            decision = "AVOID";
            targetSpeed = vehicle.avoid_speed;

        case "CENTER"
            decision = "CRUISE";
            targetSpeed = vehicle.cruise_speed;

        case "RIGHT"
            decision = "AVOID";
            targetSpeed = vehicle.avoid_speed;

        otherwise
            decision = "STOP";
            targetSpeed = vehicle.stop_speed;

    end

end

%% ============================================================
% FINAL RESULT
% ============================================================

disp("========================================");
disp("       MULTI-OBSTACLE RESULT");
disp("========================================");

disp("Selected Path:");
disp(selectedPath);

disp("Selected Path Index:");
disp(selectedIndex);

disp("Final Decision:");
disp(decision);

disp("Target Speed (km/h):");
disp(targetSpeed);

%% ============================================================
% SAFETY STATUS
% ============================================================

if selectedIndex == 0

    disp("========================================");
    disp("       SAFETY OVERRIDE");
    disp("========================================");

    disp("STATUS:");
    disp("NO SAFE PATH AVAILABLE");

    disp("ACTION:");
    disp("STOP VEHICLE");

    disp("========================================");

else

    disp("========================================");
    disp("       SAFE PATH FOUND");
    disp("========================================");

    disp("STATUS:");
    disp("SAFE PATH AVAILABLE");

    disp("ACTION:");
    disp("CONTINUE WITH SELECTED PATH");

    disp("========================================");

end

%% ============================================================
% PLOT CANDIDATE PATHS AND OBSTACLES
% ============================================================

figure;

hold on;
grid on;

%% Plot LEFT path

plot( ...
    paths(1).x, ...
    paths(1).y, ...
    'LineWidth', 2);

%% Plot CENTER path

plot( ...
    paths(2).x, ...
    paths(2).y, ...
    'LineWidth', 2);

%% Plot RIGHT path

plot( ...
    paths(3).x, ...
    paths(3).y, ...
    'LineWidth', 2);

%% ============================================================
% PLOT OBSTACLES
% ============================================================

for i = 1:length(obstacles)

    plot( ...
        obstacles(i).Position(1), ...
        obstacles(i).Position(2), ...
        'ko', ...
        'MarkerSize', 10, ...
        'LineWidth', 2);

end

%% ============================================================
% MARK SELECTED PATH
% ============================================================

if selectedIndex > 0

    plot( ...
        paths(selectedIndex).x, ...
        paths(selectedIndex).y, ...
        'LineWidth', 4);

end

%% ============================================================
% LABELS
% ============================================================

xlabel("Forward Distance (m)");

ylabel("Lateral Position (m)");

title("CSE3 Multi-Obstacle Path Planning");

legend( ...
    "LEFT", ...
    "CENTER", ...
    "RIGHT", ...
    "Obstacles", ...
    "Selected Path", ...
    "Location", "best");

hold off;