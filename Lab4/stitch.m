function [ stitched_im ] = stitch(img1, img2, trans_m, trans_t)
[h, w] = size(img2);
tform = maketform('affine', [trans_m; trans_t']);
% Stitched image sizes
transformed_h = size(img1, 1);
transformed_w = size(img1, 2)+ abs(ceil(trans_t(1)));
% Create transformed image
tform = maketform('affine', [trans_m; trans_t']);
transformed_im2 = imtransform(img2, tform);
% Create image with the size of left image and the translation of y
stitched_im = zeros(transformed_h, transformed_w);

% Stitch both images by "pasting" the left image over the right to delete
% black background of the transformed right image.

% Transformed right image
for i = 1:size(transformed_im2, 1)
    for j = 1:size(transformed_im2, 2)
        stitched_im(i+abs(round(trans_t(2)/3)),j+abs(round(trans_t(1)))) = transformed_im2(i,j);
    end
end
% Left image
for i = 1:size(img1, 1)
    for j = 1:size(img1, 2)
        stitched_im(i,j) = img1(i,j);
    end
end

