%% Test Trajectory History

clear;
clc;
clear objectTracker;
clear trajectoryHistory;

%% =========================
% FRAME 1
% ==========================

detections(1).Frame = 1;
detections(1).ClassID = 1;
detections(1).Confidence = 0.95;
detections(1).BoundingBox = [200 100 50 50];

detections(2).Frame = 1;
detections(2).ClassID = 2;
detections(2).Confidence = 0.90;
detections(2).BoundingBox = [200 250 40 40];

tracks1 = objectTracker(detections);

history1 = trajectoryHistory(tracks1);

%% =========================
% FRAME 2
% ==========================

detections(1).Frame = 2;
detections(1).BoundingBox = [150 100 50 50];

detections(2).Frame = 2;
detections(2).BoundingBox = [190 250 40 40];

tracks2 = objectTracker(detections);

history2 = trajectoryHistory(tracks2);

%% =========================
% FRAME 3
% ==========================

detections(1).Frame = 3;
detections(1).BoundingBox = [120 100 50 50];

detections(2).Frame = 3;
detections(2).BoundingBox = [180 250 40 40];

tracks3 = objectTracker(detections);

history3 = trajectoryHistory(tracks3);

%% =========================
% Display
% ==========================

disp("===== TRAJECTORY HISTORY =====");

for i = 1:numel(history3)

    fprintf("\nTrack ID : %d\n", ...
        history3(i).TrackID);

    fprintf("Class ID : %d\n", ...
        history3(i).ClassID);

    disp("Positions:");

    disp(history3(i).Positions);

end