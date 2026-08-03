function distorted = applyNoise(I, noiseType, intensity)
% APPLYNOISE Adds sensor noise to simulate low-light or degraded imaging.
%   distorted = applyNoise(I) applies Gaussian noise, variance 0.01.
%   distorted = applyNoise(I, noiseType) uses default intensity for that type.
%   distorted = applyNoise(I, noiseType, intensity) uses specified intensity.
%
%   noiseType options:
%       'gaussian'      - additive Gaussian, intensity = variance (default 0.01)
%       'salt & pepper' - impulse noise,    intensity = density  (default 0.05)
%       'speckle'       - multiplicative,   intensity = variance (default 0.04)
%
%   imnoise() expects images in [0,1] range for its variance/density params
%   and internally handles uint8 conversion, so we pass I through directly.

    if nargin < 2
        noiseType = 'gaussian';
    end

    if nargin < 3
        switch lower(noiseType)
            case 'gaussian',      intensity = 0.01;
            case 'salt & pepper', intensity = 0.05;
            case 'speckle',       intensity = 0.04;
            otherwise,            intensity = 0.01;
        end
    end

    switch lower(noiseType)
        case 'gaussian'
            distorted = imnoise(I, 'gaussian', 0, intensity);
        case 'salt & pepper'
            distorted = imnoise(I, 'salt & pepper', intensity);
        case 'speckle'
            distorted = imnoise(I, 'speckle', intensity);
        otherwise
            error('applyNoise:badType', ...
                'noiseType must be ''gaussian'', ''salt & pepper'', or ''speckle''.');
    end
end
