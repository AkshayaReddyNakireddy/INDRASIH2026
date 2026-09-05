function [XTrain, YTrain] = generateTrajectoryData(numSequences)
%GENERATETRAJECTORYDATA Generate realistic trajectory training data.
%
% Input:
%   numSequences - number of training sequences
%
% Outputs:
%   XTrain - past trajectories
%   YTrain - future trajectories

rng(1);

historyLength = 5;
predictionLength = 5;

XTrain = cell(numSequences,1);
YTrain = cell(numSequences,1);

for n = 1:numSequences

    %% Random initial position

    position = [ ...
        -100 + 200*rand, ...
        -100 + 200*rand];

    %% Random velocity

    velocity = [ ...
        -10 + 20*rand, ...
        -5 + 10*rand];

    %% Random acceleration

    acceleration = [ ...
        -1 + 2*rand, ...
        -0.5 + 1*rand];

    %% Generate complete trajectory

    totalLength = historyLength + predictionLength;

    trajectory = zeros(totalLength,2);

    for t = 1:totalLength

        % Update velocity
        velocity = velocity + acceleration;

        % Update position
        position = position + velocity;

        % Store position
        trajectory(t,:) = position;

    end

    %% Split into past and future

    past = trajectory(1:historyLength,:);
    future = trajectory(historyLength+1:end,:);

    %% Normalize relative to last observed position

    referencePosition = past(end,:);

    pastRelative = past - referencePosition;
    futureRelative = future - referencePosition;

    %% Convert to LSTM format

    XTrain{n} = pastRelative';
    YTrain{n} = futureRelative';

end

end