function [ imOut ] = denoise( image, kernel_type, varargin)
vars = cell2mat(varargin);
switch kernel_type
    case 'box'
        % Box filtered image
        imOut = imboxfilt(image, vars(1));
    case 'median'
        % Median filtered image
        imOut= medfilt2(image, [vars(1), vars(1)]);
    case 'gaussian'
        % Gaussian filtered image
        imOut = imfilter(image, gauss2D(vars(1) , vars(2)));
end
end
