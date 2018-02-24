function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)
Gx = imfilter(image, [1, 0,-1; 2, 0 , -2; 1, 0, -1]);
Gy = imfilter(image, [1, 2,1; 0, 0 , 0; -1, -2, -1]);
im_direction = atan(double(Gx./Gy));
G = Gx.^2 + Gy.^2;
im_magnitude = sqrt(double(G));

end

