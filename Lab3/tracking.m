function [ ] = tracking(images, threshold, window_harris, kernel_size, sigma, window_lucas)
    % Harris corner detection on first image
    first_image = images{1};
    [~, r, c] = harris_corner_detector(first_image, threshold, window_harris, kernel_size, sigma);
    filename = 'pingpong.gif';
    [row_size, col_size] = size(first_image);
    for i = 1:length(images)-1
        [Vx, Vy, ~, ~] = lucas_kanade(images{i}, images{i+1}, window_lucas, kernel_size, 2); 
        % If r and c have values below 1 and the sizes, return back to
        % sizes
        r(r < 1) = 1;
        r(r > row_size) = row_size;
        c(c < 1) = 1;
        c(c > col_size) = col_size;
        % Calculate the indices of the windows of the corner points
        window_indices_r = ceil(r / window_lucas);
        window_indices_c = ceil(c / window_lucas);
        figure('Visible', 'off');
        imshow(images{i});
        hold on;
        quiver(c, r, Vx(window_indices_c), Vy(window_indices_r), 'color', 'red');
        F = getframe;
        % Capture the plot as an image 
        im = frame2im(F); 
        [imind,cm] = rgb2ind(im,256); 
        % Write to the GIF File 
        if i == 1 
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf, 'DelayTime',0.1); 
        else 
            imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime',0.1); 
        end 
        % Update corner points with scaling flow
        r = r + 2*Vy(window_indices_r);
        c = c + 2*Vx(window_indices_c);
    end
 
end

