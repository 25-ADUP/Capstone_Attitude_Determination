%
%               LIVE FILE
% This file handles all of the 'online' processing. Video data is read in
% here and attitude determined. Data is then sent to post-processing.
%

tic

vid_contours = cellfunprogress('Calculating contours...', @(x) calc_contour(x), vid_frames, 'UniformOutput', false); % Get contour of input frames

lib_contours = fetch_contours(db, '', '', '');

scores = compare(lib_contours, vid_contours); % Scores is 1xnum_frames list of lib_frame indicies best corresponding to frame

toc