function [ classes ] = classify_images(airplane_scores, cars_scores, faces_scores, motorbikes_scores)
    classes = [];
    for i = 1:size(airplane_scores, 1)
        [~, class] = max([airplane_scores(i), cars_scores(i), faces_scores(i), motorbikes_scores(i)]);
        classes = [classes; class];
    end
end