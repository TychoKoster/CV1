function [ imdb ] = addData(imdb, label, images_set, set)
    for i = 1:size(images_set, 1)
        if size(images_set{i}, 3) == 3
            imdb.images.data = cat(4, imdb.images.data, imresize(images_set{i}, [32, 32]));
            imdb.images.labels = cat(2, imdb.images.labels, label);
            imdb.images.set = cat(2, imdb.images.set, set);
        end
    end    
end