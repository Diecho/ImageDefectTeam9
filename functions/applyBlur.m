function distorted = applyBlur(I, sigma)
% APPLYBLUR Applies Gaussian blur to simulate defocused camera.
%   distorted = applyBlur(I) uses default sigma = 2.
%   distorted = applyBlur(I, sigma) uses specified standard deviation.
%
%   Larger sigma = more blur. Typical robustness sweep: [1 2 4 8].

    if nargin < 2
        sigma = 2;
    end

    distorted = imgaussfilt(I, sigma);
end
