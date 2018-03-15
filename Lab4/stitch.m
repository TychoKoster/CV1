function [ stitched_im ] = stitch(img1, img2, trans_m, trans_t)
[h, w] = size(img2);
tform = maketform('affine', [trans_m; trans_t']);
transformed_h = size(img1, 1);
transformed_w = size(img1, 2)+ abs(ceil(trans_t(1)));

tform = maketform('affine', [trans_m; trans_t']);
transformed_im2 = imtransform(img2, tform);
% transformed_im2 = imresize(transformed_im2, size(img1));
stitched_im = zeros(transformed_h, transformed_w);
for i = 1:size(transformed_im2, 1)
    for j = 1:size(transformed_im2, 2)
        stitched_im(i+abs(round(trans_t(2)/3)),j+abs(round(trans_t(1)))) = transformed_im2(i,j);
    end
end
for i = 1:size(img1, 1)
    for j = 1:size(img1, 2)
        stitched_im(i,j) = img1(i,j);
    end
    
end

