clc;
clear;
close all;

%% Load vehicle parameters

vehicle = vehicleParameters();


%% Generate candidate paths

paths = generateCandidatePaths(vehicle);


%% Display path information

disp("========================================");
disp("       CANDIDATE PATH GENERATION");
disp("========================================");

for i = 1:length(paths)

    disp("Path:");
    disp(paths(i).name);

    disp("Number of trajectory points:");
    disp(length(paths(i).x));

    disp("Final lateral position:");
    disp(paths(i).y(end));

    disp("----------------------------------------");

end


%% Plot candidate paths

figure;

hold on;
grid on;

plot(paths(1).x, paths(1).y, 'LineWidth', 2);
plot(paths(2).x, paths(2).y, 'LineWidth', 2);
plot(paths(3).x, paths(3).y, 'LineWidth', 2);

xlabel("Forward Distance (m)");
ylabel("Lateral Position (m)");

title("CSE3 Candidate Trajectories");

legend( ...
    paths(1).name, ...
    paths(2).name, ...
    paths(3).name, ...
    "Location", "best");

hold off;