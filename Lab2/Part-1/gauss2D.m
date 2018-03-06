function G = gauss2D( sigma , kernel_size )
    %% solution
    limit = floor(kernel_size/2);
    dom = -limit:1:limit; 
    % Retrieve 1D Gaussian
    G_x = gauss1D(sigma, kernel_size);
    % Convolution of two 1D Gaussian kernels
    G = G_x .* G_x.';
    
            
end
