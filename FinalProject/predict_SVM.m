function [ classes, labels ] = predict_SVM(SVMModels, path_to_images, amount_test_images, nr_clusters, kmeans_clusters, method, sift_method, positive_labels, negative_labels)
    test_images = retrieve_images(path_to_images, amount_test_images);
    [~, descriptor_cell_test] = get_keypoints(test_images, method, sift_method);
    labels_test = assign_labels(kmeans_clusters, descriptor_cell_test);
    data = [];
    for i = 1:length(labels_test)
        [h, ~] = histcounts(labels_test{i}, nr_clusters, 'Normalization', 'probability');
        data = [data; h];
    end
   data = sparse(data);
   [labels_airplanes, ~, scores_airplane] = predict(positive_labels, data, SVMModels{1}, '-b 1');
   [labels_cars, ~, scores_cars] = predict(negative_labels, data, SVMModels{2}, '-b 1');
   [labels_faces, ~, scores_faces] = predict(negative_labels, data, SVMModels{3}, '-b 1');
   [labels_motorbikes, ~, scores_motorbikes] = predict(negative_labels, data, SVMModels{4}, '-b 1');
   
    labels = [labels_airplanes, labels_cars, labels_faces, labels_motorbikes];
    classes = classify_images(scores_airplane, scores_cars, scores_faces, scores_motorbikes);
end