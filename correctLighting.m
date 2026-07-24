function [rgbCorrected, grayCorrected] = correctLighting(rgb, gray)
% CORRECTLIGHTING Flatten illumination and denoises. 

effect = 80;


rgbCorrected = imflatfield(rgb, effect);
grayCorrected = imflatfield(gray, effect);

grayCorrected = adapthisteq(grayCorrected);

grayCorrected = medfilt2(grayCorrected, [3 3]);


end