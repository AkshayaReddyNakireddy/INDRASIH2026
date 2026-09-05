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
%   output.predictionStatus
%
% Safety constraints:
%   1. Road boundary
%   2. Current obstacle collision
%   3. Predicted obstacle collision

%% ============================================================
% 1. INITIALIZE OUTPUT
% ============================================================

output.decision = "CRUISE";
output.selectedPath = "NONE";
output.targetSpeed = 0;
output.trajectoryX = [];
output.trajectoryY = [];
output.pathInfo = [];
output.adapterStatus = [];
output.predictionStatus = [];

%% ============================================================
% 2. LOAD VEHICLE PARAMETERS
% ============================================================

vehicle = vehicleParameters();

%% ============================================================
% 3. DISPLAY INPUT
% ============================================================

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
% ============================================================

output.decision = decisionLogic(decisionInput);

%% ============================================================
% 5. DETERMINE INITIAL TARGET SPEED
% ============================================================

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
% 6. CONVERT TRACKS TO CURRENT PLANNING OBJECTS
% ============================================================

[planningObjects, adapterStatus] = ...
    convertAkshayaToPlanning(tracks);

output.adapterStatus = adapterStatus;

%% ============================================================
% 7. CONVERT TRACKS TO PREDICTED PLANNING OBJECTS
% ============================================================

[predictedObjects, predictionStatus] = ...
    convertAkshayaPredictionToPlanning(tracks);

output.predictionStatus = predictionStatus;

%% ============================================================
% 8. DISPLAY CURRENT OBJECT ADAPTER STATUS
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
% 9. DISPLAY PREDICTION ADAPTER STATUS
% ============================================================

disp("========================================");
disp("       CSE3 PREDICTION ADAPTER");
disp("========================================");

disp("Total tracks:");
disp(predictionStatus.totalTracks);

disp("Converted predicted trajectories:");
disp(predictionStatus.convertedTracks);

disp("Rejected prediction tracks:");
disp(predictionStatus.rejectedTracks);

disp("Metric prediction available:");
disp(predictionStatus.conversionAvailable);

disp("Prediction timestamps available:");
disp(predictionStatus.timeAvailable);

disp("Prediction adapter message:");
disp(predictionStatus.message);

%% ============================================================
% 10. GENERATE CANDIDATE PATHS
% ============================================================

paths = generateCandidatePaths(vehicle);

%% ============================================================
% 11. ROAD BOUNDARY + CURRENT + PREDICTED COLLISION CHECKING
% ============================================================

for i = 1:length(paths)

    %% --------------------------------------------------------
    % Road boundary check
    % ---------------------------------------------------------

    [outsideBoundary, boundaryClearance] = ...
        checkRoadBoundary( ...
        paths(i), ...
        vehicle);

    paths(i).outsideBoundary = outsideBoundary;
    paths(i).boundaryClearance = boundaryClearance;

    %% --------------------------------------------------------
    % Current obstacle collision
    % ---------------------------------------------------------

    [currentCollision, currentClearance] = ...
        checkPathCollision( ...
        paths(i), ...
        planningObjects, ...
        vehicle);

    %% --------------------------------------------------------
    % Predicted obstacle collision
    % ---------------------------------------------------------

    [predictedCollision, predictedClearance] = ...
        checkPredictedPathCollision( ...
        paths(i), ...
        predictedObjects, ...
        vehicle, ...
        output.targetSpeed);

    %% --------------------------------------------------------
    % Store collision results
    % ---------------------------------------------------------

    paths(i).currentCollision = currentCollision;
    paths(i).currentClearance = currentClearance;

    paths(i).predictedCollision = predictedCollision;
    paths(i).predictedClearance = predictedClearance;

    %% --------------------------------------------------------
    % Combine all safety constraints
    % ---------------------------------------------------------

    paths(i).collision = ...
        outsideBoundary || ...
        currentCollision || ...
        predictedCollision;

    %% --------------------------------------------------------
    % Determine overall minimum clearance
    % ---------------------------------------------------------

    clearances = [];

    if isfinite(boundaryClearance)
        clearances(end+1) = boundaryClearance;
    end

    if isfinite(currentClearance)
        clearances(end+1) = currentClearance;
    end

    if isfinite(predictedClearance)
        clearances(end+1) = predictedClearance;
    end

    if isempty(clearances)

        paths(i).minimumClearance = Inf;

    else

        paths(i).minimumClearance = ...
            min(clearances);

    end

    %% --------------------------------------------------------
    % Calculate final path cost
    % ---------------------------------------------------------

    paths(i).cost = ...
        calculatePathCost(paths(i));

end

%% ============================================================
% 12. DISPLAY PATH SAFETY RESULTS
% ============================================================

disp("========================================");
disp("       PATH SAFETY RESULTS");
disp("========================================");

for i = 1:length(paths)

    disp("Path:");
    disp(paths(i).name);

    %% Road boundary

    disp("Outside Road Boundary:");

    if paths(i).outsideBoundary
        disp("YES");
    else
        disp("NO");
    end

    disp("Boundary Clearance (m):");
    disp(paths(i).boundaryClearance);

    %% Current collision

    disp("Current Collision:");

    if paths(i).currentCollision
        disp("YES");
    else
        disp("NO");
    end

    %% Predicted collision

    disp("Predicted Collision:");

    if paths(i).predictedCollision
        disp("YES");
    else
        disp("NO");
    end

    %% Overall collision

    disp("Overall Collision:");

    if paths(i).collision
        disp("YES");
    else
        disp("NO");
    end

    %% Minimum clearance

    disp("Minimum Clearance (m):");
    disp(paths(i).minimumClearance);

    %% Cost

    disp("Path Cost:");

    if isinf(paths(i).cost)
        disp("INF");
    else
        disp(paths(i).cost);
    end

    disp("----------------------------------------");

end

%% ============================================================
% 13. SELECT BEST SAFE PATH
% ============================================================

[selectedPath, selectedIndex] = ...
    selectBestPath(paths);

%% ============================================================
% 14. NO-SAFE-PATH SAFETY OVERRIDE
% ============================================================

if selectedIndex == 0

    output.decision = "STOP";

    output.targetSpeed = ...
        vehicle.stop_speed;

end

%% ============================================================
% 15. STORE SELECTED TRAJECTORY
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
% 16. STORE PATH INFORMATION
% ============================================================

output.pathInfo = paths;

%% ============================================================
% 17. DISPLAY FINAL OUTPUT
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