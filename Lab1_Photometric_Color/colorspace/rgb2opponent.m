function [output_image] = rgb2opponent(input_image)
[R, G, B] = getColorChannels(input_image);
[h, w, z] = size(input_image);
output_image = zeros(h,w,z);
output_image(:,:,1) = (R - G)./sqrt(2);
output_image(:,:,2) = (R + G - 2 * B)./sqrt(6);
output_image(:,:,3) = (R + G + B)./sqrt(3);

% converts an RGB image into opponent color space
end

