% This function will create 'input data' from an animation by reading in
% each frame, adding noise, and converting it to grayscale.
% Need to modify mask_v2 to accept grayscale.
function [num_frames, vid_frames] = create_input_frames(vid_file)
    [num_frames, vid_frames] = get_video_frames(vid_file); % Get the video frames

    vid_frames = cellfun(@(x) imgaussfilt(x, 2), vid_frames, 'UniformOutput', false); % Add noise to frames
%     vid_frames = cellfun(@(x) rgb2gray(x), vid_frames, 'UniformOutput', false); % Convert to grayscale

end
