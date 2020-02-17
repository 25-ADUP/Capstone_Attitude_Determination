function [vector] = quicksort(vector)
%quicksort Sort row  vector in ascending order using a variant of Quicksort
% Quicksort implementation
% Original work: C. A. R. Hoare: Quicksort. In: The Computer Journal. 5(1),
% 1962, p. 10?15.
% This implementation works in place and runs in O(n)=n*log(n) (average case).
% There are no practical advantages over the build-in sort function.
% The purpose of this implementation is to show that quicksort can be
% implemented in Matlab with O(n)=n*log(n) average case runtime.
% Author: Christian Werner, Ostfalia Hochschule f? angewandte Wissenschaften 
% Date: 31.03.2018
%
% Syntax:   y = quicksort(x);
% Input:    x is a row vector of length n (n>0)
% Output:   y is a row vector containing all elements of x in ascending order
%
% Taken from https://www.mathworks.com/matlabcentral/fileexchange/66704-quicksort
% Modified by Sierra MacLeod to work on objects

    if numel(vector) <= 1 % vectors with one or less elements are sorted
        return
    else
        [m, ~] = size(vector);
        if m~=1
            error("quicksort: input argument must be a row vector");
        end
        
        pivot=vector(1);  % take first value as pivot element
                          % randomization would help avoiding worst case
                          % runtime
        % We need three partitions in order to make use of Matlabs
        % in-place processing feature.
        vector = [ quicksort( vector(arrayfun(@(elm) elm.lt(pivot), vector)))...
                   vector(arrayfun(@(elm) elm.eq(pivot), vector))...
                   quicksort(vector(arrayfun(@(elm) elm.gt(pivot), vector))) ]; 
    end
end