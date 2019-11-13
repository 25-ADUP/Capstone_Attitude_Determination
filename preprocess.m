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

[num_lib_frames, lib_frames] = create_library_frames(config.VIDEO_FILE, config.LIB_SUBSET_SIZE); % Create library frames from input animation
[lib_contour] = calc_contour_gauss(num_lib_frames, lib_frames, config.FILTER_WIDTH); % Get contour of library frames
[num_frames, vid_frames] = create_input_frames(config.VIDEO_FILE); % Create input frames from input animation

toc % Display code runtime