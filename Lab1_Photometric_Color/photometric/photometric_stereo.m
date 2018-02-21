close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = '~/Github/CV1/Lab1_Photometric_Color/photometric/photometrics_images/SphereColor/';   % TODO: get the path of the script
%image_ext = '*.png';

% Change channels to 3 for RGB images
channels = 3;
albedo = 0;
normals = 0;

% Retrieve all images and compute the albedo and normals, done seperately
% for RGB images.
for i = 1:channels
    [image_stack, scriptV] = load_syn_images(image_dir, i);
    [h, w, n] = size(image_stack);
    % Create albedo and normal channels for RGB images
    if albedo == 0 & channels > 1
        albedo = zeros(h,w,channels);
        normals = zeros(h,w,3,channels);
    end
    fprintf('Finish loading %d images.\n\n', n);
    disp('Computing surface albedo and normal map...')
    % compute the surface gradient from the stack of imgs and light source mat
    [albedo_n, normals_n] = estimate_alb_nrm(image_stack, scriptV);
    % Assign albedo and normals based on channel number
    if channels > 1
       albedo(:, :, i) = albedo_n;
       normals(:,:,:,i) = normals_n;
    else
        albedo = albedo_n;
        normals = normals_n;
    end
end

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
p = 0;
q = 0;
SE = 0;
for i = 1:channels
    threshold = 0.05;

    if channels > 1
        % Compute p, q and SE for RGB images
        if p == 0
            p = zeros(h, w, channels);
            q = zeros(h, w, channels);
            SE = zeros(h, w, channels);
        end
        disp('Integrability checking')
        [p_n, q_n, SE_n] = check_integrability(normals(:,:,:, i));
        SE_n(SE_n <= threshold) = NaN; % for good visualization
        fprintf('Number of outliers: %d\n\n', sum(sum(SE_n > threshold)));
        p(:,:,i) = p_n;
        q(:,:,i) = q_n;
        SE(:,:,i) = SE_n;
    else
        % Compute p, q and SE for grey images
        [p, q, SE] = check_integrability(normals);
        SE(SE <= threshold) = NaN; % for good visualization
        fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));
    end
end
%% compute the surface height
% Create RGB height_map with 3 channels
if channels > 1
        height_map = zeros(h,w,channels);
end
for i = 1:channels
    if channels > 1
        % Construct rgb height map
        height_map(:,:,i) = construct_surface(p(:,:,i), q(:,:,i), 'column');    
    else
        % Construct grey height map
        height_map = construct_surface( p, q, 'row');
    end
end
%% Display
% Show the results of the images
% Create initial matrices
normals_average = zeros(h,w,3);
height_map_average = zeros(h,w);
SE_average = zeros(h,w);

% Turn NaN to 0 in albedo and normals
albedo(isnan(albedo)) = 0;
normals(isnan(normals)) = 0;

if channels > 1
    % Take the average of the 3 RGB channels and combine them to form 1
    % normals, height_map and SE
    for i = 1:channels
        normals_average = normals_average + normals(:,:,:,i)./3;
        height_map_average = height_map_average + height_map(:,:,i)./3;
        SE_average = SE_average + SE(:,:,i)./3;
    end
    show_results(albedo, normals_average, SE_average);
    show_model(albedo, height_map_average);
else
    show_results(albedo, normals, SE);
    show_model(albedo, height_map);
end


    


%% Face
[image_stack, scriptV] = load_face_images('~/Github/CV1/Lab1_Photometric_Color/photometric/photometrics_images/yaleB02/');
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
% shadow trick on false, given in assignment
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q , 'row');

show_results(albedo, normals, SE);
show_model(albedo, height_map);

