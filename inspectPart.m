function [finalLabel, confidenceScore, evidenceOverlay, evidenceMetrics, baselineDecision] = inspectPart(I, net)

% Task 2 (Image Processing Pipeline)
[rgb, gray] = standardizeImage(I, [512 512]);
partMask = segmentPart(rgb);
[rgbCorrected, grayCorrected] = correctLighting(rgb, gray);
[evidenceMask, ~, ~] = defectEvidence(rgbCorrected, grayCorrected, partMask);
evidenceMetrics = extractMetrics(evidenceMask);
baselineDecision = decideRules(evidenceMetrics);

% Task 3 (AI)
roiForNet = imresize(rgbCorrected, [224 224]);
[finalLabel, confidenceScore] = classify(net, roiForNet);

% Image Overlay 
evidenceOverlay = rgbCorrected;
redChannel = evidenceOverlay(:,:,1);
redChannel(evidenceMask) = 255;
evidenceOverlay(:,:,1) = redChannel;

end
