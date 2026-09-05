function net = trainTrajectoryLSTM()
%TRAINTROJECTORYLSTM Train an LSTM for trajectory prediction.

%% Generate training data

[XTrain, YTrain] = generateTrajectoryData(1000);

%% LSTM architecture

layers = [
    sequenceInputLayer(2)

    lstmLayer(64, OutputMode="sequence")

    fullyConnectedLayer(32)

    reluLayer

    fullyConnectedLayer(2)

    regressionLayer
    ];

%% Training options

options = trainingOptions("adam", ...
    MaxEpochs=20, ...
    MiniBatchSize=32, ...
    InitialLearnRate=0.001, ...
    Shuffle="every-epoch", ...
    GradientThreshold=1, ...
    Verbose=true, ...
    Plots="none");

%% Train network

net = trainNetwork(XTrain, YTrain, layers, options);

%% Save trained network

save("trajectoryLSTM.mat", "net");

disp(" ");
disp("===== LSTM TRAINING COMPLETE =====");
disp("Network saved as trajectoryLSTM.mat");

end