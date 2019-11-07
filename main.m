%
%               MAIN FILE
%       ALL DA MAGIC HAPPENS HERE
%
filename = "triangle_test";
filetype = "png";

% [z, og] = read_single_image(filename, filetype);

[num_frames, vid_frames] = get_video_frames("sqwad.MOV"); % current test video is a random vid of tori
A = randi([1 num_frames],1,3); % this gets 3 random frames of the video and displays them
imshow(vid_frames{A(1)}); figure
imshow(vid_frames{A(2)}); figure
imshow(vid_frames{A(3)})
