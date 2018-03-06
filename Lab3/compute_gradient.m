function [Gx, Gy, im_magnitude, im_direction] = compute_gradient(image)
% X gradient of the image
Gx = imfilter(image, [1, 0,-1; 2, 0 , -2; 1, 0, -1]);
% Y gradient of the image
Gy = imfilter(image, [1, 2,1; 0, 0 , 0; -1, -2, -1]);
% Direction of the image 
im_direction = atan(double(Gx./Gy));
G = Gx.^2 + Gy.^2;
% Magnitude of the image
im_magnitude = sqrt(double(G));
end

