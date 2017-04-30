function movingWindowLenghts = eqn_movingWindowLengthExcludingNaNs(nanLogicalIndex, windowSize)
%eqn_movingWindowLengthExcludingNaNs                       Helper function
% 
%   When performing operations of a sliding window on a series, there is a
%   chance that some of these windows will include one or more NaN values.
%   In this case, the "active" length of the window, meaning the non-NaN
%   points that are included in it, will be equal to the original window
%   size minus the NaNs that were included! This function performs this
%   counting.
%
%   movingWindowLenghts = eqn_movingWindowLengthExcludingNaNs(...
%                                             nanLogicalIndex, windowSize)
%   with nanLogicalIndex being the result of isnan() on the series, namely
%   a vector of 1s in places where there are NaN values and 0s elsewhere
%   and 'windowSize' being the size (in number of points) of the sliding
%   window to be used in later operations. 
%   The result assumes a step of 1 point for the sliding window. If more
%   are used, select the appropriate entries from the result i.e. for step
%   equal to 5 take movingWindowLenghts(5:5:end).
% 
%   NOTE: The function is written so that the result will have a direct
%   correspondence with the output of the filter() function.
%

L = length(nanLogicalIndex);
nanIndex = find(nanLogicalIndex);

% Initialize output
movingWindowLenghts = windowSize*ones(L,1);
movingWindowLenghts(1:windowSize-1) = (1:windowSize-1)';

if ~isempty(nanIndex)
% There are two methods. The first is faster for window sizes lower than
% 500 and the second is faster for window sizes greater than 500 (approx.).
% Test and select the appropriate one.
if windowSize < 500
    % Method 1 (loop over 'windowSize')
    movingWindowLenghts(nanIndex) = movingWindowLenghts(nanIndex) - 1;
    for i=2:windowSize
        if ~isempty(nanIndex)
            nanIndex = nanIndex + 1;
            if nanIndex(end) > L; nanIndex(end) = []; end;
            movingWindowLenghts(nanIndex) = movingWindowLenghts(nanIndex) - 1;
        else
             break;
        end
    end
else
    % Method 2 (loop over NaNs)
    for i=1:length(nanIndex)
        init = nanIndex(i);
        fin = min([nanIndex(i) + windowSize - 1, L]);
        movingWindowLenghts(init:fin) = movingWindowLenghts(init:fin) - 1;
    end
end
end

end

