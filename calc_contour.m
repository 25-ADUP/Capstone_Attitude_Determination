%% calc_contour.m

% -Convert a 520x520 pixel jpg to a contour-segmented binary matrix 
% with 1s along the edges.

% Function takes number of frames and a cell containing the frames. 
% Function returns a cell

function [frame_contour] = fast_calc_contour(vid_frame_in)

    % Assign matricies for each color type
    % Note: had to typecase as double, otherwise throws error
    R = double(vid_frame_in(:, :, 1));
    G = double(vid_frame_in(:, :, 2));
    B = double(vid_frame_in(:, :, 3));

    % Take gradient of each segmented color matrix
    [Rx, Ry] = gradient(R);
    [Gx, Gy] = gradient(G);
    [Bx, By] = gradient(B);

    % Combine each directional color gradient for final contour
    frame_contour = Rx.^2 + Ry.^2 + Gx.^2 + Gy.^2 + Bx.^2 + By.^2;

end