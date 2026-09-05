clear;
clc;

%% Reset persistent states

clear objectTracker
clear trajectoryHistory

%% Ego vehicle

egoState.Position = [200 125];
egoState.Velocity = [0 0];
egoState.Heading = 0;

%% Simulated object positions

positions = [ ...
    300 125;
    280 125;
    260 125;
    240 125;
    220 125;
    200 125];

%% Process frames

for frame = 1:size(positions,1)

    %% Create detection

    bbox = [ ...
        positions(frame,1)-25, ...
        positions(frame,2)-25, ...
        50, ...
        50];

    detections = struct( ...
        'Frame', frame, ...
        'ClassID', 1, ...
        'Confidence', 0.95, ...
        'BoundingBox', bbox);

    %% Run prediction-risk module

    output = runPredictionRisk( ...
        detections, egoState);

    %% Create decision input

    decisionInput = createDecisionInput(output);

    %% Display

    fprintf('\n==============================\n');
    fprintf('FRAME %d\n', frame);
    fprintf('==============================\n');

    fprintf('Critical Track ID : %d\n', ...
        decisionInput.CriticalTrackID);

    fprintf('Critical Class ID : %d\n', ...
        decisionInput.CriticalClassID);

    fprintf('TTC               : %.3f\n', ...
        decisionInput.TTC);

    fprintf('Risk Level        : %d\n', ...
        decisionInput.RiskLevel);

    fprintf('Lateral Offset    : %.3f\n', ...
        decisionInput.LateralOffset);

    fprintf('Object Position   : [%.2f %.2f]\n', ...
        decisionInput.ObjectPosition(1), ...
        decisionInput.ObjectPosition(2));

    fprintf('Object Velocity   : [%.2f %.2f]\n', ...
        decisionInput.ObjectVelocity(1), ...
        decisionInput.ObjectVelocity(2));

end

%% Display final structure

disp(" ");
disp("===== FINAL DECISION INPUT =====");

disp(decisionInput);