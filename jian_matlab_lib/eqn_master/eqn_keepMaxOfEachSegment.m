function peakIndices = eqn_keepMaxOfEachSegment(indices, vals)
%eqn_keepMaxOfEachSegment ...Helper function...
%   
%   Assuming there is a list of values 'vals' and by some thresholding or
%   other criterion, there have been selected some points in it, with
%   positions specified in the 'indices' list. eqn_keepMaxOfEachSegment()
%   will find the segments of consecutive indices, check their
%   corresponding values and keep only a single index from each segment,
%   that exhibits the greatest value in this segment. 
%
%   In example, if 'indices' = [3;4;5;7;9;10] and 'vals' = 
%   [0;0;1;2;1;0;2;0;1;2], (where it is being assumed that 'indices' 
%   correspond to vals > 0 ), then from each of the three segments 
%   [3;4;5], [7] and [9;10] the function will keep only one of their
%   members, namely the one that exhibits the highest 'vals' value, so it
%   will yield 'peakIndices' = [4;7;10]
%

indSegs = eqn_breakToConsecutiveIndices(indices);
[N, R] = size(indSegs);
if R~=2; error('Error 123'); end;
peakIndices = zeros(N,1);

for i=1:N
    if diff(indSegs(i,:)) > 0
        [~, pos] = max(vals(indSegs(i,1):indSegs(i,2)));
        peakIndices(i) = indSegs(i,1) + pos - 1;
    else
        peakIndices(i) = indSegs(i,1);
    end

end

