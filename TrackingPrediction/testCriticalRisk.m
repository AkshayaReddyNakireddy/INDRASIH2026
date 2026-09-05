%% Test Critical Risk Selection

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

tracks1 = objectTracker(detections);

%% =========================
% FRAME 2
% ==========================

detections(1).Frame = 2;
detections(1).BoundingBox = [150 100 50 50];

detections(2).Frame = 2;
detections(2).BoundingBox = [190 250 40 40];

detections(3).Frame = 2;
detections(3).BoundingBox = [300 60 30 60];

tracks2 = objectTracker(detections);

%% =========================
% FRAME 3
% ==========================

detections(1).Frame = 3;
detections(1).BoundingBox = [120 100 50 50];

detections(2).Frame = 3;
detections(2).BoundingBox = [180 250 40 40];

detections(3).Frame = 3;
detections(3).BoundingBox = [300 70 30 60];

tracks3 = objectTracker(detections);

%% =========================
% Prediction
% ==========================

predictionTime = [0.5 1.0 1.5 2.0];

predictions = trajectoryPredictor( ...
    tracks3, predictionTime);

%% =========================
% Collision risk
% ==========================

riskAssessment = collisionRisk( ...
    tracks3, predictions, egoState);

%% =========================
% Select critical object
% ==========================

criticalRisk = selectCriticalRisk(riskAssessment);

%% =========================
% Display result
% ==========================

disp("===== CRITICAL OBJECT =====");

fprintf("Track ID       : %d\n", ...
    criticalRisk.TrackID);

fprintf("Class ID       : %d\n", ...
    criticalRisk.ClassID);

fprintf("TTC            : %.4f seconds\n", ...
    criticalRisk.TTC);

fprintf("Risk Level     : %d\n", ...
    criticalRisk.RiskLevel);

fprintf("Lateral Offset : %.2f\n", ...
    criticalRisk.LateralOffset);