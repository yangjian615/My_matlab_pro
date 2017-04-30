%% Wavelet parellelizing speed test
%

N = 10;
freqs = logspace(log10(0.002),log10(0.1),50)';
t = zeros(N,1);
for i=1:N
    tic;
    x = rand(10000,1);
    W = eqn_wavelet_morlet(x,1,freqs,6);
    t(i) = toc;
end
disp(['Normal Wavelet <dt> = ',num2str(mean(t)*1000),' ms']);
t = zeros(N,1);
for i=1:N
    tic;
    x = rand(10000,1);
    W = eqn_wavelet_parmorlet(x,1,freqs,6);
    t(i) = toc;
end
disp(['Parallelized Wavelet <dt> = ',num2str(mean(t)*1000),' ms']);

%%
% Conclusion: in a dual-core laptop, parallelizing DOES NOT improve things.
% The new processes that take care of parallel computing take up the time
% gained by parallelizing.
