%% Init
img1 = im2double(rgb2gray(imread('left.jpg')));
img2 = im2double(rgb2gray(imread('right.jpg')));
[matches, f1, f2] = keypoint_matching(img1, img2);
[trans_matrix, trans_m, trans_t] = RANSAC(matches, 20, 3000, f1, f2, img1, img2);

%%
[h, w] = size(img2);
corner_topleft = round(trans_m * [1; 1] + trans_t) + 100;
corner_topright = round(trans_m * [1; w] + trans_t) + 100;
corner_bottomleft = round(trans_m * [h; 1] + trans_t) + 100;
corner_bottomright = round(trans_m * [h; w] + trans_t) + 100;

corner_values = [corner_topleft, corner_topright, corner_bottomleft, corner_bottomright];
max_xy = max(corner_values, [], 2);
min_xy = min(corner_values, [], 2);
transformed_h = max_xy(1) - min_xy(1) + size(img1, 1);
transformed_w = max_xy(2) - min_xy(2) + size(img1, 2);

tform = maketform('affine', [trans_m; trans_t']);
transformed_im2 = imtransform(img2, tform);
%% Stitching
stitch(img1, transformed_im2, transformed_h, transformed_w, [trans_m; trans_t'])