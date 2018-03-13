function [transformation_matrix, trans_m, trans_t] = RANSAC(matches, P, N, f1, f2, img1, img2)
% Coördinates of the all the matching keypoints
xm1 = f1(1, matches(1,:));
ym1 = f1(2, matches(1,:));
xm2 = f2(1, matches(2,:)) + size(img1, 2);
ym2 = f2(2, matches(2,:));
T_im1 = [xm1;ym1];
T_im2 = [xm2;ym2];
max_inliers = 0;
for i = 1:N
    random_subset = datasample(matches, P, 2);
    % Get coördinates of the matching key points of the random subset
    xa = f1(1,random_subset(1,:));
    xb = f2(1,random_subset(2,:)) + size(img1, 2);
    ya = f1(2,random_subset(1,:));
    yb = f2(2,random_subset(2,:));
    A = [];
    % Create A matrix
    for j = 1:size(xa,2)
        A_1 = [xa(j), ya(j), 0, 0, 1, 0; 0, 0, xa(j), ya(j), 0, 1];
        A = [A; A_1];
    end
    b = [xb; yb];
    % Calculate transformation parameters
    x = pinv(A)*b(:);
    M = [x(1), x(2); x(3), x(4)];
    t = [x(5); x(6)];
    % Calculate transformated coördinates
    trans_cor = M * T_im1 + t;
    % Check which points are in a 10 pixels radius from their orignal point
    inliers = abs(trans_cor - T_im2) < 10;
    % Count inliers
    count_inliers = sum(inliers(1,:) == 1 & inliers(2,:) == 1);
    % Replace transformation matrix with the highest inliers
    if max_inliers < count_inliers
        max_inliers = count_inliers;
        transformation_matrix = x;
        trans_m = M;
        trans_t = t;
    end
end
% Own way

end