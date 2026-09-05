function history = trajectoryHistory(tracks)
%TRAJECTORYHISTORY Store past positions of tracked objects.
%
% Input:
%   tracks - output from objectTracker
%
% Output:
%   history - structure containing position history for each TrackID

persistent positionHistory

% Initialize
if isempty(positionHistory)
    positionHistory = struct( ...
        'TrackID', {}, ...
        'ClassID', {}, ...
        'Positions', {});
end

% Maximum number of stored positions
maxHistoryLength = 10;

%% Process current tracks

for i = 1:numel(tracks)

    trackID = tracks(i).TrackID;
    currentPosition = tracks(i).Position;

    % Find existing track
    existingIndex = [];

    for j = 1:numel(positionHistory)

        if positionHistory(j).TrackID == trackID
            existingIndex = j;
            break;
        end

    end

    %% Existing object

    if ~isempty(existingIndex)

        oldPositions = positionHistory(existingIndex).Positions;

        % Add current position
        newPositions = [
            oldPositions;
            currentPosition
            ];

        % Keep only latest positions
        if size(newPositions, 1) > maxHistoryLength

            newPositions = ...
                newPositions(end-maxHistoryLength+1:end, :);

        end

        positionHistory(existingIndex).Positions = newPositions;

        %% New object

    else

        newIndex = numel(positionHistory) + 1;

        positionHistory(newIndex).TrackID = trackID;
        positionHistory(newIndex).ClassID = tracks(i).ClassID;
        positionHistory(newIndex).Positions = currentPosition;

    end

end

%% Return history

history = positionHistory;

end