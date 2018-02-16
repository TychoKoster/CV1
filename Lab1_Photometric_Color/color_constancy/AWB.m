%% Init
close all
clear all
clc

awb_image = imread('awb.jpg');

%% Grey world algorithm
% Applied using the following explanation of gray world
% https://www.codeproject.com/Articles/653355/Color-Constancy-Gray-World-Algorithm
% Where the original pixels are scaled by the estimated

% Image information
[h, w, ~] = size(awb_image);
pixel_amount = h*w;

% Given by exercise, illumination set to 128
estimated_avg = 128;

% RGB values
red_values = awb_image(:,:,1);
green_values = awb_image(:,:,2);
blue_values = awb_image(:,:,3);

% Sum of channels
sum_red = sum(sum(red_values));
sum_green = sum(sum(green_values));
sum_blue = sum(sum(blue_values));

% Channel means
mean_red = sum_red / pixel_amount;
mean_green = sum_green / pixel_amount;
mean_blue = sum_blue / pixel_amount;

% Scale original RGB values with the estimated_avg/mean_channel
corrected_image(:,:,1) = (estimated_avg/mean_red)*red_values;
corrected_image(:,:,2) = (estimated_avg/mean_green)*green_values;
corrected_image(:,:,3) = (estimated_avg/mean_blue)*blue_values;

subplot(1,2,1),
imshow(awb_image);
title('Original image');

subplot(1,2,2),
imshow(corrected_image);
title('Corrected image');