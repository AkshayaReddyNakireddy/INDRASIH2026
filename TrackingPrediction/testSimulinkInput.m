%% Simulink Test Input

clear;
clc;
clear objectTracker;

%% Detection

detections.Frame = 1;
detections.ClassID = 1;
detections.Confidence = 0.95;
detections.BoundingBox = [200 100 50 50];

%% Ego state

egoPosition = [100 100];

egoVelocity = [0 0];

egoHeading = 0;