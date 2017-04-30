function C = eqn_spikeCorrection(X, windowSize, nSTD, nanPrcnt, CORRECT)
%eqn_spikeCorrection 
% 
%   CORRECT = True of False to state if values will be corrected with the
%   corresponding local mean, or just set to NaN.
% 

if nargin < 5
    CORRECT = false;
end

C = X;
[mX, sX] = eqn_movingStatsNaN(X, windowSize, nanPrcnt);
ind = find(X(2:end) > mX(1:end-1) + nSTD*sX(1:end-1) | ...
           X(2:end) < mX(1:end-1) - nSTD*sX(1:end-1));
if ~isempty(ind); 
%    disp('Preprocessing: Discontinuities detected at times:');
    ind(1)
    if CORRECT
        C(ind+1) = mX(ind); 
    else
        C(ind+1) = NaN;
    end
end

end