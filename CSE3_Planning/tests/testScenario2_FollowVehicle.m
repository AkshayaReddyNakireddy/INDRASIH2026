clc;
clear;
close all;

disp("========================================");
disp("       SCENARIO 2 - FOLLOW VEHICLE");
disp("========================================");

%% Vehicle parameters

vehicle = vehicleParameters();

%% Vehicle ahead
%
% Moderate-risk vehicle directly ahead.
% It is close enough to require following,
% but TTC is not critical.

objects(1).TrackID = 1;
objects(1).ClassID = 1;
objects(1).Position = [25 0];
objects(1).Velocity = [15 0];

%% Decision input

decisionInput.CriticalTrackID = 1;
decisionInput.CriticalClassID = 1;
decisionInput.TTC = 5.0;
decisionInput.RiskLevel = 1;
decisionInput.LateralOffset = 0;
decisionInput.ObjectPosition = [25 0];
decisionInput.ObjectVelocity = [15 0];

%% Decision

decision = decisionLogic(decisionInput);

%% Candidate paths

paths = generateCandidatePaths(vehicle);

%% Check current obstacle collision

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

%% Expected behavior

expectedDecision = "FOLLOW";

%% Verify decision

if decision ~= expectedDecision
    error("FAIL: Expected FOLLOW decision.");
end

%% Final result

disp("========================================");
disp("       SCENARIO 2 VERIFICATION");
disp("========================================");

disp("Decision:");
disp(decision);

disp("Selected Path:");
disp(selectedPath);

disp("Target Speed (km/h):");
disp(vehicle.follow_speed);

disp("========================================");
disp("SCENARIO 2 - FOLLOW VEHICLE PASSED");
disp("========================================");