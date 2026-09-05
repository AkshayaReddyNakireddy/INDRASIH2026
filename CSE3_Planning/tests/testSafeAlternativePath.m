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
% CREATE TEST OBSTACLE
% ============================================================
%
% Coordinate system:
%
% X = forward distance (m)
% Y = lateral distance (m)
%
% This obstacle blocks the CENTER path.
% LEFT and RIGHT should remain available.
%
% =============================================================

obstacles(1).TrackID = 1;
obstacles(1).Position = [25 0];

%% ============================================================
% DISPLAY TEST INFORMATION
% ============================================================

disp("========================================");
disp("       SAFE ALTERNATIVE PATH TEST");
disp("========================================");

disp("Number of Obstacles:");
disp(length(obstacles));

disp("========================================");

%% ============================================================
% COLLISION CHECKING
% ============================================================

for i = 1:length(paths)

    [collision, clearance] = ...
        checkPathCollision( ...
        paths(i), ...
        obstacles, ...
        vehicle);

    %% Store results

    paths(i).collision = collision;

    paths(i).minimumClearance = clearance;

    %% Calculate path cost

    paths(i).cost = calculatePathCost(paths(i));

    %% Display result

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
% ============================================================

[selectedPath, selectedIndex] = ...
    selectBestPath(paths);

%% ============================================================
% DETERMINE DECISION
% ============================================================

if selectedIndex == 0

    decision = "STOP";
    targetSpeed = vehicle.stop_speed;

else

    switch selectedPath

        case "LEFT"

            decision = "AVOID";
            targetSpeed = vehicle.avoid_speed;

        case "RIGHT"

            decision = "AVOID";
            targetSpeed = vehicle.avoid_speed;

        case "CENTER"

            decision = "CRUISE";
            targetSpeed = vehicle.cruise_speed;

        otherwise

            decision = "STOP";
            targetSpeed = vehicle.stop_speed;

    end

end

%% ============================================================
% FINAL RESULT
% ============================================================

disp("========================================");
disp("       SAFE ALTERNATIVE RESULT");
disp("========================================");

disp("Selected Path:");
disp(selectedPath);

disp("Selected Path Index:");
disp(selectedIndex);

disp("Decision:");
disp(decision);

disp("Target Speed (km/h):");
disp(targetSpeed);

%% ============================================================
% SAFETY STATUS
% ============================================================

if selectedIndex == 0

    disp("========================================");
    disp("WARNING: NO SAFE PATH");
    disp("ACTION: STOP VEHICLE");
    disp("========================================");

else

    disp("========================================");
    disp("SAFE ALTERNATIVE PATH FOUND");
    disp("========================================");

    disp("Vehicle can continue using:");
    disp(selectedPath);

end

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

%% Obstacle

plot( ...
    obstacles(1).Position(1), ...
    obstacles(1).Position(2), ...
    'ko', ...
    'MarkerSize', 10, ...
    'LineWidth', 2);

%% Selected path

if selectedIndex > 0

    plot( ...
        paths(selectedIndex).x, ...
        paths(selectedIndex).y, ...
        'LineWidth', 4);

end

%% Labels

xlabel("Forward Distance (m)");

ylabel("Lateral Position (m)");

title("CSE3 Safe Alternative Path Planning");

legend( ...
    "LEFT", ...
    "CENTER", ...
    "RIGHT", ...
    "Obstacle", ...
    "Selected Path", ...
    "Location", "best");

hold off;