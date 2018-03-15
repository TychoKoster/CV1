function [ matches, f1, f2 ] = keypoint_matching(img1, img2)
% Keypoint retrieval with SIFT algorithm
[f1, d1] = vl_sift(single(img1));
[f2, d2] = vl_sift(single(img2));
% Compute matches of both image keypoints
[matches, ~] = vl_ubcmatch(d1, d2);
end