function [images] = retrieve_images(path_to_dir, length_of_images)
image_files = dir(path_to_dir);
images = cell(length_of_images, 1);
for i = 1:length_of_images
    images{i} = imread(image_files(i).name);
end
end