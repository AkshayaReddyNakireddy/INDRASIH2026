clc;
clear;
close all;

disp("========================================");
disp("       ROAD BOUNDARY TEST");
disp("========================================");

%% ============================================================
% 1. LOAD VEHICLE PARAMETERS
% ============================================================

vehicle = vehicleParameters();

%% ============================================================
% 2. GENERATE CANDIDATE PATHS
% ============================================================

paths = generateCandidatePaths(vehicle);

%% ============================================================
% 3. DISPLAY BOUNDARY RESULTS
% ============================================================

for i = 1:length(paths)

    [outsideBoundary, clearance] = ...
        checkRoadBoundary(paths(i), vehicle);

    disp("Path:");
    disp(paths(i).name);

    disp("Outside Safe Road Boundary:");

    if outsideBoundary
        disp("YES");
    else
        disp("NO");
    end

    disp("Minimum Boundary Clearance (m):");
    disp(clearance);

    disp("----------------------------------------");

end

%% ============================================================
% 4. EXPECTED RESULTS
% ============================================================
%
% Vehicle:
%   Width = 1.8 m
%   Half-width = 0.9 m
%
% Safety margin:
%   1.0 m
%
% Road boundaries:
%   +5 m and -5 m
%
% Required edge clearance:
%   0.9 + 1.0 = 1.9 m
%
% Therefore safe centerline corridor:
%   Left  = +3.1 m
%   Right = -3.1 m
%
% Candidate paths are automatically constrained
% to this safe corridor.
%
% Expected:
%   LEFT   = +3.1 m -> inside
%   CENTER =  0.0 m -> inside
%   RIGHT  = -3.1 m -> inside

expectedOutside = [
    false
    false
    false
];

%% ============================================================
% 5. VERIFY RESULTS
% ============================================================

disp("========================================");
disp("       BOUNDARY TEST VERIFICATION");
disp("========================================");

for i = 1:length(paths)

    [outsideBoundary, ~] = ...
        checkRoadBoundary(paths(i), vehicle);

    if outsideBoundary ~= expectedOutside(i)

        error( ...
            "FAIL: Unexpected boundary result for %s path.", ...
            paths(i).name);

    end

end

disp("Boundary results match expected vehicle-footprint behavior.");

%% ============================================================
% 6. VERIFY CENTER PATH IS SAFE
% ============================================================

[centerOutside, centerClearance] = ...
    checkRoadBoundary(paths(2), vehicle);

if centerOutside

    error("FAIL: CENTER path should be inside the safe corridor.");

end

if centerClearance <= 0

    error("FAIL: CENTER path should have positive boundary clearance.");

end

disp("CENTER path safely remains inside the road corridor.");

%% ============================================================
% 7. VERIFY LEFT AND RIGHT PATHS ARE INSIDE
% ============================================================

[leftOutside, leftClearance] = ...
    checkRoadBoundary(paths(1), vehicle);

[rightOutside, rightClearance] = ...
    checkRoadBoundary(paths(3), vehicle);

if leftOutside

    error("FAIL: LEFT path should be inside the safe corridor.");

end

if rightOutside

    error("FAIL: RIGHT path should be inside the safe corridor.");

end

if leftClearance < 0

    error("FAIL: LEFT path has negative boundary clearance.");

end

if rightClearance < 0

    error("FAIL: RIGHT path has negative boundary clearance.");

end

disp("LEFT path safely remains inside the road corridor.");

disp("RIGHT path safely remains inside the road corridor.");

%% ============================================================
% 8. VERIFY SAFE CENTERLINE LIMITS
% ============================================================

vehicleHalfWidth = vehicle.width / 2;

requiredEdgeClearance = ...
    vehicleHalfWidth + vehicle.safety_margin;

expectedLeftLimit = ...
    vehicle.road_left_boundary - requiredEdgeClearance;

expectedRightLimit = ...
    vehicle.road_right_boundary + requiredEdgeClearance;

actualLeftLimit = max(paths(1).y);

actualRightLimit = min(paths(3).y);

if abs(actualLeftLimit - expectedLeftLimit) > 1e-10

    error("FAIL: LEFT path exceeds the calculated safe limit.");

end

if abs(actualRightLimit - expectedRightLimit) > 1e-10

    error("FAIL: RIGHT path exceeds the calculated safe limit.");

end

disp("Safe centerline limits verified.");

%% ============================================================
% 9. FINAL RESULT
% ============================================================

disp("========================================");
disp("       TEST RESULT");
disp("========================================");

disp("ROAD BOUNDARY TEST PASSED");

disp("========================================");