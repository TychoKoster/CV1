function [ PSNR ] = myPSNR( orig_image, approx_image )
[m, n] = size(orig_image);
new_img = (orig_image - approx_image).^2;
MSE = ((1/(m * n)) * sum(new_img(:)));
PSNR = 10 * log10(double(max(orig_image(:))/sqrt(MSE)));

end

