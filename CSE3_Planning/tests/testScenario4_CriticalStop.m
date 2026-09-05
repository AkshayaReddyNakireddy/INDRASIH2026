clc;
clear;
close all;

disp("========================================");
disp("       SCENARIO 4 - CRITICAL STOP");
disp("========================================");

%% Vehicle parameters

vehicle = vehicleParameters();

%% Critical object

objects(1).TrackID = 1;
objects(1).ClassID = 1;
objects(1).Position = [10 0];
objects(1).Velocity = [-20 0];

%% Critical decision input

decisionInput.CriticalTrackID = 1;
decisionInput.CriticalClassID = 1;

% Very low TTC
decisionInput.TTC = 1.0;

% Critical risk level
decisionInput.RiskLevel = 3;

decisionInput.LateralOffset = 0;
decisionInput.ObjectPosition = [10 0];
decisionInput.ObjectVelocity = [-20 0];

%% Run decision logic

decision = decisionLogic(decisionInput);

%% Expected result

expectedDecision = "STOP";

if decision ~= expectedDecision
    error("FAIL: Expected STOP decision.");
end

%% Display verification

disp("========================================");
disp("       SCENARIO 4 VERIFICATION");
disp("========================================");

disp("Decision:");
disp(decision);

disp("TTC (s):");
disp(decisionInput.TTC);

disp("Risk Level:");
disp(decisionInput.RiskLevel);

disp("Target Speed (km/h):");
disp(vehicle.stop_speed);

disp("========================================");
disp("SCENARIO 4 - CRITICAL STOP PASSED");
disp("========================================");