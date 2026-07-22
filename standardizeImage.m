function [rgb, gray] = standardizeImage(I, size)
% STANDARDIZEIMAGE Resize and returns two images, one in color and in gray scale

rgb = imresize(I, size);
gray = rgb2gray(rgb);
end