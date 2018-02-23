function G = gauss2D( sigma , kernel_size )
    %% solution
    limit = floor(kernel_size/2);
    dom = -limit:1:limit; 
    G_x = gauss1D(sigma, kernel_size);
    G = G_x .* G_x.';
    
            
end
