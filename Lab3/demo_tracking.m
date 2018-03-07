%% Read in images
image_files = dir('person_toy/*.jpg');
images = cell(length(image_files), 1);
    
% Read in images
for i = 1:length(image_files)
    images{i} = imread(image_files(i).name);
end

%% Run tracking
threshold = 185;
window_harris = 4;
window_lucas = 15;
kernel_size = 4;
sigma = 1.3;

tracking(images, threshold, window_harris, kernel_size, sigma, window_lucas)