%
%               DEMONSTRATION FILE
% This file will run a demonstration of the preprocess and live code that
% prints out steps, values, and images.
%
close all;
clear;

% Create the library of prior attitude data from input model video, sample
% every 2 frames
[num_lib_frames, lib_frames] = create_library_frames('Cone1Animation.mp4', 2);
imshow(lib_frames{1}); title("First library frame from Cone1Animation"); figure;

% Calculate contour of library frames with a Gaussian filter to widen the
% contour to increase probability of 'catching' input video
[lib_contour] = calc_contour(num_lib_frames, lib_frames);
imshow(lib_contour{1}); title("Contour of first library frame WITHOUT Gauss"); figure;
[lib_contour] = calc_contour_gauss(num_lib_frames, lib_frames, 5); 
imshow(lib_contour{1}); title("Contour of first library frame WITH Gauss"); figure;
[lib_contour] = calc_contour_gauss(num_lib_frames, lib_frames, 2); 

% Create input video frames from input animation, adds Gaussian noise
[num_frames, vid_frames] = create_input_frames('Cone1Animation.mp4');
imshow(vid_frames{1}); title("First input frame with added noise");

% Get contour of input frames, no need for Gaussian filter here!
[vid_contour] = calc_contour(num_frames, vid_frames);
imshow(vid_contour{1}); title("Contour of first input video frame");

% Scores is 1xnum_frames list of lib_frame indicies best corresponding to frame
scores = compare(lib_contour, vid_contour)


