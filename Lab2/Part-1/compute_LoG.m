function imOut = compute_LoG(image, LOG_type)

switch LOG_type
    case 1
        gauss = denoise(image, 'gaussian', 0.5, 5);
        h = fspecial('laplacian');
        imOut = imfilter(gauss, h);
        %method 1

    case 2
        %method 2
        h = fspecial('log', 5, 2);
        imOut = imfilter(image, h);
    case 3
        %method 3
        fprintf('Not implemented\n')

end
end

