%
%               PREPROCESS FILE
% This file handles all of the preprocessing that happens before live
% attitude determination. Input libraries are imported/created and processed here.
%
%
close all; % Close any opened images

tic

[num_lib_frames, lib_frames] = create_library_frames("Cone1Animation.avi", 2); % Create library frames from input animation
[lib_contour] = mask_v2(num_lib_frames, lib_frames); % Get contour of library frames
[num_frames, vid_frames] = create_input_frames("Cone1Animation.avi"); % Create input frames from input animation

toc % Display code runtime