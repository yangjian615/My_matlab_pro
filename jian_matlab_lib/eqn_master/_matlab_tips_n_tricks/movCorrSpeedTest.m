function movCorrSpeedTest()
% Moving correlations speed test: 
%
% If performing simple series vs series correlations, use the default
% corrcoef() function. For correlations between a series and a smaller
% sample, in a "sliding window" sense, use the custom method, that takes
% advantage of the filter() command.
%

clear;
L = 100000; % series length
S = 100;  % sample size
series = rand(L,1);
sample = rand(S,1);
tic
% using filter()
c2 = corr2(series,sample);
toc
tic
%baseline
c1 = corr1(series,sample);
toc

[c1(end-10:end), c2(end-10:end)]


end

function c = corr1(x, sample)
    L = length(x);
    S = length(sample);
    N = L - S + 1; % No of gliding windows to calculate corrs
    c = zeros(N, 1);
    X = zeros(S,2);
    X(:,1) = sample;
    for i = 1:N
        X(:,2) = x(i:S + i - 1);
        corr_mat = corrcoef(X);
        c(i) = corr_mat(1,2);
    end
    
end

function c = corr2(x, sample)
    S = length(sample);
    [AVG, STDEV] = eqn_movingStDev(x, S);
    m = mean(sample); s = std(sample);
    c = filter(sample(end:-1:1), 1, x);
    c = (c - S*m*AVG)./((S-1)*s*STDEV);
    c = c(S:end);
end
