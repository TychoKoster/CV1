function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives

% initalization
p = zeros(size(normals));
q = zeros(size(normals));
SE = zeros(size(normals));

% ========================================================================
% YOUR CODE GOES HERE
% Compute p and q, where
% p measures value of df / dx
% q measures value of df / dy


% ========================================================================

a = normals(:,:,1);
b = normals(:,:,2);
c = normals(:,:,3);
size(a)
size(b)
size(c)

p = a./c;
q = b./c;

p(isnan(p)) = 0;
q(isnan(q)) = 0;


% ========================================================================
% YOUR CODE GOES HERE
% approximate second derivate by neighbor difference
% and compute the Squared Errors SE of the 2 second derivatives SE
SE = sqrt((diff(p) - diff(q)).^2);
% ========================================================================




end

