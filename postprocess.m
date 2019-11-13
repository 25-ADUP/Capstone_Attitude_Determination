%
%               POSTPROCESS FILE
% This file handles all of the postprocessing of the attitude determination
% data. Data is visualized here.
%
%
tic

generate_heatmap(num_lib_frames, num_frames, lib_contour, vid_contour)

% output_vid = VideoWriter('AD_Cone1Animation.avi'); % Attidude Determination video for Cone1 Animation
% open(output_vid);
% output_vid_frames = {num_frames};
% 
% for i = 1:1:num_frames
%    writeVideo(output_vid, im2frame(lib_frames{index(i)}));
%    imshow(lib_frames{index(i)});
%    figure()
% end

% writeVideo(output_vid, output_vid_frames);

toc