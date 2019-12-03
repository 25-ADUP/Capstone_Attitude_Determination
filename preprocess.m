%
%               PREPROCESS FILE
% This file handles all of the preprocessing that happens before live
% attitude determination. Input libraries are imported/created and processed here.
%
%
addpath(genpath('YAMLMatlab/'));
config = ReadYaml('config.yaml');

close all; % Close any opened images

tic

% db = ModelStorage(config.DATABASE_ZIP);

theta = (0:10:360);
psi = (0:10:180);
phi = (0);

% lib_images = fetch_masks(db, '', '', '');
% num_lib_images = size(lib_images);
% lib_contours = calc_contour_gauss(num_lib_images, lib_images, config.FILTER_WIDTH);


[num_lib_frames, lib_frames, frame_rate] = create_library_frames(config.VIDEO_FILE, config.LIB_SUBSET_SIZE); % Create library frames from input animation
[lib_contour] = cellfun(@(x) calc_contour_gauss(x, config.FILTER_WIDTH), lib_frames, 'UniformOutput', false); % Get contour of library frames
[num_frames, vid_frames] = create_input_frames(config.VIDEO_FILE, config.SIGMA); % Create input frames from input animation

toc % Display code runtime