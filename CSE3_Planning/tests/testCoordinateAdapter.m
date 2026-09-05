function output = cse3Planner(tracks, decisionInput)
% CSE3PLANNER
% SIH26037 - Adaptive Path Planning and Collision Avoidance
%
% Main CSE3 decision and path-planning function.
%
% INPUTS:
%   tracks
%       Tracking output from Akshaya.
%
%   decisionInput
%       Critical-object risk information from Akshaya.
%
% OUTPUTS:
%   output.decision
%   output.selectedPath
%   output.targetSpeed
%   output.trajectoryX
%   output.trajectoryY
%   output.pathInfo
%   output.adapterStatus
%
% Architecture:
%
%   Akshaya tracks
%          |
%          v
%   Coordinate Adapter
%          |
%          v
%   Planning Objects
%          |
%          v
%   Candidate Paths
%          |
%          v
%   Collision Checking
%          |
%          v
%   Path Cost
%          |
%          v
%   Best Path Selection
%          |
%          v
%   Decision + Speed + Trajectory

%% ============================================================
% 1. INITIALIZE OUTPUT
% =============================================================

output.decision = "CRUISE";
output.selectedPath = "NONE";
output.targetSpeed = 0;
output.trajectoryX = [];
output.trajectoryY = [];
output.pathInfo = [];
output.adapterStatus = [];

%% ============================================================
% 2. LOAD VEHICLE PARAMETERS
% =============================================================

vehicle = vehicleParameters();

%% ============================================================
% 3. DISPLAY INPUT
% =============================================================

disp("========================================");
disp("       CSE3 PLANNER INPUT");
disp("========================================");

disp("Number of tracked objects:");
disp(length(tracks));

disp("Critical Track ID:");
disp(decisionInput.CriticalTrackID);

disp("Critical Class ID:");
disp(decisionInput.CriticalClassID);

disp("TTC:");
disp(decisionInput.TTC);

disp("Risk Level:");
disp(decisionInput.RiskLevel);

disp("Lateral Offset:");
disp(decisionInput.LateralOffset);

%% ============================================================
% 4. DETERMINE DRIVING DECISION
% =============================================================

output.decision = decisionLogic(decisionInput);

%% ============================================================
% 5. DETERMINE TARGET SPEED
% =============================================================

switch output.decision

    case "CRUISE"
        output.targetSpeed = vehicle.cruise_speed;

    case "FOLLOW"
        output.targetSpeed = vehicle.follow_speed;

    case "SLOW"
        output.targetSpeed = vehicle.slow_speed;

    case "YIELD"
        output.targetSpeed = vehicle.yield_speed;

    case "AVOID"
        output.targetSpeed = vehicle.avoid_speed;

    case "STOP"
        output.targetSpeed = vehicle.stop_speed;

    otherwise
        output.targetSpeed = vehicle.stop_speed;

end

%% ============================================================
% 6. CONVERT TRACKS TO PLANNING OBJECTS
% ============================================================
%
% IMPORTANT:
%
% Akshaya's Position is currently in image/pixel coordinates.
%
% The coordinate adapter only accepts a valid metric
% PlanningPosition for the current test/integration stage.
%
% No artificial pixel-to-metre conversion is performed.

[planningObjects, adapterStatus] = ...
    convertAkshayaToPlanning(tracks);

output.adapterStatus = adapterStatus;

%% ============================================================
% 7. DISPLAY ADAPTER STATUS
% ============================================================

disp("========================================");
disp("       CSE3 COORDINATE ADAPTER");
disp("========================================");

disp("Total tracks:");
disp(adapterStatus.totalTracks);

disp("Converted planning objects:");
disp(adapterStatus.convertedTracks);

disp("Rejected tracks:");
disp(adapterStatus.rejectedTracks);

disp("Metric conversion available:");
disp(adapterStatus.conversionAvailable);

disp("Adapter message:");
disp(adapterStatus.message);

%% ============================================================
% 8. GENERATE CANDIDATE PATHS
% =============================================================

paths = generateCandidatePaths(vehicle);

%% ============================================================
% 9. COLLISION CHECKING
% =============================================================

for i = 1:length(paths)

    [collision, clearance] = ...
        checkPathCollision( ...
        paths(i), ...
        planningObjects, ...
        vehicle);

    paths(i).collision = collision;

    paths(i).minimumClearance = clearance;

    paths(i).cost = ...
        calculatePathCost(paths(i));

end

%% ============================================================
% 10. SELECT BEST SAFE PATH
% =============================================================

[selectedPath, selectedIndex] = ...
    selectBestPath(paths);

%% ============================================================
% 11. NO-SAFE-PATH SAFETY OVERRIDE
% ============================================================

if selectedIndex == 0

    output.decision = "STOP";

    output.targetSpeed = ...
        vehicle.stop_speed;

end

%% ============================================================
% 12. STORE SELECTED TRAJECTORY
% ============================================================

if selectedIndex > 0

    output.selectedPath = ...
        selectedPath;

    output.trajectoryX = ...
        paths(selectedIndex).x;

    output.trajectoryY = ...
        paths(selectedIndex).y;

else

    output.selectedPath = "NONE";

    output.trajectoryX = [];

    output.trajectoryY = [];

end

%% ============================================================
% 13. STORE PATH INFORMATION
% =============================================================

output.pathInfo = paths;

%% ============================================================
% 14. DISPLAY FINAL OUTPUT
% ============================================================

disp("========================================");
disp("       CSE3 PLANNER OUTPUT");
disp("========================================");

disp("Decision:");
disp(output.decision);

disp("Selected Path:");
disp(output.selectedPath);

disp("Target Speed (km/h):");
disp(output.targetSpeed);

if selectedIndex > 0

    disp("Selected Path Clearance (m):");
    disp(paths(selectedIndex).minimumClearance);

    disp("Selected Path Cost:");
    disp(paths(selectedIndex).cost);

else

    disp("WARNING: No safe path available.");

end

disp("========================================");

end