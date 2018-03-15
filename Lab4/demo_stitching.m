%% Init
img1 = im2double(rgb2gray(imread('left.jpg')));
img2 = im2double(rgb2gray(imread('right.jpg')));
% img2 = imresize(img2, size(img1));
[matches, f1, f2] = keypoint_matching(img1, img2);
[trans_matrix, trans_m, trans_t] = RANSAC(matches, 20, 3000, f1, f2, img1, img2);

%%
figure;
imshow(stitch(img1, img2, trans_m, trans_t))
%% Stitching

