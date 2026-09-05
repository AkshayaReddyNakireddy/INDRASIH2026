function [predictedObjects, predictionStatus] = ...
    convertAkshayaPredictionToPlanning(tracks)
% CONVERTAKSHAYAPREDICTIONTOPLANNING
% SIH26037 - CSE3 Predicted-Trajectory Adapter
%
% Converts Akshaya's predicted trajectory into the metric
% planning coordinate system.
%
% Current integration interface:
%
%   TrackID
%   PlanningTrajectory
%   PlanningPredictionTime
%
% PlanningTrajectory:
%   [X_forward Y_lateral] in metres
%
% PlanningPredictionTime:
%   prediction time for each trajectory point, in seconds
%
% IMPORTANT:
% No pixel-to-metre conversion is performed here.
% Metric coordinates must come from the upstream
% camera/LiDAR/sensor-fusion stage.

%% ============================================================
% 1. INITIALIZE OUTPUT
% =============================================================

predictedObjects = struct( ...
    'TrackID', {}, ...
    'Trajectory', {}, ...
    'PredictedTime', {});

predictionStatus.totalTracks = length(tracks);
predictionStatus.convertedTracks = 0;
predictionStatus.rejectedTracks = 0;
predictionStatus.conversionAvailable = false;
predictionStatus.timeAvailable = false;
predictionStatus.message = "";

%% ============================================================
% 2. HANDLE EMPTY INPUT
% =============================================================

if isempty(tracks)

    predictionStatus.message = ...
        "No tracked objects received.";

    return;

end

%% ============================================================
% 3. PROCESS EACH TRACK
% =============================================================

for i = 1:length(tracks)

    %% --------------------------------------------------------
    % Check TrackID
    % ---------------------------------------------------------

    if ~isfield(tracks(i), 'TrackID')

        predictionStatus.rejectedTracks = ...
            predictionStatus.rejectedTracks + 1;

        continue;

    end

    %% --------------------------------------------------------
    % Check metric predicted trajectory
    % ---------------------------------------------------------

    if ~isfield(tracks(i), 'PlanningTrajectory')

        predictionStatus.rejectedTracks = ...
            predictionStatus.rejectedTracks + 1;

        continue;

    end

    trajectory = tracks(i).PlanningTrajectory;

    %% --------------------------------------------------------
    % Validate trajectory
    % ---------------------------------------------------------

    if ~isnumeric(trajectory) || ...
            size(trajectory,2) < 2

        predictionStatus.rejectedTracks = ...
            predictionStatus.rejectedTracks + 1;

        continue;

    end

    trajectory = trajectory(:,1:2);

    if any(~isfinite(trajectory(:)))

        predictionStatus.rejectedTracks = ...
            predictionStatus.rejectedTracks + 1;

        continue;

    end

    %% --------------------------------------------------------
    % Check prediction timestamps
    % ---------------------------------------------------------

    hasTime = ...
        isfield(tracks(i), 'PlanningPredictionTime');

    if ~hasTime

        predictionStatus.rejectedTracks = ...
            predictionStatus.rejectedTracks + 1;

        continue;

    end

    predictedTime = ...
        tracks(i).PlanningPredictionTime;

    %% --------------------------------------------------------
    % Validate timestamps
    % ---------------------------------------------------------

    if ~isnumeric(predictedTime)

        predictionStatus.rejectedTracks = ...
            predictionStatus.rejectedTracks + 1;

        continue;

    end

    predictedTime = predictedTime(:);

    if length(predictedTime) ~= size(trajectory,1)

        predictionStatus.rejectedTracks = ...
            predictionStatus.rejectedTracks + 1;

        continue;

    end

    if any(~isfinite(predictedTime))

        predictionStatus.rejectedTracks = ...
            predictionStatus.rejectedTracks + 1;

        continue;

    end

    %% --------------------------------------------------------
    % Require non-decreasing prediction time
    % ---------------------------------------------------------

    if any(diff(predictedTime) < 0)

        predictionStatus.rejectedTracks = ...
            predictionStatus.rejectedTracks + 1;

        continue;

    end

    %% --------------------------------------------------------
    % Store converted prediction
    % ---------------------------------------------------------

    index = predictionStatus.convertedTracks + 1;

    predictedObjects(index).TrackID = ...
        tracks(i).TrackID;

    predictedObjects(index).Trajectory = ...
        trajectory;

    predictedObjects(index).PredictedTime = ...
        predictedTime;

    predictionStatus.convertedTracks = index;

    predictionStatus.timeAvailable = true;

end

%% ============================================================
% 4. DETERMINE STATUS
% =============================================================

if predictionStatus.convertedTracks > 0

    predictionStatus.conversionAvailable = true;

    if predictionStatus.timeAvailable

        predictionStatus.message = ...
            "Metric predicted trajectories and timestamps available.";

    else

        predictionStatus.message = ...
            "Metric predicted trajectories available, " + ...
            "but timestamps are unavailable.";

    end

else

    predictionStatus.conversionAvailable = false;

    predictionStatus.message = ...
        "No valid metric predicted trajectories available.";

end

end