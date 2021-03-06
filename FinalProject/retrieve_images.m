function [images, image_paths] = retrieve_images(path_to_dir, length_of_images)
% Retrieves the images from the given directory with the given amount
image_paths = {};
if nargin == 1
    image_files = dir(path_to_dir);
    images = cell(length(image_files), 1);
    for i = 1:length(image_files)
        image_name = strcat(image_files(i).folder, '/', image_files(i).name);
        images{i} = imread(image_name);
        image_paths{i} = image_name;
    end
else
    image_files = dir(path_to_dir);
    images = cell(length_of_images, 1);
    for i = 1:length_of_images
        image_name = strcat(image_files(i).folder, '/', image_files(i).name);
        images{i} = imread(image_name);
        image_paths{i} = image_name;
    end
end

end