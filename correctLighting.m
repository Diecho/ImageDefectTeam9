function [rgbCorrected, grayCorrected] = correctLighting(rgb, gray)
% CORRECTLIGHTING Flatten uneven illumination. 

effect = 80;


rgbCorrected = imflatfield(rgb, effect);
grayCorrected = imflatfield(gray, effect);
end