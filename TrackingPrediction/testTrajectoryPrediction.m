%% Test Trajectory Prediction

clc;
clear;

% Reset tracker
clear objectTracker;

%% Create test detection - Frame 1

detections(1).Frame = 1;
detections(1).ClassID = 1;
detections(1).Confidence = 0.95;
detections(1).BoundingBox = [100 100 50 50];

tracks1 = objectTracker(detections);

%% Frame 2

detections(1).Frame = 2;
detections(1).ClassID = 1;
detections(1).Confidence = 0.94;
detections(1).BoundingBox = [110 105 50 50];

tracks2 = objectTracker(detections);

%% Frame 3

detections(1).Frame = 3;
detections(1).ClassID = 1;
detections(1).Confidence = 0.93;
detections(1).BoundingBox = [120 110 50 50];

tracks3 = objectTracker(detections);

%% Prediction times

predictionTime = [0.5 1.0 1.5 2.0];

%% Predict trajectory

predictions = trajectoryPredictor(tracks3, predictionTime);

%% Display result

disp("Current Position:");
disp(tracks3.Position);

disp("Current Velocity:");
disp(tracks3.Velocity);

disp("Predicted Time:");
disp(predictions.PredictedTime);

disp("Predicted Trajectory:");
disp(predictions.Trajectory);