%% Test Multiple Object Tracking and Collision Risk

clear;
clc;

%% Ego vehicle

egoState.Position = [100 100];
egoState.Velocity = [0 0];
egoState.Heading = 0;

%% =========================
% FRAME 1
% ==========================

detections(1).Frame = 1;
detections(1).ClassID = 1;       % Car
detections(1).Confidence = 0.95;
detections(1).BoundingBox = [200 100 50 50];

detections(2).Frame = 1;
detections(2).ClassID = 2;       % Bike
detections(2).Confidence = 0.90;
detections(2).BoundingBox = [200 250 40 40];

detections(3).Frame = 1;
detections(3).ClassID = 3;       % Pedestrian
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
% Display tracking results
% ==========================

disp("===== MULTIPLE TRACKS =====");

for i = 1:numel(tracks3)

    fprintf("\nObject %d\n", i);

    fprintf("Track ID   : %d\n", ...
        tracks3(i).TrackID);

    fprintf("Class ID   : %d\n", ...
        tracks3(i).ClassID);

    fprintf("Position   : [%.1f %.1f]\n", ...
        tracks3(i).Position(1), ...
        tracks3(i).Position(2));

    fprintf("Velocity   : [%.1f %.1f]\n", ...
        tracks3(i).Velocity(1), ...
        tracks3(i).Velocity(2));

end

%% =========================
% Predict trajectories
% ==========================

predictionTime = [0.5 1.0 1.5 2.0];

predictions = trajectoryPredictor( ...
    tracks3, predictionTime);

%% =========================
% Calculate collision risk
% ==========================

riskAssessment = collisionRisk( ...
    tracks3, predictions, egoState);

%% =========================
% Display risk
% ==========================

disp(" ");
disp("===== COLLISION RISK =====");

for i = 1:numel(riskAssessment)

    fprintf("\nTrack ID   : %d\n", ...
        riskAssessment(i).TrackID);

    fprintf("TTC        : %.4f\n", ...
        riskAssessment(i).TTC);

    fprintf("Risk Level : %d\n", ...
        riskAssessment(i).RiskLevel);

    fprintf("Lateral Offset : %.2f\n", ...
        riskAssessment(i).LateralOffset);

end