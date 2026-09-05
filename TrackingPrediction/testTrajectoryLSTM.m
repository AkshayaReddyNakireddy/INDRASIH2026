%% Test trained LSTM trajectory predictor

clear;
clc;

%% Load trained network

load("trajectoryLSTM.mat", "net");

%% Generate one test trajectory

[XTest, YTest] = generateTrajectoryData(2000);
%options
options = trainingOptions("adam", ...
    MaxEpochs=30, ...
    MiniBatchSize=32, ...
    InitialLearnRate=0.001, ...
    Shuffle="every-epoch", ...
    GradientThreshold=1, ...
    Verbose=true, ...
    Plots="none");

%% Predict future trajectory

YPred = predict(net, XTest);

%% Display results

disp("===== LSTM TRAJECTORY PREDICTION =====");

disp("Past trajectory:");
disp(XTest{1});

disp("Actual future trajectory:");
disp(YTest{1});

disp("Predicted future trajectory:");
disp(YPred{1});