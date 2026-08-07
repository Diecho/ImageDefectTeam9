function results = runInspectionSuite(imds, net, distortFcn)
% RUNINSPECTIONSUITE: Evaluates the AI results.
%   DistortFcn (optional): function applied to each image

if nargin < 3
    distortFcn = [];
end

n = numel(imds.Files);

% Extract truth values
filepath       = string(imds.Files);
trueDefectType = string(imds.Labels);
trueLabel      = strings(n, 1);

% Create empty arrays
aiPred        = strings(n,1);
aiLabel       = strings(n,1);
baselinePred  = strings(n,1);
agreementTier = strings(n,1);
AIDecisionIsCorrect = false(n,1);

for i = 1:n
    I = readimage(imds, i);

    % Apply distortion (Task 5)
    if ~isempty(distortFcn)
        I = distortFcn(I);
    end

    % True PASS/FAIL label
    if trueDefectType(i) == "good"
        trueLabel(i) = "PASS";
    else
        trueLabel(i) = "FAIL";
    end

    % Run AI detection
    [finalLabel, ~, ~, ~, baselineDecision] = inspectPart(I, net);

    % AI defect type
    aiLabel(i) = string(finalLabel);

    % AI PASS/FAIL label
    if finalLabel == "good"
        aiPassFail = "PASS";
    else
        aiPassFail = "FAIL";
    end
    aiPred(i) = aiPassFail;

    % Task 2 PASS/FAIL label
    baselinePred(i) = baselineDecision;

    % Check for agreement
    if aiPassFail == baselineDecision
        agreementTier(i) = "Agree-" + aiPassFail;
    else
        agreementTier(i) = "Unsure";
    end

    % Compare true value with AI predicted value
    AIDecisionIsCorrect(i) = (aiPassFail == trueLabel(i));
end

% Put everything together in one table
results = table(filepath, trueDefectType, trueLabel, ...
    aiLabel, aiPred, baselinePred, agreementTier, AIDecisionIsCorrect);
end