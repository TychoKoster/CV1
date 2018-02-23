function G = gauss1D( sigma , kernel_size )
    G = zeros(1, kernel_size);
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end
    %% solution
    limit = floor(kernel_size/2);
    dom = -limit:1:limit;    
    second_part = (sigma * sqrt(2 * pi));
    for i = 1:kernel_size
       G(i) = exp(-((dom(i))^2)/(2 * (sigma^2)))/second_part;
    end
    G = G/sum(G);
end
