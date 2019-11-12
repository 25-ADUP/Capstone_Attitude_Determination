%
%               LIVE FILE
% This file handles all of the 'online' processing. Video data is read in
% here and attitude determined. Data is then sent to post-processing.
%

tic

[vid_contour] = mask_v2(num_frames, vid_frames); % Get contour of input frames
score = difference(lib_contour, vid_contour);

toc