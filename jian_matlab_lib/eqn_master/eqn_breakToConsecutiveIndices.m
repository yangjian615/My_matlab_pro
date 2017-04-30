function segments = eqn_breakToConsecutiveIndices(X)
%eqn_breakToConsecutiveIndices ...Helper function...
%   
%   Assuming 'X' is a list of index values, some of which are consecutive,
%   i.e. [4,5,6,10,14,15], then eqn_breakToConsecutiveIndices(X) will break
%   'X' into pairs of ['from','to'] values, corresponding to the
%   consecutive indices. For the above example, the output 'segments' will
%   be a 3x2 matrix, composed of the pairs [4,6]; [10,10]; [14,15].
%
%   It is being used in time series preprocessing, when various problematic
%   areas have been discovered and are given in index notation, i.e. it has
%   been found that there are NaN values in the positions with indices 
%   [12,13,14,22,34,35]. Use of this function will break this list into
%   three rows of two elements each. The first, [12,14] gives the range of
%   indices of the first problematic area, so that it can be accessed as
%   "series( segments(1,1) : segments(1,2) )". Likewise, the next two ares
%   will be [22,22], corresponding to the single point "series(22:22)" and
%   [34,35] for the points "series(34:35)".

if ~isempty(X)
    ends = find(diff(X)>1);

    if ~isempty(ends)
        n_segs = length(ends);
        last_singl_segm = 0;
        if ends(end) < length(X)
            n_segs = n_segs + 1;
            last_singl_segm = 1;
        end

        segments = zeros(n_segs,2);
        segments(1,1) = X(1); segments(1,2) = X(ends(1)); 
        for i=2:n_segs - last_singl_segm
            segments(i,1) = X(ends(i - 1) + 1);
            segments(i,2) = X(ends(i));
        end
        if last_singl_segm == 1
            segments(end,1) = X(ends(end)+1);
            segments(end,2) = X(end);
        end
    else
        % no diffs => only consecutive indices => only one single segment
        segments = [X(1), X(end)];
    end
else
    segments = [];
end

end

