
path_im1 = 'synth1.pgm';
path_im2 = 'synth2.pgm';
im1 = imread(path_im1);
im2 = imread(path_im2);
window_size = 15;
kernel_size = 4;
sigma = 2;

[Vx, Vy, X, Y] = lucas_kanade(im1, im2, window_size, kernel_size, sigma);

imshow(im1);
hold on;
quiver(X, Y, Vx, Vy, 'color', 'red');