%% calc_contour.m

% -Convert a 520x520 pixel jpg to a contour-segmented binary matrix 
% with 1s along the edges.

% Function takes number of frames and a cell containing the frames. 
% Function returns a cell

function [video_contour] = calc_contour(num_frames, video_in)

for frame = 1:num_frames    % iterate through video frames
    
    % Assign matricies for each color type
    % Note: had to typecase as double, otherwise throws error
    R = double(video_in{frame}(:, :, 1));
    G = double(video_in{frame}(:, :, 2));
    B = double(video_in{frame}(:, :, 3));
    
    % Take gradient of each segmented color matrix
    [Rx, Ry] = gradient(R);
    [Gx, Gy] = gradient(G);
    [Bx, By] = gradient(B);
    
    % Combine each directional color gradient for final contour
    video_contour{frame} = Rx.^2 + Ry.^2 + Gx.^2 + Gy.^2 + Bx.^2 + By.^2;

end

end