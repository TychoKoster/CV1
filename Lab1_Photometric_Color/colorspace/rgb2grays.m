function [output_image] = rgb2grays(input_image)
% converts an RGB into grayscale by using 4 different methods
[R, G, B] = getColorChannels(input_image);

% lightness method
[h, w, ~] = size(input_image);
max_matrix = max(max(R,G),B);
min_matrix = min(min(R,G),B);
output_image = (max_matrix+min_matrix)./2;

% average method
output_image_2 = (R + G + B)./3;
 
% luminosity method
output_image_3 = (0.21 * R + 0.72 * G + 0.07 * B);

% built-in MATLAB function 
output_image_4 = rgb2gray(input_image);

subplot(2,2,1),
imshow(output_image);
title('Lightness');
subplot(2,2,2),
imshow(output_image_2);
title('Average');
subplot(2,2,3),
imshow(output_image_3);
title('Luminosity');
subplot(2,2,4),
imshow(output_image_4)
title('Built-in Matlab');

end

