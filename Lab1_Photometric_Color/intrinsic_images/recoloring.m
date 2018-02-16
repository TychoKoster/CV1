function [ ] = recoloring( original_image, reflectance, shading )
    % 1. Actual material color is the rgb of the reflectance
    
    % 2. Recolor reflectance with green
    green_recolor = zeros(size(reflectance));
    % Green rbg value converted to double
    green_recolor(:,:,2) = double(255)/255;
    reconstructed_green = iid_image_formation(original_image, green_recolor, shading, false);
    
    % Recolor reflectance with magenta
    magenta_recolor = zeros(size(reflectance));
    % Magenta rgb color converted to double
    magenta_recolor(:,:,1) = double(255)/255;
    magenta_recolor(:,:,3) = double(255)/255;
    reconstructed_magenta = iid_image_formation(original_image, magenta_recolor, shading, false);
    
    subplot(1, 3, 1),
    imshow(original_image);
    title('Original')
    subplot(1, 3, 2),
    imshow(reconstructed_green);
    title('Green recolor');
    subplot(1, 3, 3),
    imshow(reconstructed_magenta);
    title('Magenta recolor');
end

