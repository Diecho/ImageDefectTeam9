% Used in inspectPart.m
function [aiLabel, aiScores] = classify(net, roiForNet)
scores = predict(net, roiForNet);
classNames = net.Layers(end).Classes;
[aiScores, idx] = max(scores);
aiLabel = classNames(idx); 
end
