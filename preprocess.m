%
%               PREPROCESS FILE
% This file handles all of the preprocessing that happens before live
% attitude determination. Input libraries are imported/created and processed here.
%
%
close all; % Close any opened images

tic

[num_lib_frames, lib_frames] = create_library_frames(VIDEO_FILE, LIB_SUBSET_SIZE); % Create library frames from input animation
[lib_contour] = calc_contour_gauss(num_lib_frames, lib_frames, FILTER_WIDTH); % Get contour of library frames
[num_frames, vid_frames] = create_input_frames(VIDEO_FILE); % Create input frames from input animation

toc % Display code runtime