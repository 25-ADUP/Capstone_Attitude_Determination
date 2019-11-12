% function to read in an input video file
% input string must be of the form "NAME.FILETYPE"
% saves each video frame as an image in a cell
% returns number of frames and cell array of frames
function [num_frames, vid_frames] = get_video_frames(vid_file)
    vreader = VideoReader(vid_file);
    
    num_frames = int16(vreader.FrameRate*vreader.Duration); % calculate number of frames
%     disp("Number of Frames in video is " + num_frames)
    vid_frames = {num_frames}; % create cell array of size of num_frames
    i = 1; % variable to iterate through vid_frames

    % Should try and vectorize this!
    while hasFrame(vreader) % while MATLAB can find videoframes, put each frame into vid_frames
        vid_frames{i} = image_fit(readFrame(vreader)); % image_fit will downsample the image if neccesary
        i = i + 1;
    end
end