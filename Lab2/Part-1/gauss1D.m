function G = gauss1D( sigma , kernel_size )
    G = zeros(1, kernel_size);
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end
    %% solution
    limit = floor(kernel_size/2);
    % Compute domain of X
    dom = -limit:1:limit;  
    % Gaussian equation
    G = exp(-(dom.^2)/(2 * sigma^2))/(sigma * sqrt(2 * pi));
    % Normalize
    G = G/sum(G);
end
