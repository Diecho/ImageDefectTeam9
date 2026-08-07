function [evidenceMask, rustMask, scratchMask] = defectEvidence(rgbCorrected, grayCorrected, partMask)
% DEFECTEVIDENCE Detects rusted and scratched regions:
%   rustMask: color-based 
%   scratchMask: edge/intensity-based 

    partMask = imerode(partMask, strel('disk', 6));

    % Rust detection
    hsv = rgb2hsv(rgbCorrected);
    hue = hsv(:,:,1);
    sat = hsv(:,:,2);

    rustMask = ((hue < 0.18) | (hue > 0.95)) & (sat > 0.10); % Specific color based on trial and error

    % Scratch detection
    edges = edge(grayCorrected, 'Canny',  [0.14 0.15]);
    darkMask = grayCorrected < (mean(grayCorrected(partMask)) - 0.08);
    scratchMask = edges & darkMask;
    
    % Cleaning
    scratchMask = imdilate(scratchMask, strel('disk', 5));
    rustMask = imfill(rustMask, 'holes');
    scratchMask = bwareaopen(scratchMask, 20);

   % Combine both evidence rust and scratch
    evidenceMask = (rustMask | scratchMask) & partMask;

    % Remove noise and smoothing
    evidenceMask = bwareaopen(evidenceMask, 15);
    evidenceMask = imclose(evidenceMask, strel('disk', 2));

    % Clean background
    rustMask = rustMask & partMask;
    scratchMask = scratchMask & partMask;
end