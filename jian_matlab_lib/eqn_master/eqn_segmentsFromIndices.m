function segments = eqn_segmentsFromIndices(X, indices, segment_lims)
%eqn_segmentsFromIndices Gets the segments of a series corresponding to
%their index values
%
%   segments = eqn_segmentsFromIndices(X, indices, segment_lims), creates a
%   matrix of the segments of series 'X' (each segment in a column) that
%   correspond to the positions indicated by the index values in the
%   'indices' list. The selection is being done based on the two values in
%   the 'segment_lims' list, namely from points 'indices' + segment_lims(1)
%   up until points 'indices' + segment_lims(2).
%
%   For example, using segment_lims = [0, 3] will yield four-point segments, 
%   from the position specified by 'indices' (including this position) and
%   extending up to 3 positions ahead.
%

if ~isempty(indices)
    L = diff(segment_lims) + 1;
    N = length(indices);
    segments = zeros(L,N);
    
    for i=1:N
        segments(:,i) = X( indices(i) + segment_lims(1) : indices(i) + segment_lims(2) );
    end
else
    segments = [];
end

end

