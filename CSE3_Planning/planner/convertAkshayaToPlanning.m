function [planningObjects, adapterStatus] = convertAkshayaToPlanning(tracks)
% CONVERTAKSHAYATOPLANNING
% SIH26037 - CSE3 Coordinate Adapter
%
% Converts Akshaya's tracked-object structure into the
% planning-object interface required by CSE3.
%
% IMPORTANT:
% Akshaya's Position and Velocity are currently in image
% coordinates (pixels / pixels per frame).
%
% Therefore this function DOES NOT perform a fake pixel-to-metre
% conversion.
%
% Until camera/LiDAR calibration or sensor-fusion conversion is
% available, only objects containing a valid PlanningPosition
% field are passed to the metric planner.
%
% INPUT:
%   tracks
%       Akshaya tracking structure:
%       TrackID
%       ClassID
%       Confidence
%       BoundingBox
%       Position
%       Velocity
%
%       Optional test/integration field:
%       PlanningPosition = [forwardDistance lateralDistance]
%                         in metres
%
% OUTPUT:
%   planningObjects
%       Structure used by CSE3 collision/path planning:
%
%       TrackID
%       Position
%
%   adapterStatus
%       Information about the conversion status.

%% ============================================================
%  INITIALIZE OUTPUT
% =============================================================

planningObjects = struct( ...
    'TrackID', {}, ...
    'Position', {});

adapterStatus.totalTracks = length(tracks);
adapterStatus.convertedTracks = 0;
adapterStatus.rejectedTracks = 0;
adapterStatus.conversionAvailable = false;
adapterStatus.message = "";

%% ============================================================
%  HANDLE EMPTY INPUT
% =============================================================

if isempty(tracks)

    adapterStatus.message = ...
        "No tracked objects received.";

    return;
end

%% ============================================================
%  CHECK EACH TRACK
% =============================================================

for i = 1:length(tracks)

    %% --------------------------------------------------------
    % Check TrackID
    % ---------------------------------------------------------

    if ~isfield(tracks(i), 'TrackID')

        adapterStatus.rejectedTracks = ...
            adapterStatus.rejectedTracks + 1;

        continue;
    end

    %% --------------------------------------------------------
    % Check PlanningPosition
    %
    % This is the ONLY currently accepted metric-coordinate
    % interface.
    % ---------------------------------------------------------

    if ~isfield(tracks(i), 'PlanningPosition')

        adapterStatus.rejectedTracks = ...
            adapterStatus.rejectedTracks + 1;

        continue;
    end

    planningPosition = tracks(i).PlanningPosition;

    %% --------------------------------------------------------
    % Validate PlanningPosition
    % ---------------------------------------------------------

    if ~isnumeric(planningPosition) || ...
            numel(planningPosition) < 2

        adapterStatus.rejectedTracks = ...
            adapterStatus.rejectedTracks + 1;

        continue;
    end

    planningPosition = planningPosition(1:2);

    %% --------------------------------------------------------
    % Check for invalid numerical values
    % ---------------------------------------------------------

    if any(~isfinite(planningPosition))

        adapterStatus.rejectedTracks = ...
            adapterStatus.rejectedTracks + 1;

        continue;
    end

    %% --------------------------------------------------------
    % Store converted planning object
    %
    % Position:
    %   [forwardDistance lateralDistance]
    %   metres
    % ---------------------------------------------------------

    index = adapterStatus.convertedTracks + 1;

    planningObjects(index).TrackID = ...
        tracks(i).TrackID;

    planningObjects(index).Position = ...
        planningPosition;

    adapterStatus.convertedTracks = index;

end

%% ============================================================
%  DETERMINE ADAPTER STATUS
% =============================================================

if adapterStatus.convertedTracks > 0

    adapterStatus.conversionAvailable = true;

    adapterStatus.message = ...
        "Metric planning positions available.";

else

    adapterStatus.conversionAvailable = false;

    adapterStatus.message = ...
        "No metric planning positions available. " + ...
        "Camera/LiDAR coordinate conversion is required.";

end

end