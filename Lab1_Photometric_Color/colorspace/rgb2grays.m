function [output_image] = rgb2grays(input_image)
% converts an RGB into grayscale by using 4 different methods
[R, G, B] = getColorChannels(input_image);

% ligtness method
[h, w, ~] = size(input_image);
% output_image = zeros(h, w, 1);
max_matrix = max(max(R,G),B);
min_matrix = min(min(R,G),B);
output_image = (max_matrix+min_matrix)./2;
% average method
output_image_2 = (R + G + B)./3;
 
% luminosity method
output_image_3 = (0.21 * R + 0.72 * G + 0.07 * B);


% built-in MATLAB function 
output_image_4 = rgb2gray(input_image);
% h    = [];
% h(1) = subplot(2,2,1);
% h(2) = subplot(2,2,2);
% h(3) = subplot(2,2,3);
% h(4) = subplot(2,2,4);
% image(output_image,'Lightness',h(1));
% image(output_image_2, 'Average',h(2));
% image(output_image_3,'Luminosity',h(3));
% image(output_image_4,'Built-in Matlab',h(4));
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

