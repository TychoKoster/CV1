clear;
path_to_airplane = 'Caltech4/ImageData/airplanes_train/*.jpg';
path_to_cars = 'Caltech4/ImageData/cars_train/*.jpg';
path_to_faces = 'Caltech4/ImageData/faces_train/*.jpg';
path_to_motorbikes = 'Caltech4/ImageData/motorbikes_train/*.jpg';
method = "vl_sift";
sift_method = 'vl_sift';
amount_of_images = 150;
train_airplane_images = retrieve_images(path_to_airplane, amount_of_images);
train_cars_images = retrieve_images(path_to_cars, amount_of_images);
train_faces_images = retrieve_images(path_to_faces, amount_of_images);
train_motorbikes_images = retrieve_images(path_to_motorbikes, amount_of_images);
splitnumber = 100;
[descriptors_airplane, ~] = get_keypoints(train_airplane_images(1:splitnumber), method, sift_method);
[descriptors_cars, ~] = get_keypoints(train_cars_images(1:splitnumber), method, sift_method);
[descriptors_faces, ~] = get_keypoints(train_faces_images(1:splitnumber), method, sift_method);
[descriptors_motorbikes, ~] = get_keypoints(train_motorbikes_images(1:splitnumber), method, sift_method);
%% k-means
nr_clusters = 400;
%Iterations
data = cat(2, descriptors_airplane, descriptors_cars, descriptors_faces, descriptors_motorbikes);
kmeans_clusters = vl_kmeans(data, nr_clusters, 'Initialization', ...
    'plusplus', 'maxnumiterations', 100);

%% Assign labels
[~, descriptor_cell_airplane] = get_keypoints(train_airplane_images(splitnumber+1:end), method, sift_method);
[~, descriptor_cell_cars] = get_keypoints(train_cars_images(splitnumber+1:end), method, sift_method);
[~, descriptor_cell_faces] = get_keypoints(train_faces_images(splitnumber+1:end), method, sift_method);
[~, descriptor_cell_motorbikes] = get_keypoints(train_motorbikes_images(splitnumber+1:end), method, sift_method);

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
%% Create data for classification
[data_airplane, class_labels_airplane] = construct_data(airplane_labels, [cars_labels; faces_labels; motorbike_labels], nr_clusters);
[data_cars, class_labels_cars] = construct_data(cars_labels, [airplane_labels; faces_labels; motorbike_labels], nr_clusters);
[data_faces, class_labels_faces] = construct_data(faces_labels, [airplane_labels; cars_labels; motorbike_labels], nr_clusters);
[data_motorbikes, class_labels_motorbikes] = construct_data(motorbike_labels, [airplane_labels; faces_labels; cars_labels], nr_clusters);

%% Classify
SVMModel_airplane = train(class_labels_airplane, sparse(data_airplane), '-s 1', '-wi [1 2]');
SVMModel_cars = train(class_labels_cars, sparse(data_cars), '-s 1', '-wi [1 2]');
SVMModel_faces = train(class_labels_faces, sparse(data_faces), '-s 1', '-wi [1 2]');  
SVMModel_motorbikes = train(class_labels_motorbikes, sparse(data_motorbikes), '-s 1', '-wi [1 2]');

%% Test
path_to_airplane_test = 'Caltech4/ImageData/airplanes_test/*.jpg';
path_to_cars_test = 'Caltech4/ImageData/cars_test/*.jpg';
path_to_faces_test = 'Caltech4/ImageData/faces_test/*.jpg';
path_to_motorbikes_test = 'Caltech4/ImageData/motorbikes_test/*.jpg';
amount_test_images = 50;
models = {SVMModel_airplane, SVMModel_cars, SVMModel_faces, SVMModel_motorbikes};

positive_labels = ones(amount_test_images, 1);
negative_labels = zeros(amount_test_images, 1);
[airplane_classes, labels1] = predict_SVM(models, path_to_airplane_test, amount_test_images, nr_clusters, kmeans_clusters, method, sift_method, positive_labels, negative_labels);
[cars_classes, ~] = predict_SVM(models, path_to_cars_test, amount_test_images, nr_clusters, kmeans_clusters, method, sift_method, positive_labels, negative_labels);
[faces_classes, ~] = predict_SVM(models, path_to_faces_test, amount_test_images, nr_clusters, kmeans_clusters, method, sift_method, positive_labels, negative_labels);
[motorbikes_classes, ~] = predict_SVM(models, path_to_motorbikes_test, amount_test_images, nr_clusters, kmeans_clusters, method, sift_method, positive_labels, negative_labels);

clc 

airplane_classes(airplane_classes ~= 1) = 0;
AP_airplane = calculate_AP(airplane_classes);
% 
cars_classes(cars_classes ~= 2) = 0;
cars_classes(cars_classes == 2) = 1;
AP_cars = calculate_AP(cars_classes);
% 
faces_classes(faces_classes ~= 3) = 0;
faces_classes(faces_classes == 3) = 1;
AP_faces = calculate_AP(faces_classes);
% 
motorbikes_classes(motorbikes_classes ~= 4) = 0;
motorbikes_classes(motorbikes_classes == 4) = 1;
AP_motorbikes = calculate_AP(motorbikes_classes);

MAP = (AP_airplane + AP_cars + AP_faces + AP_motorbikes) / 4

