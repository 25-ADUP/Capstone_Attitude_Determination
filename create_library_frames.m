% Code to create library for Cone1t
function [num_lib_frames, lib_frames, frame_rate] = create_library_frames(vid_file, subset_num)
    [num_frames, vid_frames, frame_rate] = get_video_frames(vid_file);
    
    num_lib_frames = int16(num_frames/subset_num);
    lib_frames = {num_lib_frames};
    i = 1;

    for j = 1:subset_num:num_frames
        lib_frames{i} = vid_frames{j};
        i = i + 1;
    end
% Need to get vectorization to work!
%     lib_frames = cellfun(@(x) x(1:subset_num:num_frames), vid_frames, 'UniformOutput', false);
end

