function Y = eqn_spikeRemoval(X, windowSize, N_sigma)
%eqn_spikeRemoval Attempts to remove spikes form a series
%
%   Y = eqn_spikeRemoval(X, windowSize), calculates the moving average and
%   moving standard deviation of 'X', using a window of size 'windowSize'
%   points and then finds points in X that deviate from the mean of the 
%   previous 'windowSize' points by more than 3 standard deviations. These 
%   points are then replaced by the value of the moving average of the
%   previous 'windowSize' points.
%
%   Note: The first 'windowSize' - 1 points will not be included in the
%   analysis, since there is not enough data to fill the averaging window. 
%
%   Y = eqn_spikeRemoval(X, windowSize, N_sigma), does the same for points
%   that deviate by more than 'N_sigma' standard deviations.
%

if(nargin < 3); N_sigma = 3; end;

L = length(X);
if windowSize >= L
    M = ones(L,1) * mean(X);
    S = ones(L,1) * std(X);
else
    [M, S] = eqn_movingStDev(X, windowSize);
end

% compare X(i) against the mean of the previous X(i-ws:i-1) points,
% so that X(i) is NOT included in the averaging window
deviations = abs(X(2:end) - M(1:end-1))./S(1:end-1);
spikes = find(deviations > N_sigma) + 1;
Y = X;
% ignore first 'windowSize' points (not enough samples)
if ~isempty(spikes); 
    spikes = spikes(spikes > windowSize);
    Y(spikes) = M(spikes-1);
    N = length(spikes); 
    disp(['Corrected ',num2str(N,'%d'),' data points (',num2str(100*N/L,'%.2f'),'%)']);
end;

end

