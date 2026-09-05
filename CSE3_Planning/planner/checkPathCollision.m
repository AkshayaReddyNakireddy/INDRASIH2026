function [collision, minimumClearance] = checkPathCollision(path, obstacles, vehicle)
% CHECKPATHCOLLISION
% SIH26037 - Collision checking for candidate trajectories
%
% X = forward distance (m)
% Y = lateral distance (m)

%% ============================================================
% SAFETY PARAMETERS
% =============================================================

vehicleHalfWidth = vehicle.width / 2;
safetyMargin = vehicle.safety_margin;

% Longitudinal safety boundary
longitudinalLimit = vehicle.length / 2 + safetyMargin;

%% ============================================================
% INITIALIZATION
% =============================================================

collision = false;
minimumClearance = Inf;

%% No obstacles

if isempty(obstacles)
    return;
end

%% ============================================================
% CHECK EACH OBSTACLE
% =============================================================

for i = 1:length(obstacles)

    obstacleX = obstacles(i).Position(1);
    obstacleY = obstacles(i).Position(2);

    %% Distance between obstacle and every trajectory point

    longitudinalDistance = abs(path.x - obstacleX);
    lateralDistance = abs(path.y - obstacleY);

    %% Only consider points close in longitudinal direction

    nearby = longitudinalDistance <= longitudinalLimit;

    if ~any(nearby)
        continue;
    end

    %% Calculate clearance

    clearance = lateralDistance(nearby) ...
        - vehicleHalfWidth ...
        - safetyMargin;

    %% Minimum clearance for this obstacle

    currentMinimum = min(clearance);

    minimumClearance = min( ...
        minimumClearance, ...
        currentMinimum);

    %% Collision

    if currentMinimum <= 0
        collision = true;
    end

end

end