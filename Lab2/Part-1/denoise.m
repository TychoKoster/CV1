function [ imOut ] = denoise( image, kernel_type, varargin)
vars = cell2mat(varargin);
switch kernel_type
    case 'box'
        imOut = imboxfilt(image, vars(1));
    case 'median'
        imOut= medfilt2(image, [vars(1), vars(1)]);
    case 'gaussian'
        imOut = imfilter(image, gauss2D(vars(1) , vars(2)));
end
end
