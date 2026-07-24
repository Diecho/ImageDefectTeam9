function metrics = extractMetrics(evidenceMask)
% EXTRACTMETRICS Get information about number of areas, max area and ratio.

cc = bwconncomp(evidenceMask);
metrics.numComponents = cc.NumObjects;

if cc.NumObjects > 0
    areas = regionprops(cc, 'Area');
    metrics.maxArea = max([areas.Area]);
else
    metrics.maxArea = 0;
end

metrics.areaRatio = nnz(evidenceMask) / numel(evidenceMask);
end