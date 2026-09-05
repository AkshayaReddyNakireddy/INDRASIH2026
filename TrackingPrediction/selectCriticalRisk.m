function criticalRisk = selectCriticalRisk(riskAssessment)
%SELECTCRITICALRISK Select the most dangerous tracked object.
%
% Input:
%   riskAssessment - output from collisionRisk
%
% Output:
%   criticalRisk - most dangerous object

% Default output
criticalRisk = struct( ...
    'TrackID', 0, ...
    'ClassID', 0, ...
    'TTC', Inf, ...
    'RiskLevel', 0, ...
    'LateralOffset', 0);

% No risk information
if isempty(riskAssessment)
    return;
end

% Find highest risk level
riskLevels = [riskAssessment.RiskLevel];

highestRisk = max(riskLevels);

% Find objects with highest risk
candidateIndices = find(riskLevels == highestRisk);

% If multiple objects have same risk,
% select the one with smallest TTC
if numel(candidateIndices) > 1

    ttcValues = [riskAssessment(candidateIndices).TTC];

    [~, localIndex] = min(ttcValues);

    selectedIndex = candidateIndices(localIndex);

else

    selectedIndex = candidateIndices(1);

end

% Copy selected object
criticalRisk = riskAssessment(selectedIndex);

end