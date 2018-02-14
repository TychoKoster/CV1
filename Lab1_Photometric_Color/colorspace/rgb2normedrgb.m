function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb
[R, G, B] = getColorChannels(input_image);
[h, w, z] = size(input_image);
output_image = zeros(h,w,z);
output_image(:,:,1) = R./(R + G + B);
output_image(:,:,2) = G./(R + G + B);
output_image(:,:,3) = B./(R + G + B);
end

