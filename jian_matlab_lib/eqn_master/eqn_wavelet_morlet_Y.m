function W = eqn_wavelet_morlet_Y(X, dt, freqs, w0)
%eqn_wavelet_morlet Computes the Wavelet transform of the input series with
%a Morlet mother function
%
%   Detailed explanation goes here

if nargin < 4; w0 = 6; end;

N = length(X);

nanIndices = isnan(X);
X(nanIndices) = 0;
fx = fft(X);

fft_freqs = (1:(N/2))'*(1/(N*dt));
wk = [0; fft_freqs; -fft_freqs(end-1:-1:1)];

nfreqs = length(freqs);

% initialize wavelet matrix
W = zeros(nfreqs,N);

periods = 1./freqs;

for i=1:nfreqs    
    %alpha = (1/freqs(i))/(2*dt);
    %psi = exp(-(2*dt*w0)^2*((alpha*wk - (1/(2*dt))).^2)/2);
    psi = exp(-(( wk* (w0*periods(i)/dt) - w0  ).^2)/2);
    W(i,:) = ifft(fx .* psi);
    W(i,nanIndices) = NaN;
end

