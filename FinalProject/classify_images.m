function [ classes ] = classify_images(airplane_scores, cars_scores, faces_scores, motorbikes_scores)
classes = [];
    for i = 1:size(airplane_scores, 1)
        [~, class] = max([airplane_scores(i,2), cars_scores(i,2), faces_scores(i,2), motorbikes_scores(i,2)]);
        classes = [classes; class];
    end
end