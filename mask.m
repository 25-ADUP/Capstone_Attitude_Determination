%% mask.m

% -Convert a 520x520 pixel jpg to a contour-segmented binary matrix 
% with 1s along the edges. This code SPECIFIC TO red objects against a
% green background

% Function takes number of frames and a cell containing the frames. 
% Function returns a cell

function [masked] = mask(num_frames, frame_cell) % interate through each frame & perform mask

for frame = 1:num_frames    % iterate through video frames
    
    for row = 1:size(frame_cell{frame}, 1)  % iterate through picture pixels
        for col = 1:size(frame_cell{frame}, 2)
            if frame_cell{frame}(row, col) > 128   % if pixel is red, assign 1
                frame_bin(row, col) = 1;
            else
                frame_bin(row, col) = 0;% else, assign zero
            end
        end
    end
    
    % createt contour from binary-masked frame by taking gradient
    [Bx, By] = gradient(frame_bin);
    frame_contour = sqrt(Bx.^2 + By.^2);
    
    % Declare Gauss filter
    % Note: second input modifies the width of filter
    gauss = fspecial('gaussian', 10, 3);
    
    % Convolve frame_contour with gauss filter to 'widen' our contour
    masked{frame} = convn((convn(frame_contour', gauss, 'same'))', gauss, 'same');
    
    % Make contour more sharp - turn fractions into 1s
    for row = 1:size(masked{frame}, 1)
        for col = 1:size(masked{frame}, 2)
            if masked{frame}(row, col) > 0
                masked{frame}(row, col) = 1;
            end
        end
    end
    
end

end