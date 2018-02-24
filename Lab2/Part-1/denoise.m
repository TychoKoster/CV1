function [ imOut ] = denoise( image, kernel_type, varargin)

switch kernel_type
    case 'box'
        imOut = imboxfilt(image);
    case 'median'
        imOut= medfilt2(image);
    case 'gaussian'
        vars = cell2mat(varargin);
        imOut = imfilter(image, gauss2D(vars(1) , vars(2)));
end
end
