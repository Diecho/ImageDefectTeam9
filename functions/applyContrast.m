function distorted = applyContrast(I, gamma)
% APPLYCONTRAST Changes image contrast via gamma correction.
%   distorted = applyContrast(I) uses default gamma = 0.5 (higher contrast).
%   distorted = applyContrast(I, gamma) uses specified gamma value.
%
%   gamma < 1  -> stretches highlights, boosts contrast on bright regions
%   gamma = 1  -> no change
%   gamma > 1  -> flattens contrast, image looks washed out
%
%   Typical robustness sweep: [0.4 0.7 1.5 2.5].
%   Uses imadjust with default [0 1] input/output ranges so only the
%   gamma curve is applied; brightness stays roughly centered.

    if nargin < 2
        gamma = 0.5;
    end

    if size(I, 3) == 3
        % Apply gamma per channel to preserve color
        distorted = imadjust(I, [], [], gamma);
    else
        distorted = imadjust(I, [], [], gamma);
    end
end
