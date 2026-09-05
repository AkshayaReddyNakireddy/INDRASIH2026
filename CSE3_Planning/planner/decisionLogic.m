function decision = decisionLogic(decisionInput)
% DECISIONLOGIC
% SIH26037 - CSE3 Decision Logic
%
% Determines the vehicle driving decision from:
%   RiskLevel
%   TTC
%   LateralOffset
%   CriticalClassID
%
% Decisions:
%   CRUISE
%   FOLLOW
%   SLOW
%   YIELD
%   AVOID
%   STOP

%% ============================================================
% 1. READ INPUTS
% ============================================================

riskLevel = decisionInput.RiskLevel;
ttc = decisionInput.TTC;
lateralOffset = decisionInput.LateralOffset;
criticalClassID = decisionInput.CriticalClassID;

%% ============================================================
% 2. DEFAULT DECISION
% ============================================================


%% ============================================================
% 3. CRITICAL RISK / IMMEDIATE COLLISION
% ============================================================

if riskLevel >= 3
    decision = "STOP";
    return;
end

%% ============================================================
% 4. VERY LOW TTC
% ============================================================

if isfinite(ttc) && ttc > 0 && ttc <= 1.5
    decision = "STOP";
    return;
end

%% ============================================================
% 5. HIGH RISK
% ============================================================

if riskLevel == 2

    % Object is close to the vehicle's current path.
    if abs(lateralOffset) <= 2.0
        decision = "AVOID";
        return;
    end

    % Object is laterally separated from the current path.
    decision = "YIELD";
    return;
end

%% ============================================================
% 6. MEDIUM RISK
% ============================================================

if riskLevel == 1

    if isVehicleLikeClass(criticalClassID)
        decision = "FOLLOW";
    else
        decision = "SLOW";
    end

    return;
end

%% ============================================================
% 7. LOW RISK
% ============================================================

decision = "CRUISE";

end


function result = isVehicleLikeClass(classID)
% ISVEHICLELIKECLASS
% Returns true for vehicle-like object classes.
%
% NOTE:
% Class-ID mapping must match the final perception dataset.

vehicleClasses = [1 2 3 4];

result = any(classID == vehicleClasses);

end