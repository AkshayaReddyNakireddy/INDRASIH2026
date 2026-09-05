function predictions = trajectoryPredictor(history)
%TRAJECTORYPREDICTOR Predict future trajectories using trained LSTM.
%
% Input:
%   history - output from trajectoryHistory
%
% Output:
%   predictions - predicted future trajectories

%% Load trained LSTM

persistent net

if isempty(net)
    data = load("trajectoryLSTM.mat", "net");
    net = data.net;
end

%% Prediction time

predictionTime = [0.5 1.0 1.5 2.0 2.5];

%% Initialize output

predictions = struct( ...
    'TrackID', {}, ...
    'ClassID', {}, ...
    'PredictedTime', {}, ...
    'Trajectory', {});

%% Process every tracked object

for i = 1:numel(history)

    %% Get position history

    positions = history(i).Positions;

    % Need at least 5 observations
    if size(positions,1) < 5
        continue;
    end

    %% Take latest 5 positions

    pastPositions = positions(end-4:end,:);

    %% Reference = latest observed position

    referencePosition = pastPositions(end,:);

    %% Convert to relative coordinates

    pastRelative = ...
        pastPositions - referencePosition;

    %% Convert to LSTM format

    X = pastRelative';

    %% LSTM prediction

    YPred = predict(net, {X});

    %% Convert prediction back to matrix

    predictedRelative = YPred{1}';

    %% Convert relative positions to actual coordinates

    predictedTrajectory = ...
        predictedRelative + referencePosition;

    %% Store result

    predictions(end+1).TrackID = ...
        history(i).TrackID;

    predictions(end).ClassID = ...
        history(i).ClassID;

    predictions(end).PredictedTime = ...
        predictionTime;

    predictions(end).Trajectory = ...
        predictedTrajectory;

end

end