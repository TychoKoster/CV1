    function [ PSNR ] = myPSNR( orig_image, approx_image )
[m, n] = size(orig_image);
% Sqaured error
new_img = (orig_image - approx_image).^2;
% Mean squared error computation
MSE = ((1/(m * n)) * sum(new_img(:)));\
% The peak signal-to-noise ratio computation
PSNR = 10 * log10(double(max(orig_image(:))/sqrt(MSE)));

end

