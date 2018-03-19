function [features, descriptors] = get_keypoints(image_files, method, sift_method)
features = cell(length(image_files), 1);
% descriptors = cell(length(image_files), 1);
descriptors = [];
if method == 'vl_sift'
    for i = 1:length(image_files)
        if size(image_files{i},3) == 3
            [f,d] = vl_sift(single(rgb2gray(image_files{i})));
        else
            [f,d] = vl_sift(single(image_files{i}));
        end
        features{i} = f;
        descriptors = [descriptors, double(d)];
    end
    
elseif method == 'vl_dsift'
    for i = 1:length(image_files)
        if size(image_files{i},3) == 3
            [f,d] = vl_dsift(single(rgb2gray(image_files{i})));
        else
            [f,d] = vl_dsift(single(image_files{i}));
        end
        features{i} = f;
        descriptors{i} = d;
    end
    
elseif method == 'RGBSIFT'
    for i = 1:length(image_files)
        if size(image_files{i},3) == 3
            if strcmp(sift_method, 'vl_sift')
                [f, ~] = vl_sift(single(rgb2gray(image_files{i})));
                d1 = calculate_descriptors(image_files{i}, f, 1);
                d2 = calculate_descriptors(image_files{i}, f, 2);
                d3 = calculate_descriptors(image_files{i}, f, 3);
                descriptors{i} = cat(1, d1, d2, d3);
            else
                [f,d] = vl_phow(single(image_files{i}), 'Color','rgb');
                descriptors{i} = d;
            end
            features{i} = f;
        end
    end
    
elseif method == 'rgb-SIFT'
    for i = 1:length(image_files)
       if size(image_files{i},3) == 3
            if sift_method == 'vl_sift'
                image = rgb2normedrgb(image_files{i});
                [f, ~] = vl_sift(single(rgb2gray(image)));
                d1 = calculate_descriptors(image, f, 1);
                d2 = calculate_descriptors(image, f, 2);
                d3 = calculate_descriptors(image, f, 3);
                descriptors{i} = cat(1, d1, d2, d3);
            else
                [f,d] = vl_phow(single(image_files{i}), 'Color','opponent');
                descriptors{i} = d;
            end
            features{i} = f;
       end
    end
    
elseif method == 'opponentSIFT'
    for i = 1:length(image_files)
        if size(image_files{i},3) == 3
            if sift_method == 'vl_sift'
                image = rgb2opponent(image_files{i});
                [f, ~] = vl_sift(single(rgb2gray(image)));
                d1 = calculate_descriptors(image, f, 1);
                d2 = calculate_descriptors(image, f, 2);
                d3 = calculate_descriptors(image, f, 3);
                descriptors{i} = cat(1, d1, d2, d3);
            else
                [f,d] = vl_phow(single(image_files{i}), 'Color','opponent');
                descriptors{i} = d;
            end
            features{i} = f;
        end
    end
end
end