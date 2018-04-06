function [data, class_labels] = construct_data(positive_data, negative_data, nr_clusters) 
    % Construct the data to give to the SVM by labeling the positive data
    % with 1 and the negative data with 0
    class_labels = [];
    data = [];
    for i = 1:length(positive_data)
        [h, ~] = histcounts(positive_data{i}, nr_clusters, 'Normalization', 'probability');
        data = [data; h];
        class_labels = [class_labels; 1];
    end
    for i = 1:length(negative_data)
        [h, ~] = histcounts(negative_data{i}, nr_clusters, 'Normalization', 'probability');
        data = [data; h];
        class_labels = [class_labels; 0];
    end
end

