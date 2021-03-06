%% Retrieve images and their descriptors
clear;
path_to_airplane = 'Caltech4/ImageData/airplanes_train/*.jpg';
path_to_cars = 'Caltech4/ImageData/cars_train/*.jpg';
path_to_faces = 'Caltech4/ImageData/faces_train/*.jpg';
path_to_motorbikes = 'Caltech4/ImageData/motorbikes_train/*.jpg';
method = "vl_sift";
sift_method = 'vl_sift';
amount_of_images = 400;
% Retrieve images from directory
[train_airplane_images, ~] = retrieve_images(path_to_airplane, amount_of_images);
[train_cars_images, ~] = retrieve_images(path_to_cars, amount_of_images);
[train_faces_images, ~] = retrieve_images(path_to_faces, amount_of_images);
[train_motorbikes_images, ~] = retrieve_images(path_to_motorbikes, amount_of_images);
splitnumber = 200;

% Retrieve descriptors with chosen SIFT method
[descriptors_airplane, ~] = get_keypoints(train_airplane_images(1:splitnumber), method, sift_method);
[descriptors_cars, ~] = get_keypoints(train_cars_images(1:splitnumber), method, sift_method);
[descriptors_faces, ~] = get_keypoints(train_faces_images(1:splitnumber), method, sift_method);
[descriptors_motorbikes, ~] = get_keypoints(train_motorbikes_images(1:splitnumber), method, sift_method);
%% k-means
% Amount of visual words
nr_clusters = 400;
data = cat(2, descriptors_airplane, descriptors_cars, descriptors_faces, descriptors_motorbikes);
kmeans_clusters = vl_kmeans(data, nr_clusters, 'Initialization', ...
    'plusplus', 'maxnumiterations', 100);

%% Assign labels to descriptors
[~, descriptor_cell_airplane] = get_keypoints(train_airplane_images(splitnumber+1:end), method, sift_method);
[~, descriptor_cell_cars] = get_keypoints(train_cars_images(splitnumber+1:end), method, sift_method);
[~, descriptor_cell_faces] = get_keypoints(train_faces_images(splitnumber+1:end), method, sift_method);
[~, descriptor_cell_motorbikes] = get_keypoints(train_motorbikes_images(splitnumber+1:end), method, sift_method);

airplane_labels = assign_labels(kmeans_clusters, descriptor_cell_airplane);
cars_labels = assign_labels(kmeans_clusters, descriptor_cell_cars);
faces_labels = assign_labels(kmeans_clusters, descriptor_cell_faces);
motorbike_labels = assign_labels(kmeans_clusters, descriptor_cell_motorbikes);

%% Histograms examples
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
SVMModel_airplane = train(class_labels_airplane, sparse(data_airplane), '-s 1');
SVMModel_cars = train(class_labels_cars, sparse(data_cars), '-s 1');
SVMModel_faces = train(class_labels_faces, sparse(data_faces), '-s 1');  
SVMModel_motorbikes = train(class_labels_motorbikes, sparse(data_motorbikes), '-s 1');

%% Test images
path_to_airplane_test = 'Caltech4/ImageData/airplanes_test/*.jpg';
path_to_cars_test = 'Caltech4/ImageData/cars_test/*.jpg';
path_to_faces_test = 'Caltech4/ImageData/faces_test/*.jpg';
path_to_motorbikes_test = 'Caltech4/ImageData/motorbikes_test/*.jpg';

amount_test_images = 50;

[test_airplane_images, test_airplane_paths] = retrieve_images(path_to_airplane_test, amount_test_images);
[test_cars_images, test_cars_paths] = retrieve_images(path_to_cars_test, amount_test_images);
[test_faces_images, test_faces_paths] = retrieve_images(path_to_faces_test, amount_test_images);
[test_motorbikes_images, test_motorbikes_paths] = retrieve_images(path_to_motorbikes_test, amount_test_images);

[~, descriptors_airplane_test] = get_keypoints(test_airplane_images, method, sift_method);
[~, descriptors_cars_test] = get_keypoints(test_cars_images, method, sift_method);
[~, descriptors_faces_test] = get_keypoints(test_faces_images, method, sift_method);
[~, descriptors_motorbikes_test] = get_keypoints(test_motorbikes_images, method, sift_method);

airplane_labels_test = assign_labels(kmeans_clusters, descriptors_airplane_test);
cars_labels_test = assign_labels(kmeans_clusters, descriptors_cars_test);
faces_labels_test = assign_labels(kmeans_clusters, descriptors_faces_test);
motorbike_labels_test = assign_labels(kmeans_clusters, descriptors_motorbikes_test);

[data_airplane_test, class_labels_airplane_test] = construct_data(airplane_labels_test, [cars_labels_test; faces_labels_test; motorbike_labels_test], nr_clusters);
[data_cars_test, class_labels_cars_test] = construct_data(cars_labels_test, [airplane_labels_test; faces_labels_test; motorbike_labels_test], nr_clusters);
[data_faces_test, class_labels_faces_test] = construct_data(faces_labels_test, [airplane_labels_test; cars_labels_test; motorbike_labels_test], nr_clusters);
[data_motorbikes_test, class_labels_motorbikes_test] = construct_data(motorbike_labels_test, [airplane_labels_test; faces_labels_test; cars_labels_test], nr_clusters);

models = {SVMModel_airplane, SVMModel_cars, SVMModel_faces, SVMModel_motorbikes};

%% Predict the classes and sort them based on confidence score
[labels_ranking_airplane, sort_order_airplane] = predict_SVM(models{1}, data_airplane_test, class_labels_airplane_test);
[labels_ranking_cars, sort_order_cars] = predict_SVM(models{2}, data_cars_test, class_labels_cars_test);
[labels_ranking_faces, sort_order_faces] = predict_SVM(models{3}, data_faces_test, class_labels_faces_test);
[labels_ranking_motorbikes, sort_order_motorbikes] = predict_SVM(models{4}, data_motorbikes_test, class_labels_motorbikes_test);

%% Calculate the AP for every class
AP_airplane = calculate_AP(labels_ranking_airplane)
AP_cars = calculate_AP(labels_ranking_cars)
AP_faces = calculate_AP(labels_ranking_faces)
AP_motorbikes = calculate_AP(labels_ranking_motorbikes)

% MAP for classifier
MAP = (AP_airplane + AP_cars + AP_faces + AP_motorbikes) / 4

%% Images sorted and create html for the ranking of the images.
images_airplane = [test_airplane_paths, test_cars_paths, test_faces_paths, test_motorbikes_paths];
sorted_images_airplane = images_airplane(sort_order_airplane);
images_cars = [test_cars_paths, test_airplane_paths, test_faces_paths, test_motorbikes_paths];
sorted_images_cars = images_cars(sort_order_cars);
images_faces = [test_faces_paths, test_airplane_paths, test_cars_paths, test_motorbikes_paths];
sorted_images_faces = images_faces(sort_order_faces);
images_motorbikes = [test_motorbikes_paths, test_airplane_paths, test_faces_paths, test_cars_paths];
sorted_images_motorbikes = images_motorbikes(sort_order_motorbikes);

html = generate_html_string(sorted_images_airplane, sorted_images_cars, sorted_images_faces, sorted_images_motorbikes);

fprintf(fopen('html.txt', 'w'), html);