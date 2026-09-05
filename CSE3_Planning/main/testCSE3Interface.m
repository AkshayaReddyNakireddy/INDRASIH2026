clc;
clear;
close all;

%% Load Akshaya-compatible test input

[objects, decisionInput] = scenario_testAkshayaInput();

%% Run CSE3 planner

output = cse3Planner(objects, decisionInput);

%% Display planner output

disp("========================================");
disp("       CSE3 PLANNER OUTPUT");
disp("========================================");

disp("Decision:");
disp(output.decision);

disp("Selected Path:");
disp(output.selectedPath);

disp("Target Speed:");
disp(output.targetSpeed);