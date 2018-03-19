clear;
path_to_airplane = 'Caltech4/ImageData/airplanes_train/*.jpg';
path_to_cars = 'Caltech4/ImageData/cars_train/*.jpg';
path_to_faces = 'Caltech4/ImageData/faces_train/*.jpg';
path_to_motorbikes = 'Caltech4/ImageData/motorbikes_train/*.jpg';
method = "vl_sift";
sift_method = 'vl_sift';
train_airplane_images = retrieve_images(path_to_airplane, 50);
train_cars_images = retrieve_images(path_to_cars, 50);
train_faces_images = retrieve_images(path_to_faces, 50);
train_motorbikes_images = retrieve_images(path_to_motorbikes, 50);

descriptors_airplane = get_keypoints(train_airplane_images, method, sift_method);
descriptors_cars = get_keypoints(train_cars_images, method, sift_method);
descriptors_faces = get_keypoints(train_faces_images, method, sift_method);
descriptors_motorbikes = get_keypoints(train_motorbikes_images, method, sift_method);
%% k-means
kmeans_clusters = kmeans([descriptors_airplane, descriptors_cars, descriptors_faces, descriptors_motorbikes], 400);
%% Test k-means
path_to_airplane_test = 'Caltech4/ImageData/airplanes_test/*.jpg';
test_airplane_images = retrieve_images(path_to_airplane_test, 10);
descriptors_airplane_test = get_keypoints(test_airplane_images, method, sift_method);

