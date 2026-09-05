clear;
clc;

%% Reset tracker state

clear objectTracker
clear trajectoryHistory

%% Ego vehicle

egoState.Position = [200 125];
egoState.Velocity = [0 0];
egoState.Heading = 0;

%% Simulate object approaching ego vehicle

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

    %% Run complete module

    output = runPredictionRisk( ...
        detections, egoState);

    %% Display frame result

    fprintf('\n==============================\n');
    fprintf('FRAME %d\n', frame);
    fprintf('==============================\n');

    fprintf('Number of tracks : %d\n', ...
        numel(output.Tracks));

    if output.CriticalTrackID ~= 0

        fprintf('Critical Track ID : %d\n', ...
            output.CriticalTrackID);

        fprintf('TTC               : %.3f\n', ...
            output.CriticalTTC);

        fprintf('Minimum Risk Level: %d\n', ...
            output.CriticalRiskLevel);

    else

        fprintf('No critical risk detected.\n');

    end

end

%% Final result

disp(" ");
disp("===== COMPLETE PREDICTION-RISK TEST FINISHED =====");