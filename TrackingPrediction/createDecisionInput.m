function decisionInput = createDecisionInput( ...
    output)
%CREATEDECISIONINPUT Prepare prediction-risk output
% for the decision-making module.
%
% Input:
%   output - output from runPredictionRisk
%
% Output:
%   decisionInput - clean interface for decision making

%% Default output

decisionInput = struct( ...
    'CriticalTrackID', 0, ...
    'CriticalClassID', 0, ...
    'TTC', Inf, ...
    'RiskLevel', 0, ...
    'LateralOffset', 0, ...
    'ObjectPosition', [0 0], ...
    'ObjectVelocity', [0 0]);

%% No critical object

if output.CriticalTrackID == 0
    return;
end

%% Copy critical information

decisionInput.CriticalTrackID = ...
    output.CriticalTrackID;

decisionInput.CriticalClassID = ...
    output.CriticalClassID;

decisionInput.TTC = ...
    output.CriticalTTC;

decisionInput.RiskLevel = ...
    output.CriticalRiskLevel;

decisionInput.LateralOffset = ...
    output.CriticalLateralOffset;

%% Find corresponding track

for i = 1:numel(output.Tracks)

    if output.Tracks(i).TrackID == ...
            output.CriticalTrackID

        decisionInput.ObjectPosition = ...
            output.Tracks(i).Position;

        decisionInput.ObjectVelocity = ...
            output.Tracks(i).Velocity;

        break;

    end

end

end