%
%               PREPROCESS FILE
% This file handles all of the preprocessing that happens before live
% attitude determination. Input libraries are imported/created and processed here.
%
%
clear;

addpath(genpath('YAMLMatlab/'));
config = ReadYaml('config.yaml');

close all; % Close any opened images

tic

db = ModelStorage(config.DATABASE_ZIP); % Open priors database

if config.NEW_LIB == true
    lib_images = fetch_images(db, '', '', ''); % Fetch all library images
    
    lib_contours = cellfunprogress('Creating contours...', @(x) calc_contour_gauss(x.image, config.FILTER_WIDTH), lib_images, 'UniformOutput', false); % Get contour of library images if they do not already exist
    
    theta = cellfun(@(x) uint16(x.theta), lib_images); % Get the prior angle data for theta, psi, phi
    psi = cellfun(@(x) uint16(x.psi), lib_images);
    phi = cellfun(@(x) uint16(x.phi), lib_images);

    [num_lib_images, y] = size(lib_images); % Get the dimensions of the cell arrays
    
    bar = waitbar(0,'Building library...');
    for i = 1:1:num_lib_images
        waitbar(i / num_lib_images, bar, 'Building library...');
        db.insert_contour(theta(i), psi(i), phi(i), lib_contours{i}) % Insert contours into database
    end
    close(bar);
    disp('Finished.');
else
    disp('Fetching contours...');
    lib_contours = db.fetch_contours('', '', ''); % Fetch contours if they already exist
end

library = ContourLibrary(lib_contours, 360, 360, 360, 10, 3);

[num_frames, vid_frames, frame_rate] = create_input_frames(config.VIDEO_FILE, config.SIGMA); % Create input frames from input animation

toc % Display code runtime