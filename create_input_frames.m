% This function will create 'input data' from an animation by reading in
% each frame, adding noise, and converting it to grayscale.
% Need to modify mask_v2 to accept grayscale.
function [num_frames, vid_frames] = create_input_frames(vid_file, Sigma)
    addpath(genpath('YAMLMatlab/'));
    config = ReadYaml('config.yaml');
    
    [num_frames, vid_frames, frame_rate] = get_video_frames(vid_file); % Get the video frames
% %     [x_size,y_size,color] = size(vid_frames{1});
% %     for i = 1:1:num_frames
% %         noise = Sigma*rand([x_size,y_size,3]);
% %         vid_frames{i}(:,:,1) = double(vid_frames{i}(:,:,1)) + noise(:,:,1);
% %         vid_frames{i}(:,:,2) = double(vid_frames{i}(:,:,2)) + noise(:,:,2);
% %         vid_frames{i}(:,:,3) = double(vid_frames{i}(:,:,3)) + noise(:,:,3);
% %     end
%     vid_frames = cellfun(@(x) x + config.SIGMA*randn(x_size,y_size,3), vid_frames, 'UniformOutput', false);
    vid_frames = cellfun(@(x) imgaussfilt(x, 2), vid_frames, 'UniformOutput', false); % Add noise to frames
%     vid_frames = cellfun(@(x) rgb2gray(x), vid_frames, 'UniformOutput', false); % Convert to grayscale

end
