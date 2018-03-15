%% Init images and transformation matrix
img1 = im2double(rgb2gray(imread('left.jpg')));
img2 = im2double(rgb2gray(imread('right.jpg')));
% img2 = imresize(img2, size(img1));
[matches, f1, f2] = keypoint_matching(img1, img2);
[trans_matrix, trans_m, trans_t] = RANSAC(matches, 20, 3000, f1, f2, img1, img2);

%% Stitching
stitched = stitch(img1, img2, trans_m, trans_t);
% Visualize stitched image and the left and right images together.
figure;
subplot(2,2,1.5)
imshow(stitched)
title('Stitched image')
subplot(2,2,3)
imshow(img1)
title('Left image')
subplot(2,2,4)
imshow(img2)
title('Right image')
