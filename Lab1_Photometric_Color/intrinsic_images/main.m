close all
clear all
clc

% Shenanigans with 8bit integers 
reflectance_ball = double(imread('ball_reflectance.png'))/255;
shading_ball = double(imread('ball_shading.png'))/255;
original_ball = imread('ball.png');

reconstructed_image = iid_image_formation(original_ball, reflectance_ball, shading_ball);
recoloring(original_ball);
