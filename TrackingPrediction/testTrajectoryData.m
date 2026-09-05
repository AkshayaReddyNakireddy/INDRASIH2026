%% Test trajectory training data

clear;
clc;

[XTrain,YTrain] = generateTrajectoryData(100);

disp("===== TRAJECTORY TRAINING DATA =====");

fprintf("Number of sequences : %d\n", ...
    numel(XTrain));

fprintf("Input size          : %d x %d\n", ...
    size(XTrain{1},1), ...
    size(XTrain{1},2));

fprintf("Output size         : %d x %d\n", ...
    size(YTrain{1},1), ...
    size(YTrain{1},2));

disp(" ");
disp("First input trajectory:");

disp(XTrain{1});

disp("First future trajectory:");

disp(YTrain{1});