function Y = eqn_stepRemoval(X, windowSize, N_sigma)
%eqn_stepRemoval Attempts to remove step-like discontinuities form a series
%
%   Y = eqn_stepRemoval(X, windowSize), applies the eqn_spikeRemoval()
%   function on the differential of the X series, in order to correct step
%   like discontinuities, which will appear as spikes in the differential.
%   Type "help eqn_spikeRemoval" for details.
%   
%   Y = eqn_stepRemoval(X, windowSize, N_sigma), does the same for points
%   that deviate by more than 'N_sigma' standard deviations.
%

if(nargin < 3); N_sigma = 3; end;
dX = diff(X);
dY = eqn_spikeRemoval(dX, windowSize, N_sigma);
d2 = [X(1); dY];
% take the cumulative of the diff() series to produce the corrected original
Y = filter(1, [1, -1], d2);

end