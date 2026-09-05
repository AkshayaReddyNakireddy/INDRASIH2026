function riskAssessment = predictionBasedRisk( ...
    tracks, predictions, egoState)
%PREDICTIONBASEDRISK Estimate collision risk using
% predicted trajectories and current object position.

%% Initialize output

riskAssessment = struct( ...
    'TrackID', {}, ...
    'ClassID', {}, ...
    'TTC', {}, ...
    'RiskLevel', {}, ...
    'LateralOffset', {}, ...
    'MinimumDistance', {});

%% Ego information

egoPosition = egoState.Position;
egoHeading = egoState.Heading;

forwardVector = [ ...
    cos(egoHeading), ...
    sin(egoHeading)];

leftVector = [ ...
    -sin(egoHeading), ...
     cos(egoHeading)];

%% Process objects

for i = 1:numel(tracks)

    trackID = tracks(i).TrackID;

    %% Find prediction belonging to this track

    predictionIndex = [];

    for j = 1:numel(predictions)

        if predictions(j).TrackID == trackID
            predictionIndex = j;
            break;
        end

    end

    %% No prediction available

    if isempty(predictionIndex)

        continue;

    end

    %% Current object position

    objectPosition = tracks(i).Position;

    %% Current distance from ego

    currentDistance = ...
        norm(objectPosition - egoPosition);

    %% Position relative to ego

    relativePosition = ...
        objectPosition - egoPosition;

    longitudinalDistance = ...
        dot(relativePosition, forwardVector);

    lateralOffset = ...
        dot(relativePosition, leftVector);

    %% Predicted trajectory

    predictedTrajectory = ...
        predictions(predictionIndex).Trajectory;

    predictedTimes = ...
        predictions(predictionIndex).PredictedTime;

    %% Find minimum predicted distance

    minimumPredictedDistance = Inf;
    predictedCollisionTime = Inf;

    for k = 1:size(predictedTrajectory,1)

        predictedPosition = ...
            predictedTrajectory(k,:);

        distance = ...
            norm(predictedPosition - egoPosition);

        if distance < minimumPredictedDistance

            minimumPredictedDistance = distance;

            predictedCollisionTime = ...
                predictedTimes(k);

        end

    end

    %% Use current position as well

    minimumDistance = min( ...
        currentDistance, ...
        minimumPredictedDistance);

    %% Object path check

    pathWidth = 40;

    objectInPath = ...
        abs(lateralOffset) <= pathWidth;

    %% Risk classification

    if currentDistance <= 10

        % Object is already extremely close
        riskLevel = 3;

    elseif minimumPredictedDistance <= 10 && objectInPath

        % Predicted collision
        riskLevel = 3;

    elseif minimumPredictedDistance <= 30 && ...
            predictedCollisionTime <= 2.0 && ...
            objectInPath

        riskLevel = 2;

    elseif minimumPredictedDistance <= 50 && ...
            predictedCollisionTime <= 4.0 && ...
            objectInPath

        riskLevel = 1;

    else

        riskLevel = 0;

    end

    %% Store result

    riskAssessment(end+1).TrackID = ...
        trackID;

    riskAssessment(end).ClassID = ...
        tracks(i).ClassID;

    riskAssessment(end).TTC = ...
        predictedCollisionTime;

    riskAssessment(end).RiskLevel = ...
        riskLevel;

    riskAssessment(end).LateralOffset = ...
        lateralOffset;

    riskAssessment(end).MinimumDistance = ...
        minimumDistance;

end

end