%% calc_contour_gauss.m

% -Convert a 520x520 pixel jpg to a contour-segmented binary matrix 
% with 1s along the edges.

% Function takes number of priors and a cell containing the priors. 
% Function returns a cell

function [lib_contour] = calc_contour_gauss(lib_image_in, filter_width) % interate through each prior & perform mask
    
    % Assign matricies for library images
    % Note: had to typecase as double, otherwise throws error
    lib_image = image_fit(lib_image_in);
    I = double(lib_image(:, :, 1));
    
    % Take gradient of segmented matrix
    [Ix, Iy] = gradient(I);
    
    % Combine each directional gradient for final contour
    frame_contour = Ix.^2 + Iy.^2;
    
    % Declare Gauss filter
    lib_contour = imgaussfilt(frame_contour, filter_width);
    
end