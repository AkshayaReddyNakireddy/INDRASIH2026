function [outsideBoundary, minimumBoundaryClearance] = ...
    checkRoadBoundary(path, vehicle)
% CHECKROADBOUNDARY
% SIH26037 - Vehicle-footprint-aware road boundary checking
%
% Checks whether the COMPLETE VEHICLE FOOTPRINT remains inside
% the available road boundaries.
%
% Planning coordinate:
%   Positive Y = left
%   Negative Y = right
%
% Road boundaries represent the physical road edges.
%
% The vehicle centerline therefore cannot approach the road edge
% closer than:
%
%   vehicle half-width + safety margin
%
% Outputs:
%   outsideBoundary
%       true if any point of the vehicle path violates the
%       safe road corridor.
%
%   minimumBoundaryClearance
%       Minimum remaining clearance between the vehicle
%       footprint + safety margin and either road boundary.

%% ============================================================
% 1. READ ROAD BOUNDARIES
% ============================================================

leftBoundary = vehicle.road_left_boundary;

rightBoundary = vehicle.road_right_boundary;

%% ============================================================
% 2. VEHICLE FOOTPRINT SAFETY DISTANCE
% ============================================================

vehicleHalfWidth = vehicle.width / 2;

safetyMargin = vehicle.safety_margin;

requiredEdgeClearance = ...
    vehicleHalfWidth + safetyMargin;

%% ============================================================
% 3. CALCULATE SAFE CENTERLINE CORRIDOR
% ============================================================
%
% The vehicle CENTER cannot travel closer to the physical
% road edge than the vehicle half-width + safety margin.
%
% Therefore:
%
% Safe left limit:
%     left road edge - required clearance
%
% Safe right limit:
%     right road edge + required clearance

safeLeftBoundary = ...
    leftBoundary - requiredEdgeClearance;

safeRightBoundary = ...
    rightBoundary + requiredEdgeClearance;

%% ============================================================
% 4. PATH LATERAL POSITION
% ============================================================

pathY = path.y;

%% ============================================================
% 5. CLEARANCE FROM SAFE BOUNDARIES
% ============================================================

leftClearance = ...
    safeLeftBoundary - pathY;

rightClearance = ...
    pathY - safeRightBoundary;

minimumBoundaryClearance = ...
    min([leftClearance, rightClearance]);

%% ============================================================
% 6. CHECK WHETHER PATH LEAVES SAFE ROAD CORRIDOR
% ============================================================

outsideBoundary = ...
    any(pathY > safeLeftBoundary) || ...
    any(pathY < safeRightBoundary);

end