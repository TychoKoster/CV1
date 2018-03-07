function [ ] = tracking(images, threshold, window_harris, kernel_size, sigma, window_lucas)
    % Harris corner detection on first image
    first_image = images{1};
    [~, r, c] = harris_corner_detector(first_image, threshold, window_harris, kernel_size, sigma);
    filename = 'person_toy.gif';
    % Show results
%     ax = gca();
%     scatter(ax, c, r, 'filled');
%     hold(ax, 'on');
%     imh = imshow(images{1});
%     hold(ax, 'off')
%     uistack(imh, 'bottom')
    
    for i = 1:length(images)-1
        [Vx, Vy, ~, ~] = lucas_kanade(images{i}, images{i+1}, window_lucas, kernel_size, sigma); 
        window_indices_r = ceil(r / window_lucas);
        window_indices_c = ceil(c / window_lucas);
        
        figure('visible', 'off');
        imshow(images{i});
        hold on;
        quiver(c, r, Vx(window_indices_r), Vy(window_indices_c), 'color', 'red');
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
        
%         if i == 70
%             figure;
%             imshow(images{i});
%             hold on;
%             quiver(c, r, Vx(window_indices_c), Vy(window_indices_r), 'color', 'red');
%             break
%         end
        
        r = r + 6*Vy(window_indices_r);
        c = c + 6*Vx(window_indices_c);
            
    end
 
end

