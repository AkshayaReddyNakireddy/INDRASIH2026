function [selectedPath, selectedIndex] = selectBestPath(paths)
% SELECTBESTPATH
% SIH26037 - Selects the safest and lowest-cost path.
%
% INPUT:
%   paths - candidate path structure array
%
% OUTPUT:
%   selectedPath - selected path name
%   selectedIndex - selected path index

%% Initialize

selectedPath = "NONE";
selectedIndex = 0;

bestCost = Inf;

%% Evaluate every candidate

for i = 1:length(paths)

    %% Calculate cost

    paths(i).cost = calculatePathCost(paths(i));

    %% Ignore unsafe paths

    if paths(i).collision
        continue;
    end

    %% Select lowest-cost safe path

    if paths(i).cost < bestCost

        bestCost = paths(i).cost;
        selectedIndex = i;
        selectedPath = paths(i).name;

    end

end

%% Display result

disp("========================================");
disp("       PATH SELECTION");
disp("========================================");

disp("Selected Path:");
disp(selectedPath);

if selectedIndex > 0
    disp("Selected Path Cost:");
    disp(bestCost);
else
    disp("WARNING: No safe path available.");
end

disp("========================================");

end