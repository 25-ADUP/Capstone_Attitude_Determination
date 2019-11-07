function [im_in, im_in_og] = read_single_image(filename, filetype)
    % interpolation not necessary bc introducing error
    % when downsampling, need to consider ailiasing
    % imresize adds a filter which should help combat that
    % or, use downsample(downsample(Im',2)',2), which takes 1 out of 4 pixels,
    % specifiying the 2, applying a gaussian to the image will combat ailiasing
    % in the downsample function
    % gauss = fspecial("gaussian",.,.) or gauss = [1/4 1/2 1/4];
    % Im_filt = convn(convn(Im',gauss,'same')','same')
    im_in_og = imread(filename, filetype); % Original input image (any size)
    [x_og, y_og] = size(im_in_og); % Orignial XY dimensions of input image

    image_size = 512; % Desired image dimension magnitude for X and Y

    % gauss = fspecial('gaussian');
    % im_filt = convn(convn(im_in_og', gauss, 'same')', 'gauss', 'same');
    % imshow(im_filt);
    % figure()

    if x_og == image_size && y_og == y_og
        disp("Input image is of correct dimensions: " + image_size + "x" + image_size);
        im_in = im_in_og;

    elseif x_og > image_size && y_og > image_size
        disp("Input image is too large, downsampling to " +  image_size + "x" + image_size);
        im_in = downsample(downsample(im_in_og', 2)', 2); % Downsample input image

    elseif x_og > image_size
        disp("Input image X dimension is too large, downsampling to " +  image_size + "x" + y_og);
        im_in = downsample(im_in_og, 2); % Downsample input image in X dimension

    elseif y_og > image_size
        disp("Input image Y dimension is too large, downsampling to " +  x_og + "x" + image_size);
        im_in = downsample(im_in_og', 2); % Downsample input image in Y dimension

    else
        im_in = im_in_og;
        disp("Input image dimensions are " + x_og + "x" + y_og);
    end

    imshow(im_in); % Display input image
end