% test your code by using this simple script

clear
clc
close all

I = imread('peppers.png');
imshow(I);
% 
% J = ConvertColorSpace(I,'opponent');
% imshow(J);
 
% close all
% J = ConvertColorSpace(I,'rgb');
% imshow(J);

% close all
% J = ConvertColorSpace(I,'hsv');

% close all
% J = ConvertColorSpace(I,'ycbcr');

% close all
J = ConvertColorSpace(I,'gray');
