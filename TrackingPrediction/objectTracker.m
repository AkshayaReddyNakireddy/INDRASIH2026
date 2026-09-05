function tracks = objectTracker(detections)
%OBJECTTRACKER Track detected objects between frames.
%
% Input:
%   detections - structure containing:
%       Frame
%       ClassID
%       Confidence
%       BoundingBox [X Y Width Height]
%
% Output:
%   tracks - structure containing:
%       TrackID
%       ClassID
%       Confidence
%       BoundingBox
%       Position [X Y]
%       Velocity [Vx Vy]

persistent previousTracks nextTrackID

% Initialize persistent variables
if isempty(nextTrackID)
    nextTrackID = 1;
end

if isempty(previousTracks)
    previousTracks = struct([]);
end

% No detections
if isempty(detections)
    tracks = struct([]);
    return;
end

% Create output structure
tracks = struct( ...
    'TrackID', {}, ...
    'ClassID', {}, ...
    'Confidence', {}, ...
    'BoundingBox', {}, ...
    'Position', {}, ...
    'Velocity', {});

%% Process each detection

for i = 1:numel(detections)

    % Bounding box
    bbox = detections(i).BoundingBox;

    % Calculate center of bounding box
    currentPosition = [ ...
        bbox(1) + bbox(3)/2, ...
        bbox(2) + bbox(4)/2];

    % Default values
    trackID = [];
    velocity = [0 0];

    %% Match with previous track

    if ~isempty(previousTracks)

        % Calculate distance from every previous track
        distances = zeros(1, numel(previousTracks));

        for j = 1:numel(previousTracks)

            distances(j) = norm( ...
                currentPosition - previousTracks(j).Position);

        end

        % Find nearest previous object
        [minimumDistance, nearestIndex] = min(distances);

        % Maximum allowed movement
        maxDistance = 100;

        if minimumDistance <= maxDistance

            % Same object
            trackID = previousTracks(nearestIndex).TrackID;

            % Calculate displacement
            previousPosition = previousTracks(nearestIndex).Position;

            velocity = currentPosition - previousPosition;

        end
    end

    %% Create new track if no match

    if isempty(trackID)

        trackID = nextTrackID;

        nextTrackID = nextTrackID + 1;

        velocity = [0 0];

    end

    %% Store result

    tracks(i).TrackID = trackID;
    tracks(i).ClassID = detections(i).ClassID;
    tracks(i).Confidence = detections(i).Confidence;
    tracks(i).BoundingBox = bbox;
    tracks(i).Position = currentPosition;
    tracks(i).Velocity = velocity;

end

%% Save current tracks for next frame

previousTracks = tracks;

end