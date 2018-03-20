clear;
path_to_airplane = 'Caltech4/ImageData/airplanes_train/*.jpg';
path_to_cars = 'Caltech4/ImageData/cars_train/*.jpg';
path_to_faces = 'Caltech4/ImageData/faces_train/*.jpg';
path_to_motorbikes = 'Caltech4/ImageData/motorbikes_train/*.jpg';
method = "vl_sift";
sift_method = 'vl_sift';
amount_of_images = 50;
train_airplane_images = retrieve_images(path_to_airplane, amount_of_images);
train_cars_images = retrieve_images(path_to_cars, amount_of_images);
train_faces_images = retrieve_images(path_to_faces, amount_of_images);
train_motorbikes_images = retrieve_images(path_to_motorbikes, amount_of_images);

[descriptors_airplane, descriptor_cell_airplane] = get_keypoints(train_airplane_images, method, sift_method);
[descriptors_cars, descriptor_cell_cars] = get_keypoints(train_cars_images, method, sift_method);
[descriptors_faces, descriptor_cell_faces] = get_keypoints(train_faces_images, method, sift_method);
[descriptors_motorbikes, descriptor_cell_motorbikes] = get_keypoints(train_motorbikes_images, method, sift_method);
%% k-means
nr_clusters = 400;
%Iterations
kmeans_clusters = kmeans([descriptors_airplane, descriptors_cars, descriptors_faces, descriptors_motorbikes], nr_clusters);

%% Assign labels
airplane_labels = assign_labels(kmeans_clusters, descriptor_cell_airplane);
cars_labels = assign_labels(kmeans_clusters, descriptor_cell_cars);
faces_labels = assign_labels(kmeans_clusters, descriptor_cell_faces);
motorbike_labels = assign_labels(kmeans_clusters, descriptor_cell_motorbikes);

%% Loempie-Loempie Poempie-Poempi Histogrampie
figure;
histogram(airplane_labels{1}, nr_clusters, 'Normalization', 'probability')
figure;
histogram(cars_labels{1}, nr_clusters, 'Normalization', 'probability')
figure;
histogram(faces_labels{1}, nr_clusters, 'Normalization', 'probability')
figure;
histogram(motorbike_labels{1}, nr_clusters, 'Normalization', 'probability')
%% Classify
% Create data
[data_airplane, class_labels_airplane] = construct_data(airplane_labels, [cars_labels; faces_labels; motorbike_labels], nr_clusters);
[data_cars, class_labels_cars] = construct_data(cars_labels, [airplane_labels; faces_labels; motorbike_labels], nr_clusters);
[data_faces, class_labels_faces] = construct_data(faces_labels, [airplane_labels; cars_labels; motorbike_labels], nr_clusters);
[data_motorbikes, class_labels_motorbikes] = construct_data(motorbike_labels, [airplane_labels; faces_labels; cars_labels], nr_clusters);

SVMModel_airplane = fitcsvm(data_airplane, class_labels_airplane, 'KernelFunction', 'rbf','ClassNames', [0, 1]);
SVMModel_cars = fitcsvm(data_cars, class_labels_cars, 'KernelFunction', 'rbf', 'ClassNames', [0, 1]);
SVMModel_faces = fitcsvm(data_faces, class_labels_faces, 'KernelFunction', 'rbf', 'ClassNames', [0, 1]);
SVMModel_motorbikes = fitcsvm(data_motorbikes, class_labels_motorbikes, 'KernelFunction', 'rbf', 'ClassNames', [0, 1]);

%% Test
path_to_airplane_test = 'Caltech4/ImageData/airplanes_test/*.jpg';
test_airplane_images = retrieve_images(path_to_airplane_test, 10);
[~, descriptor_cell_airplane_test] = get_keypoints(test_airplane_images, method, sift_method);
airplane_labels_test = assign_labels(kmeans_clusters, descriptor_cell_airplane_test);
data = [];
for i = 1:length(airplane_labels_test)
    h = histcounts(airplane_labels_test{i}, nr_clusters, 'Normalization', 'probability');
    data = [data; h];
end
[label, score] = predict(SVMModel_airplane, data)


