% function to read in an input video file
% input string must be of the form "NAME.FILETYPE"
function [num_frames, vid_frames] = get_video_frames(vid_file)
    vreader = VideoReader(vid_file);
    
    num_frames = vreader.FrameRate*vreader.Duration;
    disp("Number of Frames in video is " + num_frames)
    vid_frames = [];
    
    % could try and save frames as a huge list of frames or as a bunch of
    % individual jps...but that might be processor intensive
    while hasFrame(vreader)
        new_frame = readFrame(vreader);
        vid_frames = [vid_frames new_frame;
        i = i + 1;
        disp(i)
    end
end