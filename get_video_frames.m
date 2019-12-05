% function to read in an input video file
% input string must be of the form "NAME.FILETYPE"
% saves each video frame as an image in a cell
% returns number of frames and cell array of frames
function [num_frames, vid_frames, frame_rate] = get_video_frames(vid_file)
    vreader = VideoReader(vid_file);
    frame_rate = vreader.FrameRate;
    num_frames = int16(frame_rate*vreader.Duration); % calculate number of frames
%     disp("Number of Frames in video is " + num_frames)
    vid_frames = {num_frames}; % create cell array of size of num_frames
    i = 1; % variable to iterate through vid_frames

    % Should try and vectorize this!
    bar = waitbar(0, 'Fetching input video...');
    while hasFrame(vreader) % while MATLAB can find videoframes, put each frame into vid_frames
        vid_frames{i} = image_fit(readFrame(vreader)); % image_fit will downsample the image if neccesary
        i = i + 1;
        waitbar(i / num_frames, bar, 'Fetching input video..');
    end
    close(bar);
end