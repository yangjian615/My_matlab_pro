function W = eqn_wavelet_parmorlet( X, dt, freqs, w0)
%eqn_wavelet_morlet Computes the Wavelet transform of the input series with
%a Morlet mother function
%
%   Detailed explanation goes here

if nargin < 4; w0 = 6; end;

N = length(X);
fx = fft(X);

wk_pos = [0; (1:N/2)'*(2*pi)/(N*dt)];
L = length(wk_pos);
fourier_factor = 4*pi/(w0 + sqrt(2 + w0^2));

nfreqs = length(freqs);
W = zeros(nfreqs,N);

parfor i=1:nfreqs
    s = 1/(fourier_factor*freqs(i));
    psi = exp(-((s*wk_pos - w0).^2)/2);
    psi = psi * sqrt( (2*pi*s/dt) / sqrt(pi) );
    
    full_psi = [psi; zeros(N-L,1)];
    W(i,:) = ifft(fx .* full_psi);
end


end

% Tested successfully against Torrence & Compo code.
%
% Exhibits differences with irfu version. The overall image is the same,
% but values differ by a factor 0.3 (which can go as high as 0.7 at some
% times). Irfu computes 2*pi*|W|^2, so do a 2*pi*abs(wave).^2 before
% comparisons.