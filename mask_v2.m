%% mask_v2.m

% -Convert a 520x520 pixel jpg to a contour-segmented binary matrix 
% with 1s along the edges.

% Function takes number of frames and a cell containing the frames. 
% Function returns a cell

function [video_contour] = mask_v2(num_frames, video_in) % interate through each frame & perform mask

for frame = 1:num_frames    % iterate through video frames
    
    % Assign matricies for each color type
    % Note: had to typecase as double, otherwise throws error
    R = double(video_in{frame}(:, :, 1));
    G = double(video_in{frame}(:, :, 2));
    B = double(video_in{frame}(:, :, 3));
    
    % Take gradient of 
    [Rx, Ry] = gradient(R);
    [Gx, Gy] = gradient(G);
    [Bx, By] = gradient(B);
    
    frame_contour = Rx.^2 + Ry.^2 + Gx.^2 + Gy.^2 + Bx.^2 + By.^2;
    
    % Declare Gauss filter
    % Note: second input modifies the width of filter
    gauss = fspecial('gaussian', 1, 1);
    
    % Convolve frame_contour with gauss filter to 'widen' our contour
    video_contour{frame} = convn((convn(frame_contour', gauss, 'same'))', gauss, 'same');
    
end

end