clc;
clear;
close all;

%% ============================================================
% PREDICTION ADAPTER TEST
% =============================================================

disp("========================================");
disp("   CSE3 PREDICTION ADAPTER TEST");
disp("========================================");

%% ============================================================
% CREATE TEST TRACKS
% =============================================================

tracks(1).TrackID = 1;
tracks(1).ClassID = 1;
tracks(1).Confidence = 0.95;

% Current image position
tracks(1).Position = [145 125];

% Current image velocity
tracks(1).Velocity = [-30 0];

% TEST-ONLY predicted trajectory in metres
tracks(1).PlanningTrajectory = [
    25.0   0.0
    22.0   0.0
    19.0   0.0
    16.0   0.0
    13.0   0.0
];
tracks(1).PlanningPredictionTime = [
    0
    1
    2
    3
    4
   ];

%% ============================================================
% TRACK 2
% =============================================================

tracks(2).TrackID = 2;
tracks(2).ClassID = 2;
tracks(2).Confidence = 0.91;

tracks(2).Position = [325 167];

tracks(2).Velocity = [-15 0];

tracks(2).PlanningTrajectory = [
    35.0   2.0
    32.0   2.0
    29.0   2.0
    26.0   2.0
    23.0   2.0
];
tracks(2).PlanningPredictionTime = [
    0
    1
    2
    3
    4
 ];

%% ============================================================
% TRACK 3
% =============================================================

tracks(3).TrackID = 3;
tracks(3).ClassID = 3;
tracks(3).Confidence = 0.88;

tracks(3).Position = [522 197];

tracks(3).Velocity = [-10 0];

tracks(3).PlanningTrajectory = [
    45.0  -2.0
    43.0  -2.0
    41.0  -2.0
    39.0  -2.0
    37.0  -2.0
];
tracks(3).PlanningPredictionTime = [
    0
    1
    2
    3
    4
];
%% ============================================================
% RUN ADAPTER
% =============================================================

[predictedObjects, predictionStatus] = ...
    convertAkshayaPredictionToPlanning(tracks);

%% ============================================================
% DISPLAY STATUS
% =============================================================

disp("Total tracks:");
disp(predictionStatus.totalTracks);

disp("Converted predicted trajectories:");
disp(predictionStatus.convertedTracks);

disp("Rejected tracks:");
disp(predictionStatus.rejectedTracks);

disp("Metric prediction available:");
disp(predictionStatus.conversionAvailable);

disp("Adapter message:");
disp(predictionStatus.message);

disp("========================================");

%% ============================================================
% DISPLAY TRAJECTORIES
% =============================================================

for i = 1:length(predictedObjects)

    disp("Track ID:");
    disp(predictedObjects(i).TrackID);

    disp("Predicted trajectory [X Y] (m):");
    disp(predictedObjects(i).Trajectory);

    disp("----------------------------------------");

end

%% ============================================================
% PLOT PREDICTED TRAJECTORIES
% =============================================================

figure;

hold on;
grid on;

for i = 1:length(predictedObjects)

    trajectory = predictedObjects(i).Trajectory;

    plot( ...
        trajectory(:,1), ...
        trajectory(:,2), ...
        'LineWidth', 2);

end

xlabel("Forward Distance (m)");
ylabel("Lateral Distance (m)");

title("CSE3 Predicted Object Trajectories");

legend( ...
    "Track 1", ...
    "Track 2", ...
    "Track 3", ...
    "Location", ...
    "best");

hold off;

disp("========================================");
disp("       TEST COMPLETED");
disp("========================================");