% Read in images
img1 = im2double(imread('boat1.pgm'));
img2 = im2double(imread('boat2.pgm'));
% Find keypoints and matches between images
[matches, f1, f2] = keypoint_matching(img1, img2);
% Take subset of 50
random_subset = datasample(matches, 50, 2);
figure(2) ; clf ;
imshow(cat(2, img1, img2)) ;
% Code to plot the lines between the keypoints of the two images was found
% here:
% https://github.com/vlfeat/vlfeat/blob/master/toolbox/demo/vl_demo_sift_match.m
xa = f1(1,random_subset(1,:)) ;
xb = f2(1,random_subset(2,:)) + size(img1,2) ;
ya = f1(2,random_subset(1,:)) ;
yb = f2(2,random_subset(2,:)) ;
% Draw lines between keypoints
hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(f1(:,random_subset(1,:))) ;
f2(1,:) = f2(1,:) + size(img1,2) ;
vl_plotframe(f2(:,random_subset(2,:))) ;
axis image off ;

%% Compute transformation matrix
[trans_matrix, trans_m, trans_t] = RANSAC(matches, 10, 3000, f1, f2, img1, img2);

%% Own way (nearest-neighbor interpolation)
[h, w] = size(img1);
transformed_im1 = zeros(h, w);
transformed_im2 = zeros(h, w);
for i = 1:h
    for j = 1:w
        xy_12 = round(transpose(trans_m) * [i; j] + trans_t);
        xy_21 = round(trans_m * [i; j] + trans_t);
        xy_21((xy_21 < 1)) = 1;
        xy_12((xy_12 < 1)) = 1;
        
        transformed_im1(xy_12(1), xy_12(2)) = img1(i, j);
        transformed_im2(xy_21(1), xy_21(2)) = img2(i, j);
    end
end
% Crop images

transformed_im2(~any(transformed_im2, 2), :) = [];
transformed_im2(:, ~any(transformed_im2, 1)) = [];
transformed_im1(~any(transformed_im1, 2), :) = [];
transformed_im1(:, ~any(transformed_im1, 1)) = [];

for i = 1:size(transformed_im1, 1)
    for j = 1:size(transformed_im1, 2)-1
        if transformed_im1(i,j) == 0
            transformed_im1(i,j) = transformed_im1(i, j+1);
        end
    end
end

for i = 1:size(transformed_im2, 1)
    for j = 1:size(transformed_im2, 2)-1
        if transformed_im2(i,j) == 0
            transformed_im2(i,j) = transformed_im2(i, j+1);
        end
    end
end


% Show transformation from image 1 to 2
figure;
subplot(2,2,1);
imshow(img1);
title('Normal image 1');
subplot(2,2,2);
imshow(transformed_im2);
title('Image 2 transformed to image 1');
% Show transformation from image 2 to 1
subplot(2,2,3);
imshow(img2);
title('Normal image 2');
subplot(2,2,4);
imshow(transformed_im1);
title('Image 1 transformed to image 2');
suptitle('Own interpolation method');


%% Matlab way
% Create transformation matrix
tform_12 = maketform('affine', [transpose(trans_m); trans_t']);
tform_21 = maketform('affine', [trans_m; trans_t']);
% Transform images
transformed_im1 = imtransform(img1, tform_12);
transformed_im2 = imtransform(img2, tform_21);
% Visualize transformations of both images
figure;
subplot(2,2,1);
imshow(img1);
title('Normal image 1');
subplot(2,2,2);
imshow(transformed_im2);
title('Image 2 transformed to image 1');
subplot(2,2,3);
imshow(img2);
title('Normal image 2');
subplot(2,2,4);
imshow(transformed_im1);
title('Image 1 transformed to image 2');
suptitle('MATLAB build-in method');

