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

mask_1 = masked{A(1)};
mask_2 = masked{A(2)};
mask_3 = masked{A(3)};
imshow(mask_1); figure
imshow(mask_2); figure
imshow(mask_3); figure

diff_1_1 = difference(mask_1, mask_1)
diff_2_2 = difference(mask_2, mask_2)
diff_3_3 = difference(mask_3, mask_3)
diff_1_2 = difference(mask_1, mask_2)
diff_2_3 = difference(mask_2, mask_3)


% video = {image_fit(imread('triangle_test.png')), image_fit(imread('suplex.png'))};
% frames = 2;

% frames_masked = mask(frames, video);
% imshow(frames_masked{1}); figure();
% imshow(frames_masked{2});

