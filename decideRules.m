function baselineDecision = decideRules(metrics)
% DECIDERULES Makes a decision based on:
%
%   good:       areaRatio 0.009 - 0.016
%   scratches:  areaRatio 0.040 - 0.061
%   major_rust: areaRatio 0.117 - 0.156
%   total_rust: areaRatio 0.228 - 0.242

ratioThreshold = 0.025; 
areaThreshold  = 3000; 

if metrics.areaRatio > ratioThreshold || metrics.maxArea > areaThreshold
    baselineDecision = "FAIL";
else
    baselineDecision = "PASS";
end
end