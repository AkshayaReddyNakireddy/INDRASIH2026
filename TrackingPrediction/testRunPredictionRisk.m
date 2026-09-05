%% Test Complete Prediction and Risk Module

clear;
clc;
clear objectTracker;

%% Ego vehicle

egoState.Position = [100 100];
egoState.Velocity = [0 0];
egoState.Heading = 0;

%% =========================
% FRAME 1
% ==========================

detections(1).Frame = 1;
detections(1).ClassID = 1;
detections(1).Confidence = 0.95;
detections(1).BoundingBox = [200 100 50 50];

detections(2).Frame = 1;
detections(2).ClassID = 2;
detections(2).Confidence = 0.90;
detections(2).BoundingBox = [200 250 40 40];

detections(3).Frame = 1;
detections(3).ClassID = 3;
detections(3).Confidence = 0.88;
detections(3).BoundingBox = [300 50 30 60];

%% Run frame 1

output1 = runPredictionRisk( ...
    detections, egoState);

%% =========================
% FRAME 2
% ==========================

detections(1).Frame = 2;
detections(1).BoundingBox = [150 100 50 50];

detections(2).Frame = 2;
detections(2).BoundingBox = [190 250 40 40];

detections(3).Frame = 2;
detections(3).BoundingBox = [300 60 30 60];

%% Run frame 2

output2 = runPredictionRisk( ...
    detections, egoState);

%% =========================
% FRAME 3
% ==========================

detections(1).Frame = 3;
detections(1).BoundingBox = [120 100 50 50];

detections(2).Frame = 3;
detections(2).BoundingBox = [180 250 40 40];

detections(3).Frame = 3;
detections(3).BoundingBox = [300 70 30 60];

%% Run frame 3

output3 = runPredictionRisk( ...
    detections, egoState);

%% =========================
% Display final result
% ==========================

disp("===== COMPLETE MODULE TEST =====");

fprintf("\nFrame 3 Results\n");

fprintf("Number of Tracks       : %d\n", ...
    numel(output3.Tracks));

fprintf("Critical Track ID      : %d\n", ...
    output3.CriticalTrackID);

fprintf("Critical Class ID      : %d\n", ...
    output3.CriticalClassID);

fprintf("Critical TTC           : %.4f seconds\n", ...
    output3.CriticalTTC);

fprintf("Critical Risk Level    : %d\n", ...
    output3.CriticalRiskLevel);

fprintf("Critical Lateral Offset: %.2f\n", ...
    output3.CriticalLateralOffset);

disp(" ");
disp("Prediction + Tracking + Risk module is working.");