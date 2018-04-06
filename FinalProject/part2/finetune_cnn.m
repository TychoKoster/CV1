function [net, info, expdir] = finetune_cnn(varargin)

%% Define options
run(fullfile(fileparts(mfilename('fullpath')), 'matconvnet-1.0-beta25', 'matlab', 'vl_setupnn.m')) ;

opts.modelType = 'lenet' ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.expDir = fullfile('data', ...
  sprintf('cnn_assignment-%s', opts.modelType)) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.dataDir = './data/' ;
opts.imdbPath = fullfile(opts.expDir, 'imdb-caltech.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'simplenn' ;
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;
if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;

opts.train.gpus = [];



%% update model

net = update_model();

%% TODO: Implement getCaltechIMDB function below

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath);
else
  imdb = getCaltechIMDB();
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

%%
net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

trainfn = @cnn_train ;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 2));

expdir = opts.expDir;
end
% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

end

function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5, images=fliplr(images) ; end

end

% -------------------------------------------------------------------------
function imdb = getCaltechIMDB()
% -------------------------------------------------------------------------
% Prepare the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
splits = {'train', 'test'};

%% TODO: Implement your loop here, to create the data structure described in the assignment


%%
% subtract mean
% Retrieve the images from the Caltech directory
path_to_airplane = '../Caltech4/ImageData/airplanes_train/*.jpg';
path_to_cars = '../Caltech4/ImageData/cars_train/*.jpg';
path_to_faces = '../Caltech4/ImageData/faces_train/*.jpg';
path_to_motorbikes = '../Caltech4/ImageData/motorbikes_train/*.jpg';
path_to_airplane_test = '../Caltech4/ImageData/airplanes_test/*.jpg';
path_to_cars_test = '../Caltech4/ImageData/cars_test/*.jpg';
path_to_faces_test = '../Caltech4/ImageData/faces_test/*.jpg';
path_to_motorbikes_test = '../Caltech4/ImageData/motorbikes_test/*.jpg';
train_airplane_images = retrieve_images(path_to_airplane);
train_cars_images = retrieve_images(path_to_cars);
train_faces_images = retrieve_images(path_to_faces);
train_motorbikes_images = retrieve_images(path_to_motorbikes);
test_airplane_images = retrieve_images(path_to_airplane_test);
test_cars_images = retrieve_images(path_to_cars_test);
test_faces_images = retrieve_images(path_to_faces_test);
test_motorbikes_images = retrieve_images(path_to_motorbikes_test);
% Create the imdb structure 
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
dataMean = mean(imdb.images.data(:, :, :, imdb.images.set == 1), 4);
% Subtract the mean
imdb.images.data = bsxfun(@minus, imdb.images.data, dataMean);
imdb.images.labels = single(imdb.images.labels);
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end
