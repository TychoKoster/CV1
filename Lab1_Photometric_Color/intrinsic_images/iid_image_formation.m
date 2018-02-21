function [ reconstructed_image ] = iid_image_formation( original_image, reflectance, shading, plot )
    % Expect double images for shading and reflectance
    % Reconstruct equation used that was given in the assignment
    reconstructed_image = shading .* reflectance;
    
    if plot
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
end