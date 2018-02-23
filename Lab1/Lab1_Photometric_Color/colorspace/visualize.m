function visualize(input_image)
% Visualizes the input image
subplot(2,2,1),
imshow(input_image);
title('Original image');
subplot(2,2,2),
imshow(input_image(:,:,1));
title('Channel 1');
subplot(2,2,3),
imshow(input_image(:,:,2));
title('Channel 2');
subplot(2,2,4),
imshow(input_image(:,:,3));
title('Channel 3');
end

