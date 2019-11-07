function [im_in] = image_fit(im_in_og)
    [x_og, y_og, z_color] = size(im_in_og); % Orignial XY dimensions of input image
%     disp("Original dimensions: "+x_og+"x"+y_og);
    image_size = 512; % Desired image dimension magnitude for X and Y

    if x_og == image_size && y_og == y_og
%         disp("Input image is of correct dimensions: " + image_size + "x" + image_size);
        im_in = im_in_og;

    elseif x_og > image_size && y_og > image_size
%         disp("Input image is too large, downsampling to " +  image_size + "x" + image_size);
        im_in = downsample(permute(downsample(permute(im_in_og, [2 1 3]), 2), [2 1 3]), 2); % Downsample input image

    elseif x_og > image_size && y_og < image_size
%         disp("Input image X dimension is too large, downsampling to " +  image_size + "x" + y_og);
        im_in = downsample(im_in_og, 2); % Downsample input image in X dimension

    elseif y_og > image_size && x_og < image_size
%         disp("Input image Y dimension is too large, downsampling to " +  x_og + "x" + image_size);
        im_in = downsample(permute(im_in_og, [2 1 3]), 2); % Downsample input image in Y dimension
    
    else
        im_in = im_in_og;
%         disp("Input image dimensions are " + x_og + "x" + y_og);
    end
end