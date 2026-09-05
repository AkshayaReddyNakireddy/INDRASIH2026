function [collision, minimumClearance] = ...
    checkPredictedPathCollision(path, predictedObjects, vehicle, planningSpeedKph)
% CHECKPREDICTEDPATHCOLLISION
% SIH26037 - Time-synchronized predicted trajectory collision checking
%
% Path coordinates:
%   X = forward distance (m)
%   Y = lateral distance (m)
%
% Predicted trajectory:
%   X = forward distance (m)
%   Y = lateral distance (m)
%
% PredictedTime:
%   seconds
%
% The vehicle path is distance-based, so its corresponding time is
% calculated using the vehicle planning speed.
%
% planningSpeedKph is in km/h.

%% Default planning speed

if nargin < 4 || isempty(planningSpeedKph)
    planningSpeedKph = vehicle.cruise_speed;
end

%% Vehicle parameters

vehicleHalfWidth = vehicle.width / 2;
safetyMargin = vehicle.safety_margin;

longitudinalLimit = ...
    vehicle.length / 2 + safetyMargin;

%% Convert speed from km/h to m/s

planningSpeedMps = planningSpeedKph / 3.6;

%% Generate time corresponding to each path point

if planningSpeedMps > 0

    planningTime = path.x ./ planningSpeedMps;

else

    % Vehicle is stationary.
    planningTime = zeros(size(path.x));

end

%% Initialize output

collision = false;
minimumClearance = Inf;

%% No predicted objects

if isempty(predictedObjects)
    return;
end

%% Check every predicted object

for i = 1:length(predictedObjects)

    if ~isfield(predictedObjects(i), 'Trajectory')
        continue;
    end

    trajectory = predictedObjects(i).Trajectory;

    if isempty(trajectory) || size(trajectory,2) < 2
        continue;
    end

    obstacleX = trajectory(:,1);
    obstacleY = trajectory(:,2);

    %% Check whether prediction contains timestamps

    hasTime = ...
        isfield(predictedObjects(i), 'PredictedTime');

    if hasTime

        predictedTime = ...
            predictedObjects(i).PredictedTime(:);

        %% Validate timestamps

        if length(predictedTime) ~= size(trajectory,1)
            hasTime = false;
        end

        if any(~isfinite(predictedTime))
            hasTime = false;
        end

        if length(predictedTime) >= 2 && ...
                any(diff(predictedTime) <= 0)

            hasTime = false;
        end

    end

    %% ============================================================
    % TIME-SYNCHRONIZED COLLISION CHECK
    % ============================================================

    if hasTime && length(predictedTime) >= 2

        % Only use the portion of the prediction that overlaps
        % the vehicle's planning time horizon.

        valid = ...
            predictedTime >= planningTime(1) & ...
            predictedTime <= planningTime(end);

        if ~any(valid)
            continue;
        end

        validPredictionTime = ...
            predictedTime(valid);

        validObstacleX = ...
            obstacleX(valid);

        validObstacleY = ...
            obstacleY(valid);

        %% Interpolate obstacle position onto vehicle path time

        synchronizedObstacleX = ...
            interp1( ...
                validPredictionTime, ...
                validObstacleX, ...
                planningTime, ...
                'linear', ...
                NaN);

        synchronizedObstacleY = ...
            interp1( ...
                validPredictionTime, ...
                validObstacleY, ...
                planningTime, ...
                'linear', ...
                NaN);

        %% Only evaluate valid synchronized points

        validSynchronized = ...
            isfinite(synchronizedObstacleX) & ...
            isfinite(synchronizedObstacleY);

        if ~any(validSynchronized)
            continue;
        end

        pathX = path.x(validSynchronized);
        pathY = path.y(validSynchronized);

        obstacleXSync = ...
            synchronizedObstacleX(validSynchronized);

        obstacleYSync = ...
            synchronizedObstacleY(validSynchronized);

        %% Distance between vehicle and predicted obstacle

        longitudinalDistance = ...
            abs(pathX - obstacleXSync);

        lateralDistance = ...
            abs(pathY - obstacleYSync);

        %% Only check when longitudinally close

        nearby = ...
            longitudinalDistance <= longitudinalLimit;

        if ~any(nearby)
            continue;
        end

        %% Calculate lateral clearance

        clearance = ...
            lateralDistance(nearby) ...
            - vehicleHalfWidth ...
            - safetyMargin;

        currentMinimum = min(clearance);

        minimumClearance = ...
            min(minimumClearance, currentMinimum);

        %% Collision

        if currentMinimum <= 0
            collision = true;
        end

    else

        %% ========================================================
        % FALLBACK SPATIAL CHECK
        % ========================================================
        %
        % Used only when valid prediction timestamps are unavailable.

        longitudinalDistance = ...
            abs(path.x - obstacleX(1));

        lateralDistance = ...
            abs(path.y - obstacleY(1));

        nearby = ...
            longitudinalDistance <= longitudinalLimit;

        if ~any(nearby)
            continue;
        end

        clearance = ...
            lateralDistance(nearby) ...
            - vehicleHalfWidth ...
            - safetyMargin;

        currentMinimum = min(clearance);

        minimumClearance = ...
            min(minimumClearance, currentMinimum);

        if currentMinimum <= 0
            collision = true;
        end

    end

end

end