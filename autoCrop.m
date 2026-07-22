function roi = autoCrop(rgb)
% AUTOCROP Removes background 

grayForMask = rgb2gray(rgb);
bw = imbinarize(grayForMask, 'adaptive', 'Sensitivity', 0.6);
bw = ~bw;  
bw = bwareafilt(bw, 1);
bw = imfill(bw, 'holes')

figure
imshow(bw)
title('Part mask before crop')

%stats = regionprops(bw, 'BoundingBox');
%box = stats(1).BoundingBox;

%roi = imcrop(rgb, box);

roi = rgb .* uint8(bw);
end