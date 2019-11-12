function [im_in] = image_fit(im_in_og)
    [x_og, y_og, z_color] = size(im_in_og); % Orignial XY dimensions of input image
%     disp("Original dimensions: "+x_og+"x"+y_og);
    image_size = 512; % Desired image dimension magnitude for X and Y
    x_factor = int16(x_og/image_size);
    y_factor = int16(y_og/image_size);

    if x_og == image_size && y_og == y_og
%         disp("Input image is of correct dimensions: " + image_size + "x" + image_size);
        im_in = im_in_og;

    elseif x_og > image_size && y_og > image_size
%         disp("Input image is too large, downsampling to " +  image_size + "x" + image_size);
        im_in = im_in_og(1:x_factor:end,1:y_factor:end,:);
%         [x_og, y_og, z_color] = size(im_in);
%         disp("Current dimensions: "+x_og+"x"+y_og);

    elseif x_og > image_size && y_og < image_size
%         disp("Input image X dimension is too large, downsampling to " +  image_size + "x" + y_og);
        im_in = im_in_og(1:x_factor:end,:,:); % Downsample input image in X dimension

    elseif y_og > image_size && x_og < image_size
%         disp("Input image Y dimension is too large, downsampling to " +  x_og + "x" + image_size);
        im_in = im_in_og(:,1:y_factor:end,:); % Downsample input image in Y dimension
    end
end