function [] = generate_heatmap(num_lib_frames, num_frames, lib_contour, vid_contour)
    score = zeros(num_lib_frames, num_frames); % Matrix to hold score values, row is library, col is input

    % Need to vectorize this!
    for i = 1:1:num_lib_frames
       for j = 1:1:num_frames
           score(i, j) = difference(lib_contour{i}, vid_contour{j});
       end
    end

    h = heatmap(score);
    title('Heatmap of Computed Difference Scores')
    xlabel('Input Frames')
    ylabel('Library Frames')
end