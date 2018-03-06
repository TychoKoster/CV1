function imOut = compute_LoG(image, LOG_type)

switch LOG_type
    case 1
        %method 1
        % Gaussian smoothed image
        gauss = denoise(image, 'gaussian', 0.5, 5);
        h = fspecial('laplacian');
        % Laplacian smoothing
        imOut = imfilter(gauss, h);

    case 2
        %method 2
        % LoG smoothing image
        h = fspecial('log', 5, 0.5);
        imOut = imfilter(image, h);
    case 3
        %method 3
        %DoG smoothing image
        gauss1 = denoise(image, 'gaussian', 0.5, 5);
        gauss2 = denoise(image, 'gaussian', 2, 5);
        imOut = gauss1 - gauss2; 
end
end

