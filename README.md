# INDRA — Intelligent Navigation and Dynamic Risk Avoidance

## Adaptive Path Planning and Collision Avoidance for Autonomous Vehicles on Unstructured Indian Roads

**Project:** INDRA  
**Full Form:** Intelligent Navigation and Dynamic Risk Avoidance  
**SIH Problem Statement:** SIH26037  
**Platform:** MATLAB / Simulink

---

## 🚗 Project Overview

INDRA is an autonomous vehicle framework designed for **unstructured and unpredictable Indian road environments**.

Indian roads contain diverse road users such as:

- Cars
- Buses
- Trucks
- Two-wheelers
- Auto-rickshaws
- Bicycles
- Pedestrians
- Animals
- Pushcarts
- Unexpected obstacles

Unlike conventional autonomous driving systems that depend heavily on fixed lane markings and predictable traffic behavior, INDRA focuses on **dynamic perception, motion prediction, collision-risk assessment, adaptive decision making, and path planning**.

The system continuously observes surrounding objects, tracks their motion, predicts their future trajectories, evaluates collision risk, and provides information to the decision-making module for safe navigation.

---

# 🧠 System Architecture

```text
                    INDRA
     Intelligent Navigation and Dynamic
              Risk Avoidance

                       │
                       ▼
              ┌─────────────────┐
              │ Camera / Sensor │
              │      Data       │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Object Detection│
              │                 │
              │ Cars            │
              │ Pedestrians     │
              │ Two-wheelers    │
              │ Obstacles       │
              └────────┬────────┘
                       │
                  detections
                       │
                       ▼
              ┌─────────────────┐
              │ Object Tracking │
              │                 │
              │ Track ID        │
              │ Position        │
              │ Velocity        │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Trajectory      │
              │ History         │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ LSTM Trajectory │
              │ Prediction      │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Collision Risk  │
              │ Assessment      │
              │                 │
              │ TTC             │
              │ Predicted       │
              │ Distance        │
              │ Lateral Offset  │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Critical Object │
              │ Selection       │
              └────────┬────────┘
                       │
                  decisionInput
                       │
                       ▼
              ┌─────────────────┐
              │ Decision Making │
              │ / Stateflow     │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Path Planning   │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Vehicle Control │
              └────────┬────────┘
                       │
                       ▼
                 Ego Vehicle
