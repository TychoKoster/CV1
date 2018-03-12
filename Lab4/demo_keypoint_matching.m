img1 = imread('boat1.pgm');
img2 = imread('boat2.pgm');
[matches, f1, f2] = keypoint_matching(img1, img2);
random_subset = datasample(matches, 50, 2);
matches(1)
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

