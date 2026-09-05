function [objects, decisionInput] = scenario_testAkshayaInput()
% SCENARIO_TESTAKSHAYAINPUT
% Test input matching Akshaya's tracking output structure.

%% Object 1

objects(1).TrackID = 1;
objects(1).ClassID = 1;
objects(1).Confidence = 0.95;

objects(1).BoundingBox = [130 110 60 40];

objects(1).Position = [145 125];

objects(1).Velocity = [-30 0];
objects(1).PlanningPosition = [25 0];

objects(1).PlanningTrajectory = [
    25  0
    22  0
    19  0
    16  0
    13  0
    ];

objects(1).PlanningPredictionTime = [
    0
    1
    2
    3
    4
    ];


%% Object 2

objects(2).TrackID = 2;
objects(2).ClassID = 2;
objects(2).Confidence = 0.91;

objects(2).BoundingBox = [300 150 50 35];

objects(2).Position = [325 167];

objects(2).Velocity = [-15 0];


%% Object 3

objects(3).TrackID = 3;
objects(3).ClassID = 3;
objects(3).Confidence = 0.88;

objects(3).BoundingBox = [500 180 45 35];

objects(3).Position = [522 197];

objects(3).Velocity = [-10 0];


%% Critical-object decision input

decisionInput.CriticalTrackID = 1;

decisionInput.CriticalClassID = 1;

decisionInput.TTC = 1.963;

decisionInput.RiskLevel = 2;

decisionInput.LateralOffset = 25;

decisionInput.ObjectPosition = [145 125];

decisionInput.ObjectVelocity = [-30 0];

end