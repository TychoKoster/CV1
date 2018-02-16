function [ reconstructed_image ] = iid_image_formation( original_image, reflectance, shading )
    reconstructed_image = shading .* reflectance;
    
    subplot(2, 2, 1),
    imshow(original_image);
    title('Original')
    subplot(2, 2, 2),
    imshow(reconstructed_image);
    title('Reconstructed');
    subplot(2, 2, 3),
    imshow(reflectance);
    title('Reflectance');
    subplot(2, 2, 4),
    imshow(shading);
    title('Shading');
end