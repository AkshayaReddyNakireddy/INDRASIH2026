clc;
clear;
close all;

disp("========================================");
disp("       SCENARIO 3 - AVOID OBSTACLE");
disp("========================================");

%% Vehicle parameters

vehicle = vehicleParameters();

%% Obstacle in CENTER path

objects(1).TrackID = 1;
objects(1).ClassID = 5;
objects(1).Position = [25 0];
objects(1).Velocity = [0 0];

%% Decision input

decisionInput.CriticalTrackID = 1;
decisionInput.CriticalClassID = 5;
decisionInput.TTC = 3.0;
decisionInput.RiskLevel = 2;
decisionInput.LateralOffset = 0;
decisionInput.ObjectPosition = [12 0];
decisionInput.ObjectVelocity = [0 0];

%% Decision

decision = decisionLogic(decisionInput);

%% Generate candidate paths

paths = generateCandidatePaths(vehicle);

%% Check obstacle against every candidate path

for i = 1:length(paths)

    [collision, clearance] = ...
        checkPathCollision(paths(i), objects, vehicle);

    paths(i).collision = collision;
    paths(i).minimumClearance = clearance;

    paths(i).cost = calculatePathCost(paths(i));

end

%% Select best safe path

[selectedPath, selectedIndex] = ...
    selectBestPath(paths);

%% Expected decision

expectedDecision = "AVOID";

%% Verify decision

if decision ~= expectedDecision
    error("FAIL: Expected AVOID decision.");
end

%% Verify that CENTER is blocked

if ~paths(2).collision
    error("FAIL: CENTER path should be blocked by the obstacle.");
end

%% Verify that a side path is selected

if selectedIndex == 2 || selectedIndex == 0
    error("FAIL: A safe side path should be selected.");
end

%% Final result

disp("========================================");
disp("       SCENARIO 3 VERIFICATION");
disp("========================================");

disp("Decision:");
disp(decision);

disp("Selected Path:");
disp(selectedPath);

disp("Target Speed (km/h):");
disp(vehicle.avoid_speed);

disp("========================================");
disp("SCENARIO 3 - AVOID OBSTACLE PASSED");
disp("========================================");