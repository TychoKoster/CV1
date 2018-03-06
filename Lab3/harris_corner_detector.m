function [H, r, c] = harris_corner_detector(I, threshold, N, kernel_size, sigma)
    % Convert to grayscale
    max_angle = 360;
    I = imrotate(I, round(rand(1) * max_angle));
    I_gray = rgb2gray(I);
    
    % Gaussian derivative
    G = fspecial('gaussian', [kernel_size kernel_size], sigma);
    [Gx,Gy] = gradient(G);

    % Image derivatives by convolving with gaussian derivative
    Ix = imfilter(I_gray, Gx, 'conv');
    Iy = imfilter(I_gray, Gy, 'conv');

    % Matrices of Q
    square_Ix = Ix.^2;
    square_Iy = Iy.^2;
    Ix_Iy = Ix .* Iy;
    % Convolve with regular gaussian G
    A = imfilter(square_Ix, G, 'conv');
    B = imfilter(Ix_Iy, G, 'conv');
    C = imfilter(square_Iy, G, 'conv');

    % Compute cornerness
    H = (A.*C - B.^2) - 0.04*((A + C).^2);
    r = [];
    c = [];

    % Ignore edges of the matrix where window cant be applied
    for x = (N/2)+1:size(H,1)-(N/2)
        for y = (N/2)+1:size(H,2)-(N/2)
            % Retrieve slices around the sample based on window size N
            slice_1 = H(x-(N/2):x-1, y-(N/2):y-1);
            slice_2 = H(x+1:x+(N/2),y+1:y+(N/2));
            slice_3 = H(x-(N/2):x-1, y+1:y+(N/2));
            slice_4 = H(x+1:x+(N/2),y-(N/2):y-1);
            slice = [slice_1, slice_2; slice_3, slice_4];
            % Maximum in neighbourhood
            max_slice = max(slice(:));
            % Detect if corner
            if (H(x,y) > max_slice) & (H(x,y) > threshold)
                r = [r,x];
                c = [c,y];
            end
        end
    end

    % Show results
    ax = gca();
    [s1,s2] = size(I);
    scatter(ax, c, r, 'filled');
    hold(ax, 'on');
    imh = imshow(I);
    hold(ax, 'off')
    uistack(imh, 'bottom')
end