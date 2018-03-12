% Demo for the harris corner detection
max_angle = 360;
I = imread('person_toy/00000001.jpg');
% Random Rotate on the image
I = imrotate(I, round(rand(1) * max_angle), 'bilinear');
% Define parameters
threshold = 185;
window_size = 4;
kernel_size = 4;
sigma = 1.3   ;
[~, r, c, Ix, Iy] = harris_corner_detector(I, threshold, window_size, kernel_size, sigma);
% Show results
figure1=figure('Position', [100, 100, 1024, 1200]);   
subplot(3,2,1);
imshow(Ix);
subplot(3,2,2);
imshow(Iy);
subplot(3,1,2);
ax = gca();
scatter(ax, c, r, 'filled');
hold(ax, 'on');
imh = imshow(I);
hold(ax, 'off')
uistack(imh, 'bottom')