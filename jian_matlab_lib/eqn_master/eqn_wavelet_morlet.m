function W = eqn_wavelet_morlet(X, dt, freqs, w0)
%eqn_wavelet_morlet Computes the Wavelet transform of the input series with
%a Morlet mother function
%
%   Detailed explanation goes here

if nargin < 4; w0 = 6; end;

N = length(X);

nanIndices = isnan(X);
X(nanIndices) = 0;
fx = fft(X);

% Angular frequency defined as (2*pi*k)/(N*dt) for k <= (N/2) 
% and -(2*pi*k)/(N*dt) for k > (N/2). We are keeping only the 
% positive part, as the negative will be removed by the use 
% of the Heaviside function, so there is no need to waste time
% with these computations.
wk_pos = [0; (1:N/2)'*(2*pi)/(N*dt)];

L = length(wk_pos);

% Factor that defines the correspondance between wavelet scales 
% and fourier frequencies by: 
% fourier_wavelength = fourier_factor * wavelet_scale
fourier_factor = 4*pi/(w0 + sqrt(2 + w0^2));

nfreqs = length(freqs);

% initialize wavelet matrix
W = zeros(nfreqs,N);

for i=1:nfreqs
    % derive corresponding 'scale' from 'freq'
    s = 1/(fourier_factor*freqs(i));
    
    % take the fft of the mother function - no need to do it
    % computationally, it is already given theoretically by
    % psi = pi^(-1/4) * H(w) * exp( -((s*w - w0)^2)/2 )
    % with H(w) being the Heavyside function (done below)
    psi = pi^(-1/4) * exp(-((s*wk_pos - w0).^2)/2);
    
    % normalization by sqrt(2*pi*s/dt)
    psi = psi * sqrt(2*pi*s/dt);
    
    % keep only positive part, due to the H(w)
    full_psi = [psi; zeros(N-L,1)];
    
    % get wavelet transform through ifft( fft(x) * fft(mother) )
    W(i,:) = ifft(fx .* full_psi);
    
    % reset NaN values
    W(i,nanIndices) = NaN;
end


end

% Tested successfully against Torrence & Compo code.