%% Test Collision Risk

clc;
clear;

%% Reset tracker

clear objectTracker;

%% Ego vehicle

egoState.Position = [100 100];
egoState.Velocity = [0 0];
egoState.Heading = 0;

%% Frame 1

detections(1).Frame = 1;
detections(1).ClassID = 1;
detections(1).Confidence = 0.95;
detections(1).BoundingBox = [200 100 50 50];

tracks1 = objectTracker(detections);

%% Frame 2

detections(1).Frame = 2;
detections(1).ClassID = 1;
detections(1).Confidence = 0.95;
detections(1).BoundingBox = [150 100 50 50];

tracks2 = objectTracker(detections);

%% Frame 3

detections(1).Frame = 3;
detections(1).ClassID = 1;
detections(1).Confidence = 0.95;
detections(1).BoundingBox = [120 100 50 50];

tracks3 = objectTracker(detections);

%% Prediction

predictionTime = [0.5 1.0 1.5 2.0];

predictions = trajectoryPredictor( ...
    tracks3, predictionTime);

%% Collision risk

riskAssessment = collisionRisk( ...
    tracks3, predictions, egoState);

%% Display results

disp("Track ID:");
disp(riskAssessment.TrackID);

disp("TTC:");
disp(riskAssessment.TTC);

disp("Risk Level:");
disp(riskAssessment.RiskLevel);