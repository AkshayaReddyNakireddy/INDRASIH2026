function cost = calculatePathCost(path)
% CALCULATEPATHCOST
% SIH26037 - Path cost calculation
%
% Calculates the cost of a candidate path.
% Lower cost = better path.
%
% INPUT:
%   path - candidate path structure
%
% OUTPUT:
%   cost - numerical path cost

%% Collision paths are not selectable

if path.collision
    cost = Inf;
    return;
end

%% Clearance cost

% Larger clearance is better.
% Therefore, smaller value is preferred.
clearanceCost = 10 / max(path.minimumClearance, 0.1);

%% Path deviation cost

% Penalize large lateral movement.
finalLateralPosition = abs(path.y(end));

deviationCost = finalLateralPosition;

%% Total cost

cost = clearanceCost + deviationCost;

end