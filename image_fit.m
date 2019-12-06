function [im_in] = image_fit(im_in_og)
    addpath(genpath('YAMLMatlab/'));
    config = ReadYaml('config.yaml');
    [x_og, y_og, ~] = size(im_in_og); % Orignial XY dimensions of input image

    image_size = config.IMAGE_SIZE; % Desired image dimension magnitude for X and Y
    x_factor = int16(x_og/image_size);
    y_factor = int16(y_og/image_size);

    if x_og == image_size && y_og == y_og
        im_in = im_in_og;

    elseif x_og > image_size && y_og > image_size
        im_in = im_in_og(1:x_factor:end,1:y_factor:end,:);

    elseif x_og > image_size && y_og < image_size
        im_in = im_in_og(1:x_factor:end,:,:); % Downsample input image in X dimension

    elseif y_og > image_size && x_og < image_size
        im_in = im_in_og(:,1:y_factor:end,:); % Downsample input image in Y dimension
    end
end