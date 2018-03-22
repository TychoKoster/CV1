function [ imdb ] = getCaltechIMDB()
    path_to_airplane = 'Caltech4/ImageData/airplanes_train/*.jpg';
    path_to_cars = 'Caltech4/ImageData/cars_train/*.jpg';
    path_to_faces = 'Caltech4/ImageData/faces_train/*.jpg';
    path_to_motorbikes = 'Caltech4/ImageData/motorbikes_train/*.jpg';
    path_to_airplane_test = 'Caltech4/ImageData/airplanes_test/*.jpg';
    path_to_cars_test = 'Caltech4/ImageData/cars_test/*.jpg';
    path_to_faces_test = 'Caltech4/ImageData/faces_test/*.jpg';
    path_to_motorbikes_test = 'Caltech4/ImageData/motorbikes_test/*.jpg';
    amount_of_images = 50;
    train_airplane_images = retrieve_images(path_to_airplane, amount_of_images);
    train_cars_images = retrieve_images(path_to_cars, amount_of_images);
    train_faces_images = retrieve_images(path_to_faces, amount_of_images);
    train_motorbikes_images = retrieve_images(path_to_motorbikes, amount_of_images);
    test_airplane_images = retrieve_images(path_to_airplane_test, amount_of_images);
    test_cars_images = retrieve_images(path_to_cars_test, amount_of_images);
    test_faces_images = retrieve_images(path_to_faces_test, amount_of_images);
    test_motorbikes_images = retrieve_images(path_to_motorbikes_test, amount_of_images);
    imdb = struct;
    imdb.images.data = [];
    imdb.images.labels = [];
    imdb.images.set = [];
    imdb = addData(imdb, 1, train_airplane_images, 1);
    imdb = addData(imdb, 2, train_cars_images, 1);
    imdb = addData(imdb, 3, train_faces_images, 1);
    imdb = addData(imdb, 4, train_motorbikes_images, 1);
    imdb = addData(imdb, 1, test_airplane_images, 2);
    imdb = addData(imdb, 2, test_cars_images, 2);
    imdb = addData(imdb, 3, test_faces_images, 2);
    imdb = addData(imdb, 4, test_motorbikes_images, 2);
    imdb.images.data = single(imdb.images.data);
    imdb.meta.sets = {'train', 'validation'};
    imdb.meta.classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
end