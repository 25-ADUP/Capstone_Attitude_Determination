%
%               LIVE FILE
% This file handles all of the 'online' processing. Video data is read in
% here and attitude determined. Data is then sent to post-processing.
%

tic

estimated_attitudes = zeros(1, num_frames); % Array to hold ints of estimated library frame index

vid_contours = cellfunprogress('Calculating video contours...', @(x) calc_contour(x), vid_frames, 'UniformOutput', false); % Get contour of input frames

first_score = compare(lib_contours, vid_contours(1)); % Get first contour & run whole library against it
estimated_attitudes(1) = first_score{1}; 
[prec_contours, previous_similars] = library.get(lib_contours{first_score{1}}.theta, lib_contours{first_score{1}}.phi, lib_contours{first_score{1}}.psi);

for i = 2:1:num_frames % Use similars to narrow estimated attitude search & calculation
    next_score = compare(num2cell(previous_similars), vid_contours(i)); % Sending in similars as a cell array
    estimated_attitudes(i) = next_score{1};
    [prec_contours, previous_similars] = library.get(lib_contours{next_score{1}}.theta, lib_contours{next_score{1}}.phi, lib_contours{next_score{1}}.psi);
end

toc