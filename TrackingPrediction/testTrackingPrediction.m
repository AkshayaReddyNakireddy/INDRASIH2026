%% Test Object Tracker
clc;
clear;

% Reset tracker between test runs
clear objectTracker;

%% Frame 1
detections(1).Frame = 1;
detections(1).ClassID = 1;
detections(1).Confidence = 0.95;
detections(1).BoundingBox = [100 100 50 50];

tracks1 = objectTracker(detections);

disp("FRAME 1");
disp(tracks1);

%% Frame 2
detections(1).Frame = 2;
detections(1).ClassID = 1;
detections(1).Confidence = 0.94;
detections(1).BoundingBox = [110 105 50 50];

tracks2 = objectTracker(detections);

disp("FRAME 2");
disp(tracks2);

%% Frame 3
detections(1).Frame = 3;
detections(1).ClassID = 1;
detections(1).Confidence = 0.93;
detections(1).BoundingBox = [120 110 50 50];

tracks3 = objectTracker(detections);

disp("FRAME 3");
disp(tracks3);

%% Display important information

fprintf("\nTracking Results:\n");

fprintf("Frame 1: TrackID = %d, Position = [%.1f %.1f], Velocity = [%.1f %.1f]\n", ...
    tracks1.TrackID, ...
    tracks1.Position(1), tracks1.Position(2), ...
    tracks1.Velocity(1), tracks1.Velocity(2));

fprintf("Frame 2: TrackID = %d, Position = [%.1f %.1f], Velocity = [%.1f %.1f]\n", ...
    tracks2.TrackID, ...
    tracks2.Position(1), tracks2.Position(2), ...
    tracks2.Velocity(1), tracks2.Velocity(2));

fprintf("Frame 3: TrackID = %d, Position = [%.1f %.1f], Velocity = [%.1f %.1f]\n", ...
    tracks3.TrackID, ...
    tracks3.Position(1), tracks3.Position(2), ...
    tracks3.Velocity(1), tracks3.Velocity(2));