clear;
clc;

%% Create sample trajectory history

history = struct( ...
    'TrackID', 1, ...
    'ClassID', 1, ...
    'Positions', [ ...
        145 211;
        123 206;
         99 201;
         76 196;
         52 193]);

%% Predict trajectory

predictions = trajectoryPredictor(history);

%% Display results

disp("===== IMPROVED LSTM PREDICTION =====");

disp("Track ID:");
disp(predictions.TrackID);

disp("Current position:");
disp(history.Positions(end,:));

disp("Predicted trajectory:");

disp(predictions.Trajectory);