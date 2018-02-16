close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = '~/Documents/CV1/Lab1_Photometric_Color/photometric/photometrics_images/MonkeyColor/';   % TODO: get the path of the script
%image_ext = '*.png';

[image_stack_1, scriptV] = load_syn_images(image_dir, 1);
[image_stack_2, ~] = load_syn_images(image_dir, 2);
[image_stack_3, ~] = load_syn_images(image_dir, 3);

[h, w, n] = size(image_stack_1);
fprintf('Finish loading %d images.\n\n', n);

%% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo_1, normals_1] = estimate_alb_nrm(image_stack_1, scriptV);
[albedo_2, normals_2] = estimate_alb_nrm(image_stack_2, scriptV);
[albedo_3, normals_3] = estimate_alb_nrm(image_stack_3, scriptV);



%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals_3);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q );

%% Display
show_results(albedo_3, normals_3, SE);
show_model(albedo_3, height_map);


%% Face
[image_stack, scriptV] = load_face_images('./yaleB02/');
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q );

show_results(albedo, normals, SE);
show_model(albedo, height_map);

