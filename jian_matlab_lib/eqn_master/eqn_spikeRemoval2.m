function Y = eqn_spikeRemoval2(X, windowSize, N_sigma)
%UNTITLED2 Summary of this function goes here
%
%   Detailed explanation goes here

L = length(X);
t = (1:L)';
Y = X;

%segmentation
segs = round(linspace(1,L,(L/windowSize)+1)');
for i=1:length(segs)-1
    ki = segs(i);
    kf = segs(i+1);
    sx = X(ki:kf);
    st = t(ki:kf);
    trend = eqn_trendline(sx,'linear');
    d = abs(sx - trend);
    m = mean(d);
    s = std(d);
    f = find(d > m + N_sigma*s);
    
    if ~isempty(f)
        corr_sx = sx; corr_sx(f) = NaN;
        corr_st = st;
        corr_trend = eqn_trendline([corr_sx,corr_st],'linear');
        Y(f + ki -1) = corr_trend(f);
    end
    
end


end

