function vehicle = vehicleParameters()

% VEHICLEPARAMETERS
% SIH26037 - CSE3 Adaptive Path Planning
%
% Defines vehicle and planning parameters.

%% Vehicle dimensions

vehicle.length = 4.5;

vehicle.width = 1.8;

%% Safety parameters

vehicle.safety_margin = 1.0;

%% Planning parameters

vehicle.planning_horizon = 30;

vehicle.num_path_points = 60;

%% Candidate path offsets

% Positive Y = left
% Negative Y = right

vehicle.left_path_offset = 4.0;

vehicle.center_path_offset = 0.0;

vehicle.right_path_offset = -4.0;

%% Road boundary constraints

% Planning coordinate:
% Positive Y = left
% Negative Y = right
%
% These boundaries define the available
% lateral planning corridor.

vehicle.road_left_boundary = 5.0;

vehicle.road_right_boundary = -5.0;

%% Target speeds

vehicle.cruise_speed = 40;

vehicle.follow_speed = 25;

vehicle.slow_speed = 15;

vehicle.avoid_speed = 15;

vehicle.yield_speed = 5;

vehicle.stop_speed = 0;

end