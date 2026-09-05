function riskAssessment = collisionRisk(tracks, predictions, egoState)
%COLLISIONRISK Estimate collision risk using TTC and path position.

riskAssessment = struct( ...
    'TrackID', {}, ...
    'ClassID', {}, ...
    'TTC', {}, ...
    'RiskLevel', {}, ...
    'LateralOffset', {});

egoPosition = egoState.Position;
egoVelocity = egoState.Velocity;
egoHeading = egoState.Heading;

% Ego vehicle forward direction
forwardVector = [cos(egoHeading), sin(egoHeading)];

% Left direction relative to ego vehicle
leftVector = [-sin(egoHeading), cos(egoHeading)];

for i = 1:numel(tracks)

    % Object position and velocity
    objectPosition = tracks(i).Position;
    objectVelocity = tracks(i).Velocity;

    % Relative position and velocity
    relativePosition = objectPosition - egoPosition;
    relativeVelocity = objectVelocity - egoVelocity;

    % Distance
    distance = norm(relativePosition);

    % Distance in front of ego vehicle
    longitudinalDistance = ...
        dot(relativePosition, forwardVector);

    % Distance to left/right of ego path
    lateralOffset = ...
        dot(relativePosition, leftVector);

    % Closing speed
    if distance > 0

        closingSpeed = ...
            -dot(relativePosition, relativeVelocity) / distance;

    else

        closingSpeed = Inf;

    end

    % TTC
    if closingSpeed > 0

        TTC = distance / closingSpeed;

    else

        TTC = Inf;

    end

    % Define prototype path width
    pathWidth = 40;

    % Object must be ahead AND within path
    objectInPath = ...
        longitudinalDistance > 0 && ...
        abs(lateralOffset) <= pathWidth;

    % Risk classification
    if objectInPath

        if TTC < 1.0

            riskLevel = 3;       % HIGH

        elseif TTC < 2.0

            riskLevel = 2;       % MEDIUM

        elseif TTC < 4.0

            riskLevel = 1;       % LOW

        else

            riskLevel = 0;       % SAFE

        end

    else

        riskLevel = 0;

    end

    % Store result
    riskAssessment(i).TrackID = tracks(i).TrackID;
    riskAssessment(i).ClassID = tracks(i).ClassID;
    riskAssessment(i).TTC = TTC;
    riskAssessment(i).RiskLevel = riskLevel;
    riskAssessment(i).LateralOffset = lateralOffset;

end

end