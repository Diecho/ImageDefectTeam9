function partMask = segmentPart(rgb)
% SEGMENTPART Silhouette mask of the part

grayForMask = rgb2gray(rgb);
bw = imbinarize(grayForMask, 'adaptive', 'Sensitivity', 0.6);
bw = ~bw;
bw = bwareafilt(bw, 1);
partMask = imfill(bw, 'holes');

end