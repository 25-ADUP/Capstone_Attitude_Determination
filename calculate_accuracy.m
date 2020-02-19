function [accuracy] = calculate_accuracy(scores)
    config = ReadYaml('config.yaml');
    if config.TRUE_ANGLES == "" % Try to import file of true angle data for input video
        disp("Cannot find exact accuracy. Need file of input video attitudes.");
    else
        true_angles{:,:} = readtable(config.TRUE_ANGLES); % Create matrix of true angles
        calculated_angles = zeros(num_frames, 3);
        calculated_angles(1:1:num_frames,1) = lib_images(scores{1:1:num_frames}).theta;
        calculated_angles(1:1:num_frames,2) = lib_images(scores{1:1:num_frames}).psi;
        calculated_angles(1:1:num_frames,3) = lib_images(scores{1:1:num_frames}).phi;
        
        accuracy_count = 0;
        
        for i = 1:1:num_frames
            if true_angles{i,1} == calculated_angles{i,1}
                if true_angles{i,2} == calculated_angles{i,2}
                    if true_angles{i,3} == calculated_angles{i,3}
                        accuracy_count = accuracy_count + 1;
                    end
                end
            end
        end
        
        accuracy = ((num_frames - accuracy_count)/num_frames)*100;
        disp("Attitude estimated with " + accuracy + "% accuracy");
    end
end