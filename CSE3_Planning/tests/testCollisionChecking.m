clc;
clear;
close all;

%% Load vehicle parameters

vehicle = vehicleParameters();

%% Generate candidate paths

paths = generateCandidatePaths(vehicle);

%% ============================================================
% CREATE TEST OBSTACLE
% =============================================================
%
% Coordinate system:
% X = forward distance (m)
% Y = lateral distance (m)
%
% This obstacle is placed in the CENTER path.

obstacles(1).TrackID = 1;
obstacles(1).Position = [25 0];

%% ============================================================
% CHECK ALL THREE PATHS
% =============================================================

disp("========================================");
disp("       COLLISION CHECKING");
disp("========================================");

for i = 1:length(paths)

    [collision, clearance] = ...
        checkPathCollision(paths(i), obstacles, vehicle);

    paths(i).collision = collision;
    paths(i).minimumClearance = clearance;

    disp("Path:");
    disp(paths(i).name);

    disp("Collision:");

    if collision
        disp("YES");
    else
        disp("NO");
    end

    disp("Minimum Clearance (m):");
    disp(clearance);

    disp("----------------------------------------");

end

%% ============================================================
% PLOT
% =============================================================

figure;
hold on;
grid on;

plot(paths(1).x, paths(1).y, 'LineWidth', 2);
plot(paths(2).x, paths(2).y, 'LineWidth', 2);
plot(paths(3).x, paths(3).y, 'LineWidth', 2);

%% Plot obstacle

plot( ...
    obstacles(1).Position(1), ...
    obstacles(1).Position(2), ...
    'ko', ...
    'MarkerSize', 10, ...
    'LineWidth', 2);

xlabel("Forward Distance (m)");
ylabel("Lateral Position (m)");

title("CSE3 Collision Checking");

legend( ...
    "LEFT", ...
    "CENTER", ...
    "RIGHT", ...
    "Obstacle", ...
    "Location", "best");

hold off;