# INDRASIH2026
**INDRA --- Intelligent Navigation and Dynamic Risk Avoidance

Adaptive Path Planning and Collision Avoidance for Autonomous Vehicles on Unstructured Indian Roads

Project Name: INDRA
Full Form: Intelligent Navigation and Dynamic Risk Avoidance
Problem Statement: SIH26037 --- Adaptive Path Planning and Collision
Avoidance for Autonomous Vehicles on Unstructured Indian Roads
Platform: MATLAB / Simulink
Primary Focus: Perception, Tracking, Prediction, Dynamic Risk
Assessment, Decision Making, Path Planning, and Vehicle Control

1. Project Overview

INDRA is an autonomous-driving framework designed for challenging and
unstructured Indian road environments.

Unlike structured roads with clearly marked lanes and predictable
traffic, Indian roads can contain a mixture of:

Cars

Buses

Trucks

Two-wheelers

Auto-rickshaws

Bicycles

Pedestrians

Animals

Pushcarts

Unexpected obstacles

Vehicles entering or leaving the ego vehicle's path

INDRA aims to provide a complete perception-to-control pipeline that can
detect surrounding objects, track their motion, predict their future
trajectories, estimate collision risk, select appropriate driving
decisions, plan an avoidance path, and control the vehicle.

2. System Architecture

                    INDRA
        Intelligent Navigation and
          Dynamic Risk Avoidance

                         │
                         ▼
              ┌─────────────────────┐
              │ Camera / Sensor Data│
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │ Object Detection    │
              │                     │
              │ Vehicles            │
              │ Pedestrians         │
              │ Two-wheelers        │
              │ Other obstacles     │
              └──────────┬──────────┘
                         │
                    detections
                         │
                         ▼
              ┌─────────────────────┐
              │ Object Tracking     │
              │                     │
              │ Track ID            │
              │ Position            │
              │ Velocity            │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │ Trajectory History  │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │ LSTM Trajectory     │
              │ Prediction          │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │ Collision Risk      │
              │ Assessment          │
              │                     │
              │ TTC                 │
              │ Predicted Distance  │
              │ Lateral Offset      │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │ Critical Object     │
              │ Selection           │
              └──────────┬──────────┘
                         │
                    decisionInput
                         │
                         ▼
              ┌─────────────────────┐
              │ Decision Making     │
              │ / Stateflow         │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │ Path Planning       │
              │                     │
              │ Continue            │
              │ Slow Down           │
              │ Brake               │
              │ Avoid Left/Right    │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │ Vehicle Controller  │
              └──────────┬──────────┘
                         │
                         ▼
                    Ego Vehicle

3. INDRA Team Module Structure

The project is divided into major modules:

INDRA
│
├── Object Detection
│   └── Detect surrounding road objects
│
├── Tracking & Prediction
│   ├── Object tracking
│   ├── Velocity estimation
│   ├── Trajectory history
│   ├── LSTM trajectory prediction
│   └── Collision risk assessment
│
├── Decision Making
│   └── Select safe driving action
│
├── Path Planning
│   └── Generate collision-free path
│
├── Vehicle Control
│   └── Convert planned path into vehicle commands
│
└── Simulation & Integration
    └── Integrate and demonstrate the complete system

4. Prediction, Tracking and Collision Risk Module

This module processes detected objects and determines which object
represents the most immediate collision threat.

Processing Pipeline

detections
     │
     ▼
Object Tracker
     │
     ▼
Track ID + Position + Velocity
     │
     ▼
Trajectory History
     │
     ▼
LSTM Prediction
     │
     ▼
Future Trajectory
     │
     ▼
Collision Risk Assessment
     │
     ▼
Critical Risk Selection
     │
     ▼
decisionInput

5. Detection Input Interface

The object detector provides detections frame by frame.

The agreed detection structure is:

detections(1).Frame = 120;
detections(1).ClassID = 2;
detections(1).Confidence = 0.91;
detections(1).BoundingBox = [420 250 85 110];

Fields

Field           Description

Frame         Current frame number
ClassID       Detected object class
Confidence    Detection confidence, from 0 to 1
BoundingBox   [X Y Width Height]

The detector does not assign persistent Track IDs.

6. Object Tracking

The tracking module associates detections between frames and assigns
persistent Track IDs.

Example output:

tracks(1).TrackID = 7;
tracks(1).ClassID = 2;
tracks(1).Confidence = 0.91;
tracks(1).BoundingBox = [420 250 85 110];
tracks(1).Position = [462.5 305];
tracks(1).Velocity = [12.4 1.8];

Tracking outputs

Persistent TrackID

ClassID

Detection confidence

Bounding box

Object position

Object velocity

The current prototype uses position-based nearest-neighbor association.

7. Trajectory History

The system stores recent positions for each tracked object.

Current prototype configuration:

History length = 10 positions

The LSTM predictor uses the most recent five positions.

Example:

Track 1:

[225 125]
[175 125]
[145 125]
...

This historical information is used to estimate the object's motion
pattern.

8. LSTM Trajectory Prediction

INDRA uses an LSTM-based neural network as a prototype trajectory
predictor.

Current training setup

Training sequences : 2000
History length     : 5 time steps
Prediction length  : 5 time steps
LSTM units         : 64
Fully connected    : 32
Optimizer          : Adam
Initial LR         : 0.001
Maximum epochs     : 30
Mini-batch size    : 32

The training data currently consists of synthetic motion trajectories
containing position, velocity, and acceleration variation.

The model uses relative coordinates to improve trajectory prediction:

Past positions
      ↓
Reference = latest position
      ↓
Convert to relative coordinates
      ↓
LSTM
      ↓
Predicted relative trajectory
      ↓
Convert back to position coordinates

The trained network is stored as:

trajectoryLSTM.mat

Important note

The current LSTM is a working prototype trained on synthetic data. Its
training RMSE demonstrates that the network is learning the generated
trajectories, but a real-world accuracy percentage has not yet been
established.

Future work should evaluate the model on real Indian-road trajectory
data and report validation/test metrics.

9. Collision Risk Assessment

The prediction-based risk module evaluates future object positions
relative to the ego vehicle.

The current prototype considers:

Current object distance

Minimum predicted distance

Predicted collision time

Lateral offset

Whether the object lies within the relevant path region

Risk Levels

Risk Level Meaning

       `0` SAFE
       `1` LOW
       `2` MEDIUM
       `3` HIGH / CRITICAL

The critical object is selected using:

Highest risk level

Lowest TTC when multiple objects have the same risk level

10. Decision Input Interface

The final interface between the Prediction/Risk module and Decision
Making is:

decisionInput = struct( ...
    'CriticalTrackID', 0, ...
    'CriticalClassID', 0, ...
    'TTC', Inf, ...
    'RiskLevel', 0, ...
    'LateralOffset', 0, ...
    'ObjectPosition', [0 0], ...
    'ObjectVelocity', [0 0]);

Meaning

Field               Meaning

CriticalTrackID   Track ID of the most dangerous object
CriticalClassID   Class of the critical object
TTC               Estimated time to predicted closest approach
RiskLevel         0--3 collision risk
LateralOffset     Object's lateral position relative to ego path
ObjectPosition    Current object position
ObjectVelocity    Current object velocity

This interface intentionally hides the internal implementation of
tracking and prediction from the decision-making module.

11. Example Working Test

A synthetic approaching-object scenario was used to verify the complete
pipeline.

Ego vehicle

egoState.Position = [200 125];
egoState.Velocity = [0 0];
egoState.Heading = 0;

Object positions

Frame 1 → [300 125]
Frame 2 → [280 125]
Frame 3 → [260 125]
Frame 4 → [240 125]
Frame 5 → [220 125]
Frame 6 → [200 125]

The object moves toward the ego vehicle with:

Velocity = [-20 0]

Final result

Critical Track ID : 1
Critical Class ID : 1
TTC               : 0.500 s
Risk Level        : 3
Lateral Offset    : 0
Object Position   : [200 125]
Object Velocity   : [-20 0]

This confirms that the current prototype can identify an approaching
object and classify the situation as high collision risk.

12. Current MATLAB Files

The Prediction, Tracking and Risk module currently contains:

objectTracker.m
trajectoryHistory.m
trajectoryPredictor.m
predictionBasedRisk.m
riskOutput.m
runPredictionRisk.m
createDecisionInput.m
trainTrajectoryLSTM.m
generateTrajectoryData.m
trajectoryLSTM.mat
testDecisionInput.m

13. Main Functions

objectTracker.m

Assigns persistent Track IDs and estimates velocity from consecutive
positions.

trajectoryHistory.m

Stores recent positions for each tracked object.

trajectoryPredictor.m

Loads the trained LSTM and predicts future object positions.

predictionBasedRisk.m

Calculates predicted collision risk.

riskOutput.m

Selects and exposes the most critical risk.

runPredictionRisk.m

Runs the complete tracking → prediction → risk pipeline.

createDecisionInput.m

Converts the risk output into the standard interface used by the
decision-making module.

14. MATLAB Toolboxes

The current development environment includes:

MATLAB

Simulink

Deep Learning Toolbox

Computer Vision Toolbox

Image Processing Toolbox

Sensor Fusion and Tracking Toolbox

Lidar Toolbox

Navigation Toolbox

Stateflow

Statistics and Machine Learning Toolbox

MATLAB Coder

Note

Automated Driving Toolbox is not currently installed in the development
environment. Therefore, the present prototype avoids depending on
Automated Driving Toolbox-specific APIs.

15. Current Project Status

Completed

Object detection interface defined

Object tracking prototype

Persistent Track ID assignment

Velocity estimation

Trajectory history

Synthetic trajectory data generation

LSTM trajectory prediction prototype

Prediction-based collision-risk assessment

Risk-level classification

Critical object selection

decisionInput interface

Basic end-to-end MATLAB test

High-risk collision scenario successfully demonstrated

In Progress

Multi-scenario testing

Multi-object stress testing

Visualization of historical and predicted trajectories

Integration with the final object detector

Integration with decision-making

Final Simulink integration

Future Improvements

Real Indian-road trajectory dataset

LSTM validation/test evaluation

Camera calibration or world-coordinate conversion

Ego-vehicle motion compensation

Vehicle/object dimensions in collision checking

More robust multi-object data association

Improved TTC estimation

Real-time performance testing

Hardware/embedded deployment if required

16. Current Limitations

The current system is a prototype and should not be interpreted as a
production autonomous-driving system.

Important limitations include:

The current trajectory model is trained on synthetic trajectories.

Pixel/image coordinates are not equivalent to physical distance
unless calibrated.

Current risk estimation uses simplified geometric assumptions.

Ego vehicle future motion is not yet fully incorporated into
predicted collision distance.

Object dimensions are not yet fully incorporated into collision
checking.

Tracking currently uses a simple nearest-neighbor association
strategy.

Real-world detector integration is still pending.

Full Simulink integration is still pending.

These limitations are intended targets for further development.

17. Final Integration Target

The final INDRA system should operate as:

Camera / Sensor
      ↓
Object Detection
      ↓
Object Tracking
      ↓
Motion / Trajectory Prediction
      ↓
Dynamic Collision Risk
      ↓
Critical Object Selection
      ↓
Decision Making
      ↓
Adaptive Path Planning
      ↓
Vehicle Controller
      ↓
Autonomous Vehicle

The system should dynamically respond to changing road conditions
instead of assuming fixed lanes or predictable traffic behavior.

18. Hackathon Demonstration Scenario

A recommended final demonstration is:

Indian-style unstructured road
        ↓
Multiple road users detected
        ↓
Objects receive Track IDs
        ↓
Object trajectories are tracked
        ↓
Future trajectories are predicted
        ↓
One object suddenly becomes dangerous
        ↓
TTC decreases
        ↓
Risk changes:
SAFE → LOW → MEDIUM → HIGH
        ↓
Critical object selected
        ↓
Decision module receives decisionInput
        ↓
Vehicle slows / brakes / changes path
        ↓
Collision is avoided

This demonstrates the complete purpose of INDRA:

Intelligent Navigation and Dynamic Risk Avoidance in unpredictable
road environments.

19. Team Integration Contract

Each module should communicate through clearly defined interfaces.

Object Detection
      │
      │ detections
      ▼
Tracking + Prediction + Risk
      │
      │ decisionInput
      ▼
Decision Making
      │
      │ action
      ▼
Path Planning
      │
      │ planned path
      ▼
Vehicle Controller
      │
      ▼
Vehicle

Modules should remain independent wherever possible so that one teammate
can replace or improve an internal algorithm without requiring the
entire system to be rewritten.

20. INDRA Vision

INDRA aims to move autonomous driving beyond ideal lane-marked
environments toward the realities of unstructured roads, where traffic
participants are diverse, behavior can be unpredictable, and collision
risk can change rapidly.

The core principle is:

PERCEIVE → TRACK → PREDICT → ASSESS RISK → DECIDE → PLAN → CONTROL

INDRA --- Intelligent Navigation and Dynamic Risk Avoidance**
