function [Vx, Vy, X, Y] = lucas_kanade(im1, im2, window_size, kernel_size, sigma)
    im1 = im2double(im1);
    im2 = im2double(im2);
    
    if size(im1, 3) == 3
        im1 = rgb2gray(im1);
    end
    
    if size(im2, 3) == 3
        im2 = rgb2gray(im2);
    end
    
    
    V = [];
    X = [];
    Y = [];
    
    % How many windows possible
    parts = floor(size(im1, 1)/window_size);
    
    % Gaussian derivative
    G = fspecial('gaussian', [kernel_size kernel_size], sigma);
    [Gx,Gy] = gradient(G);
    
    % Compute gradients
    Ix = imfilter(im1, Gx, 'conv');
    Iy = imfilter(im1, Gy, 'conv');
    It = im2 - im1;
    
    % Loop over regions of window_size x window_size
    for i = 1:window_size:parts*window_size
        for j = 1:window_size:parts*window_size            
            % Compute A
            Ix_part = Ix(i:i+window_size-1, j:j+window_size-1);
            Iy_part = Iy(i:i+window_size-1, j:j+window_size-1);
            A = [Ix_part(:), Iy_part(:)];
            
            % Compute b
            It_part = It(i:i+window_size-1, j:j+window_size-1);
            b = -It_part(:);
            
            % Optical flow
            v = inv(transpose(A)*A) * transpose(A)*b;
            
            % Store result and optical flow position
            V = [V, v];
            X = [X, j+round(window_size/2)];
            Y = [Y, i+round(window_size/2)];
        end
    end
    
    % Return optical flow
    Vx = V(1, :);
    Vy = V(2, :);
end

