%
%               LIVE FILE
% This file handles all of the 'online' processing. Video data is read in
% here and attitude determined. Data is then sent to post-processing.
%

tic

% [vid_contour] = calc_contour(num_frames, vid_frames); % Get contour of input frames

[vid_contour] = cellfun(@(x) calc_contour(x), vid_frames, 'UniformOutput', false);

[scores] = compare(lib_contour, vid_contour); % Scores is 1xnum_frames list of lib_frame indicies best corresponding to frame

toc