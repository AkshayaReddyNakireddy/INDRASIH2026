function output = riskOutput(tracks, predictions, riskAssessment)
%RISKOUTPUT Prepare tracking and collision-risk information
% for the decision-making module.
%
% Inputs:
%   tracks         - tracked objects
%   predictions    - predicted trajectories
%   riskAssessment - collision risk information
%
% Output:
%   output - structure passed to decision-making module

%% Default output

output = struct( ...
    'CriticalTrackID', 0, ...
    'CriticalClassID', 0, ...
    'CriticalTTC', Inf, ...
    'CriticalRiskLevel', 0, ...
    'CriticalLateralOffset', 0, ...
    'Tracks', tracks, ...
    'Predictions', predictions, ...
    'RiskAssessment', riskAssessment);

%% No risk information

if isempty(riskAssessment)
    return;
end

%% Find highest risk

riskLevels = [riskAssessment.RiskLevel];

highestRisk = max(riskLevels);

candidateIndices = find(riskLevels == highestRisk);

%% Select critical object

if numel(candidateIndices) > 1

    ttcValues = [riskAssessment(candidateIndices).TTC];

    [~, localIndex] = min(ttcValues);

    selectedIndex = candidateIndices(localIndex);

else

    selectedIndex = candidateIndices(1);

end

%% Store critical object information

critical = riskAssessment(selectedIndex);

output.CriticalTrackID = critical.TrackID;
output.CriticalClassID = critical.ClassID;
output.CriticalTTC = critical.TTC;
output.CriticalRiskLevel = critical.RiskLevel;
output.CriticalLateralOffset = critical.LateralOffset;

end