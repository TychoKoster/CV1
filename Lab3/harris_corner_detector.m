function [H, r, c, A, B, C, Q] = harris_corner_detector(I, threshold, N)
I_gray = rgb2gray(I);
[Ix, Iy] = imgradientxy(double(I_gray));
imshow(Ix)
square_Ix = Ix.^2;
square_Iy = Iy.^2;
Ix_Iy = Ix .* Iy;
h = fspecial('gaussian',5,1);
A = conv2(square_Ix, h, 'same');
A_2 = imgaussfilt(square_Ix, 1);
% B = imgaussfilt(Ix_Iy);
% C = imgaussfilt(square_Iy);
% Q = [A, B; B, C]
% H = (A.*C - B.^2) - 0.04*((A + C).^2);
% r = [];
% c = [];
% for x = (N/2)+1:size(H,1)-(N/2)
%     for y = (N/2)+1:size(H,2)-(N/2)
%         slice_1 = H(x-(N/2):x-1, y-(N/2):y-1);
%         slice_2 = H(x+1:x+(N/2),y+1:y+(N/2));
%         slice_3 = H(x-(N/2):x-1, y+1:y+(N/2));
%         slice_4 = H(x+1:x+(N/2),y-(N/2):y-1);
%         slice = [slice_1, slice_2; slice_3, slice_4];
%         max_slice = max(slice(:));
%         if (H(x,y) > max_slice) & (H(x,y) > threshold)
%             r = [r,x];
%             c = [c,y];
%         end
%     end
% end
% ax = gca();
% [s1,s2] = size(I)
% scatter(ax, c, r, 'filled');
% hold(ax, 'on');
% imh = imshow(I);
% hold(ax, 'off')
% uistack(imh, 'bottom')
end