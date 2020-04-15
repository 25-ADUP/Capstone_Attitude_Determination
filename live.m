%
%               LIVE FILE
% This file handles all of the 'online' processing. Video data is read in
% here and attitude determined. Data is then sent to post-processing.
%

tic

estimated_attitudes = ModelContour.empty(0,length(vid_frames)-1); % Array to hold contours of estimated library frame index

vid_contours = cellfunprogress('Calculating video contours...', @(x) calc_contour(x), vid_frames, 'UniformOutput', false); % Get contour of input frames

% Debugging methods
%vf_dummy = vid_frames(2);
%figure;
%imagesc([vf_dummy{:}])
%vc_dummy = vid_contours(2);
%figure;
%imagesc([vc_dummy{:}])

first_index = compare(lib_contours, vid_contours(2)); % Get first contour & run whole library against it
first_contour = lib_contours{first_index{1}};
estimated_attitudes(1) = first_contour;

% More debugging
%figure;
%imagesc(lib_contours{first_index{1}}.contour);
%disp(lib_contours{first_index{1}});

[~, previous_similars] = library.get(first_contour.theta, first_contour.psi, first_contour.phi);
first_similars = previous_similars;

for i = 3:1:num_frames % Use similars to narrow estimated attitude search & calculation
    
    % next_index here is the index of previous_similars, *not* lib_contours
    next_index = compare(num2cell(previous_similars), vid_contours(i)); % Sending in similars as a cell array
    
    % The contour assiociated with next_score
    next_contour = previous_similars(next_index{1});
    
    % Add contour to estimated
    estimated_attitudes(i-1) = next_contour;
    
    [~, previous_similars] = library.get(next_contour.theta, next_contour.psi, next_contour.phi);
end

toc