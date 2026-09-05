function output = runPredictionRisk(detections, egoState)
%RUNPREDICTIONRISK Complete tracking, prediction and collision-risk module.

%% Tracking

tracks = objectTracker(detections);

%% Store trajectory history

history = trajectoryHistory(tracks);

%% LSTM trajectory prediction

predictions = trajectoryPredictor(history);

%% Prediction-based collision risk

riskAssessment = predictionBasedRisk( ...
    tracks, ...
    predictions, ...
    egoState);

%% Final risk output

output = riskOutput( ...
    tracks, ...
    predictions, ...
    riskAssessment);

end