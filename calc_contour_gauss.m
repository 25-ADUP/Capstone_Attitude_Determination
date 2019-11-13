%% calc_contour_gauss.m

% -Convert a 520x520 pixel jpg to a contour-segmented binary matrix 
% with 1s along the edges.

% Function takes number of priors and a cell containing the priors. 
% Function returns a cell

function [lib_contour] = calc_contour_gauss(num_priors, lib_in) % interate through each prior & perform mask

for frame = 1:num_priors    % iterate through priors
    
    % Assign matricies for each color type
    % Note: had to typecase as double, otherwise throws error
    R = double(lib_in{frame}(:, :, 1));
    G = double(lib_in{frame}(:, :, 2));
    B = double(lib_in{frame}(:, :, 3));
    
    % Take gradient of each segmented color matrix
    [Rx, Ry] = gradient(R);
    [Gx, Gy] = gradient(G);
    [Bx, By] = gradient(B);
    
    % Combine each directional color gradient for final contour
    frame_contour = Rx.^2 + Ry.^2 + Gx.^2 + Gy.^2 + Bx.^2 + By.^2;
    
    % Declare Gauss filter
    % Note: second input modifies the width of filter
    gauss = fspecial('gaussian', 3, 1);
    
    % Convolve frame_contour with gauss filter to 'widen' our contour
    lib_contour{frame} = convn((convn(frame_contour', gauss, 'same'))', gauss, 'same');
    
end

end