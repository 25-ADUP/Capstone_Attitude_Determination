%
%               LIVE FILE
% This file handles all of the 'online' processing. Video data is read in
% here and attitude determined. Data is then sent to post-processing.
%

tic

[vid_contour] = mask_v2(num_frames, vid_frames); % Get contour of input frames
score = zeros(num_lib_frames, num_frames); % Matrix to hold score values, row is library, col is input

% Need to vectorize this!
for i = 1:1:num_lib_frames
   for j = 1:1:num_frames
       score(i, j) = difference(lib_contour{i}, vid_contour{j});
   end
end

% score(1:1:num_lib_frames, 1:1:num_frames) = difference(lib_contour{1:1:num_lib_frames}, vid_contour{1:1:num_frames})

[max_col, index] = max(score); % Find the maximum score in each col, index gives closest lib attitude

toc