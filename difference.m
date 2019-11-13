% This function finds the value of the unit product between two images
function [score] = difference(model_mask, input_mask)
    score = sum(model_mask .* input_mask, 'all');
end
