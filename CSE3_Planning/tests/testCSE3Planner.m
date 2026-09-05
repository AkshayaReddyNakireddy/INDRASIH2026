clc;
clear;
close all;

%% ============================================================
% CSE3 INTEGRATED PLANNER TEST
% =============================================================

disp("========================================");
disp("       CSE3 INTEGRATED PLANNER TEST");
disp("========================================");

%% 1. LOAD TEST SCENARIO

[objects, decisionInput] = ...
    scenario_testAkshayaInput();

disp("Scenario loaded successfully.");

%% 2. RUN CSE3 PLANNER

output = ...
    cse3Planner(objects, decisionInput);

%% 3. DISPLAY FINAL OUTPUT

disp("========================================");
disp("       FINAL OUTPUT CHECK");
disp("========================================");

disp("Decision:");
disp(output.decision);

disp("Selected Path:");
disp(output.selectedPath);

disp("Target Speed (km/h):");
disp(output.targetSpeed);

%% 4. VERIFY SELECTED TRAJECTORY

disp("Trajectory X size:");
disp(size(output.trajectoryX));

disp("Trajectory Y size:");
disp(size(output.trajectoryY));

if isempty(output.trajectoryX) || ...
        isempty(output.trajectoryY)

    error("FAIL: Selected trajectory is empty.");

end

if length(output.trajectoryX) ~= ...
        length(output.trajectoryY)

    error("FAIL: X and Y trajectory lengths do not match.");

end

disp("Selected trajectory: VALID");

%% 5. VERIFY PATH INFORMATION

if isempty(output.pathInfo)

    error("FAIL: Path information is empty.");

end

disp("Number of candidate paths:");
disp(length(output.pathInfo));

if length(output.pathInfo) ~= 3

    error("FAIL: Expected 3 candidate paths.");

end

disp("Candidate path structure: VALID");

%% 6. VERIFY ADAPTER STATUS

disp("Current-object conversion:");
disp(output.adapterStatus.convertedTracks);

disp("Prediction conversion:");
disp(output.predictionStatus.convertedTracks);

if output.adapterStatus.convertedTracks < 1

    error("FAIL: No current planning objects converted.");

end

if output.predictionStatus.convertedTracks < 1

    error("FAIL: No predicted trajectories converted.");

end

disp("Adapter outputs: VALID");

%% 7. VERIFY SAFE PATH SELECTION

if output.selectedPath == "NONE"

    error("FAIL: No path selected.");

end

selectedIndex = 0;

for i = 1:length(output.pathInfo)

    if output.pathInfo(i).name == ...
            output.selectedPath

        selectedIndex = i;
        break;

    end

end

if selectedIndex == 0

    error("FAIL: Selected path not found.");

end

if output.pathInfo(selectedIndex).collision

    error("FAIL: Selected path has a collision.");

end

disp("Selected path safety: VALID");

%% 8. DISPLAY PATH SUMMARY

disp("========================================");
disp("       PATH SUMMARY");
disp("========================================");

for i = 1:length(output.pathInfo)

    disp("Path:");
    disp(output.pathInfo(i).name);

    disp("Collision:");
    disp(output.pathInfo(i).collision);

    disp("Minimum Clearance (m):");
    disp(output.pathInfo(i).minimumClearance);

    disp("Cost:");
    disp(output.pathInfo(i).cost);

    disp("----------------------------------------");

end

%% 9. PLOT FINAL PLANNING RESULT

figure;

hold on;
grid on;

for i = 1:length(output.pathInfo)

    plot( ...
        output.pathInfo(i).x, ...
        output.pathInfo(i).y, ...
        'LineWidth', 2);

end

%% Predicted obstacle trajectory

predictedTrajectory = ...
    objects(1).PlanningTrajectory;

plot( ...
    predictedTrajectory(:,1), ...
    predictedTrajectory(:,2), ...
    'ko-', ...
    'LineWidth', 2, ...
    'MarkerSize', 6);

%% Selected path

plot( ...
    output.trajectoryX, ...
    output.trajectoryY, ...
    'LineWidth', 4);

xlabel("Forward Distance (m)");
ylabel("Lateral Distance (m)");

title("CSE3 Integrated Path Planning");

legend( ...
    "LEFT", ...
    "CENTER", ...
    "RIGHT", ...
    "Predicted Object", ...
    "Selected Path", ...
    "Location", ...
    "best");

hold off;

%% 10. FINAL RESULT

disp("========================================");
disp("       CSE3 TEST RESULT");
disp("========================================");

disp("CSE3 INTEGRATED TEST PASSED");

disp("Decision:");
disp(output.decision);

disp("Selected Path:");
disp(output.selectedPath);

disp("Target Speed (km/h):");
disp(output.targetSpeed);

disp("========================================");