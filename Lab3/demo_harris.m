    max_angle = 360;
    I = imrotate(I, round(rand(1) * max_angle));
    
    % Show results
    ax = gca();
    scatter(ax, c, r, 'filled');
    hold(ax, 'on');
    imh = imshow(I);
    hold(ax, 'off')
    uistack(imh, 'bottom')