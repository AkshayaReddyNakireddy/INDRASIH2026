function paths = generateCandidatePaths(vehicle)
% GENERATECANDIDATEPATHS
% SIH26037 - Adaptive Path Planning
%
% Generates three smooth candidate trajectories:
%   LEFT
%   CENTER
%   RIGHT
%
% Candidate lateral offsets are automatically constrained
% by the vehicle-footprint-aware road boundaries.
%
% Planning coordinate:
%   Positive Y = left
%   Negative Y = right

%% ============================================================
% 1. PLANNING PARAMETERS
% ============================================================

planningHorizon = vehicle.planning_horizon;

numPoints = vehicle.num_path_points;

%% ============================================================
% 2. CALCULATE VEHICLE-SAFE ROAD CORRIDOR
% ============================================================

vehicleHalfWidth = vehicle.width / 2;

safetyMargin = vehicle.safety_margin;

requiredEdgeClearance = ...
    vehicleHalfWidth + safetyMargin;

safeLeftBoundary = ...
    vehicle.road_left_boundary - requiredEdgeClearance;

safeRightBoundary = ...
    vehicle.road_right_boundary + requiredEdgeClearance;

%% ============================================================
% 3. LIMIT CANDIDATE PATH OFFSETS
% ============================================================
%
% The requested offsets from vehicleParameters are treated as
% desired offsets.
%
% They are clipped to the physically safe road corridor.

leftOffset = min( ...
    vehicle.left_path_offset, ...
    safeLeftBoundary);

centerOffset = vehicle.center_path_offset;

rightOffset = max( ...
    vehicle.right_path_offset, ...
    safeRightBoundary);

%% ============================================================
% 4. GENERATE LONGITUDINAL PATH
% ============================================================

x = linspace( ...
    0, ...
    planningHorizon, ...
    numPoints);

%% ============================================================
% 5. SMOOTH LATERAL TRANSITION
% ============================================================

t = linspace(0, 1, numPoints);

transitionStart = 0.05;

transitionEnd = 0.65;

s = zeros(size(t));

active = t >= transitionStart;

tau = ...
    (t(active) - transitionStart) / ...
    (transitionEnd - transitionStart);

tau = min(max(tau, 0), 1);

% Quintic smooth-step function.
s(active) = ...
    10*tau.^3 ...
    - 15*tau.^4 ...
    + 6*tau.^5;

%% ============================================================
% 6. GENERATE LATERAL TRAJECTORIES
% ============================================================

yLeft = leftOffset .* s;

yCenter = centerOffset .* s;

yRight = rightOffset .* s;

%% ============================================================
% 7. CREATE PATH STRUCTURES
% ============================================================

paths(1).name = "LEFT";

paths(1).x = x;

paths(1).y = yLeft;

paths(1).collision = false;

paths(1).minimumClearance = Inf;

paths(1).cost = Inf;


paths(2).name = "CENTER";

paths(2).x = x;

paths(2).y = yCenter;

paths(2).collision = false;

paths(2).minimumClearance = Inf;

paths(2).cost = Inf;


paths(3).name = "RIGHT";

paths(3).x = x;

paths(3).y = yRight;

paths(3).collision = false;

paths(3).minimumClearance = Inf;

paths(3).cost = Inf;

%% ============================================================
% 8. DISPLAY GENERATED SAFE OFFSETS
% ============================================================

disp("========================================");
disp("       CANDIDATE PATH GENERATION");
disp("========================================");

disp("Safe Left Centerline Limit (m):");
disp(safeLeftBoundary);

disp("Safe Right Centerline Limit (m):");
disp(safeRightBoundary);

disp("Generated LEFT Offset (m):");
disp(leftOffset);

disp("Generated CENTER Offset (m):");
disp(centerOffset);

disp("Generated RIGHT Offset (m):");
disp(rightOffset);

disp("========================================");

end