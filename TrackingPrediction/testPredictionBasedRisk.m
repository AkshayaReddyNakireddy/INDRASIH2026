clear;
clc;

%% Create tracked object

tracks = struct( ...
    'TrackID', 1, ...
    'ClassID', 1, ...
    'Confidence', 0.95, ...
    'BoundingBox', [100 100 50 50], ...
    'Position', [145 125], ...
    'Velocity', [30 0]);

%% Predicted trajectory
% Object is moving toward ego vehicle

predictions = struct( ...
    'TrackID', 1, ...
    'ClassID', 1, ...
    'PredictedTime', [0.5 1.0 1.5 2.0 2.5], ...
    'Trajectory', [ ...
        190 125;
        205 125;
        220 125;
        235 125;
        250 125]);

%% Ego vehicle

egoState.Position = [200 125];
egoState.Velocity = [0 0];
egoState.Heading = 0;

%% Calculate risk

riskAssessment = predictionBasedRisk( ...
    tracks, predictions, egoState);

%% Display results

disp("===== PREDICTION-BASED COLLISION RISK =====");

disp("Track ID:");
disp(riskAssessment.TrackID);

disp("Class ID:");
disp(riskAssessment.ClassID);

disp("Predicted collision time:");
disp(riskAssessment.TTC);

disp("Minimum predicted distance:");
disp(riskAssessment.MinimumDistance);

disp("Lateral offset:");
disp(riskAssessment.LateralOffset);

disp("Risk level:");
disp(riskAssessment.RiskLevel);