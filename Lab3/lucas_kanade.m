function [ ] = lucas_kanade(im1, im2, window_size, kernel_size, sigma)
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
    
    V = [];
    x = [];
    y = [];
    
    % How many windows possible
    parts = mod(size(im1, 1), window_size);
    
     % Gaussian derivative
    G = fspecial('gaussian', [kernel_size kernel_size], sigma);
    [Gx,Gy] = gradient(G);

    % Loop over regions of window_size x window_size
    for i = 1:window_size:parts*window_size
        for j = 1:window_size:parts*window_size
            submatrix_im1 = double(im1(i:i+window_size-1, j:j+window_size-1));
            submatrix_im2 = double(im2(i:i+window_size-1, j:j+window_size-1));
            
            % Image derivatives by convolving with gaussian derivative
            Ix = imfilter(submatrix_im1, Gx, 'conv');
            Iy = imfilter(submatrix_im1, Gy, 'conv');
            A = [Ix(:), Iy(:)];
            
            % -It
            b = -(submatrix_im2(:) - submatrix_im1(:));
            v = inv(transpose(A)*A) * transpose(A)*b;
            
            % Store results
            V = [V, v];
            x = [x, i+round(window_size/2)];
            y = [y, j+round(window_size/2)];
        end
    end
    % Plot optical flow
    Vx = V(1, :);
    Vy = V(2, :);
    
    imshow(im1);
    hold on;
    quiver(x, y, Vx, Vy);
end

