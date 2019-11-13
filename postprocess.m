%
%               POSTPROCESS FILE
% This file handles all of the postprocessing of the attitude determination
% data. Data is visualized here.
%
%
tic

generate_heatmap(num_lib_frames, num_frames, lib_contour, vid_contour)

output_vid = VideoWriter('Reconstruced Video'); % Attidude Determination video for Cone1 Animation
open(output_vid);

for i = 1:num_frames
   I = lib_frames{scores(i)};
   writeVideo(output_vid, I);
end

close(output_vid);

toc