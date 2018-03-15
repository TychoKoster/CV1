img1 = im2double(imread('boat1.pgm'));
img2 = im2double(imread('boat2.pgm'));
[matches, f1, f2] = keypoint_matching(img1, img2);
random_subset = datasample(matches, 50, 2);
figure(2) ; clf ;
imshow(cat(2, img1, img2)) ;
% https://github.com/vlfeat/vlfeat/blob/master/toolbox/demo/vl_demo_sift_match.m
xa = f1(1,random_subset(1,:)) ;
xb = f2(1,random_subset(2,:)) + size(img1,2) ;
ya = f1(2,random_subset(1,:)) ;
yb = f2(2,random_subset(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(f1(:,random_subset(1,:))) ;
f2(1,:) = f2(1,:) + size(img1,2) ;
vl_plotframe(f2(:,random_subset(2,:))) ;
axis image off ;

%% Compute transformation matrix
[trans_matrix, trans_m, trans_t] = RANSAC(matches, 10, 3000, f1, f2, img1, img2);

%% Own way
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
% Show transformation from 1 to 2
% Shenanigans
figure;
subplot(2,1,1)
imshow(img2)
subplot(2,2,1)
imshow(transformed_im1(1500:end))
% Show transformation from 2 to 1
figure;
subplot(2,2,2);
imshow(img1);
title('Normal image 1')
subplot(2,2,2)
imshow(transformed_im2(1710:end));
title('Image 2 transformed to image 1')

%% Matlab way
tform_12 = maketform('affine', [transpose(trans_m); trans_t']);
tform_21 = maketform('affine', [trans_m; trans_t']);
transformed_im1 = imtransform(img1, tform_12);
transformed_im2 = imtransform(img2, tform_21);
figure;
% imshow(img1)
imshow(img2)
figure;
imshow(transformed_im1)
% imshow(transformed_im2)

