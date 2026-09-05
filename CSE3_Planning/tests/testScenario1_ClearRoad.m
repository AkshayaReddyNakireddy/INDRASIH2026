clc;
clear;
close all;

disp("========================================");
disp("       SCENARIO 1 - CLEAR ROAD");
disp("========================================");

%% Vehicle parameters

vehicle = vehicleParameters();

%% No obstacles

objects = [];

%% Decision input

decisionInput.CriticalTrackID = 0;
decisionInput.CriticalClassID = 0;
decisionInput.TTC = Inf;
decisionInput.RiskLevel = 0;
decisionInput.LateralOffset = Inf;
decisionInput.ObjectPosition = [Inf Inf];
decisionInput.ObjectVelocity = [0 0];

%% Decision

decision = decisionLogic(decisionInput);

%% Candidate paths

paths = generateCandidatePaths(vehicle);

%% Check that all paths are safe

for i = 1:length(paths)

    [collision, clearance] = ...
        checkPathCollision(paths(i), objects, vehicle);

    paths(i).collision = collision;
    paths(i).minimumClearance = clearance;

    paths(i).cost = calculatePathCost(paths(i));

end

%% Select best path

[selectedPath, selectedIndex] = ...
    selectBestPath(paths);

%% Expected behavior

expectedDecision = "CRUISE";
expectedPath = "CENTER";

%% Verify decision

if decision ~= expectedDecision
    error("FAIL: Expected CRUISE decision.");
end

%% Verify path

if selectedPath ~= expectedPath
    error("FAIL: Expected CENTER path.");
end

%% Final result

disp("========================================");
disp("       SCENARIO 1 VERIFICATION");
disp("========================================");

disp("Decision:");
disp(decision);

disp("Selected Path:");
disp(selectedPath);

disp("Target Speed (km/h):");
disp(vehicle.cruise_speed);

disp("========================================");
disp("SCENARIO 1 - CLEAR ROAD PASSED");
disp("========================================");