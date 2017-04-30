function [c] = get_cluster_colors(scInd)
%Jian.GET_CLUSTER_COLORS get line colors for the Cluster satellites
%   c = Jian.GET_CLUSTER_COLORS() returns colors c = 1x4 cell.
%   c = Jian.GET_CLUSTER_COLORS(scInd) returns color for spacecraft scInd.
%   
%   Mostly to get the same colors in all figures.

clCol = [0,0,0; 1,0,0; 0,0.5,0; 0,0,1];

if nargin == 1
    c = clCol(scInd,:);
else
    c = clCol;
end


end

