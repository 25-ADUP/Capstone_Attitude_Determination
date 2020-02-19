%
%               POSTPROCESS FILE
% This file handles all of the postprocessing of the attitude determination
% data. Data is visualized here.
%
%
addpath(genpath('YAMLMatlab/'));
config = ReadYaml('config.yaml');
tic

%generate_heatmap(num_lib_images, num_frames, lib_contours, vid_contours)

calculate_accuracy()

%output_vid = VideoWriter(config.OUTPUT_FILE); % Attidude Determination video for Cone1 Animation
%output_vid.FrameRate = frame_rate;
% output_vid.Quality = 100;
% open(output_vid);
% 
% for i = 1:num_frames
%    I = lib_images{scores{i}}.image;
%    writeVideo(output_vid, I);
% end
% 
% close(output_vid);

toc