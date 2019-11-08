%
%               MAIN FILE
%       ALL DA MAGIC HAPPENS HERE
%
close all;
filename = "triangle_test";
filetype = "png";

% [z, og] = read_single_image(filename, filetype);

[num_frames, vid_frames] = get_video_frames("sqwad.MOV"); % current test video is a random vid of tori
masked = mask(num_frames, vid_frames)
A = randi([1 num_frames],1,3); % this gets 3 random frames of the video and displays them
imshow(masked{A(1)}); figure
imshow(masked{A(2)}); figure
imshow(masked{A(3)}); figure




% video = {image_fit(imread('triangle_test.png')), image_fit(imread('suplex.png'))};
% frames = 2;

% frames_masked = mask(frames, video);
% imshow(frames_masked{1}); figure();
% imshow(frames_masked{2});

