function [Y, A, B] = eqn_filter(X, dt, freq, type, name, order, R)
%eqn_filter Zero phase filtering of data
%
%   Y = eqn_filter(X, dt, freq, type) filters data in X, assuming a
%   sampling time of 'dt' in secs, with a cutoff frequency of 'freq' in Hz.
%   'type' can be any of the following:
%
%   - 'high' : for a high-pass filter
%   - 'low'  : for a low-pass filter
%   - 'pass' : for a band-pass filter, in which case 'freq' must be a
%   vector of two values, the initial and final frequencies of the bandpass
%   range
%
%   X can be a simple column of values, or a TIME_SERIES matrix.
%
%   In all cases filtering is being performed with the Butterworth family
%   of filters and is being executed twice (forward and reverse) in order
%   to have a zero phase shift filtering result.
%
%   Y = eqn_filter(X, dt, freq, type, filter_name) works as above, but for
%   more filter types. Additional parameters can be set as is shown below:
%
%   - 'butter' : Butterworth filters
%     Y = eqn_filter(..., 'butter')
%     Y = eqn_filter(..., 'butter', order)
%   - 'ellip' : Elliptical filters
%     Y = eqn_filter(..., 'ellip')
%     Y = eqn_filter(..., 'ellip', order)
%     Y = eqn_filter(..., 'ellip', order, [Rp Rs])
%   - 'cheby1' : Chebysev-1 filters
%     Y = eqn_filter(..., 'cheby1')
%     Y = eqn_filter(..., 'cheby1', order)
%     Y = eqn_filter(..., 'cheby1', order, Rp)
%   - 'cheby2' : Chebysev-2 filters
%     Y = eqn_filter(..., 'cheby2')
%     Y = eqn_filter(..., 'cheby2', order)
%     Y = eqn_filter(..., 'cheby2', order, Rs)
%
%   with ''order'' being the filter order, ''Rp'' the decibels of
%   peak-to-peak ripple and ''Rs'' the decibels of minimum stopband
%   attenuation. Defaults values correspond to an order of 5, Rp of 0.5 and
%   Rs of 20. 
%
%   Note: Validated against irf_filt(). Many thanks to Yuri Khotyaintsev!

if nargin < 4
    error('Insufficient number of input parameters!');
end

if nargin < 5; order = 5; name = 'butter'; end;
if nargin < 6; order = 5; end;


if strcmp(type, 'high') || strcmp(type, 'low')
    cutoff = freq;
elseif strcmp(type, 'pass')
    type = 'stop';
    if length(freq) == 2
        if (diff(freq) > 0) && ~all(isnan(freq))
            cutoff = freq;
        else
            error('eqn_filter: Values of ''freq'' must be increasing and non-NaN.');
        end
    else
        error(['A bandpass filter has been declared, but ''freq'' parameter',...
            'seems not to be a two-valued vector! Enter ''freq'' as a [minF',...
            ' maxF] pair, with frequency values in Hz.']);
    end
else
    error('Wrong or unsupported ''type'' parameter');
end

switch name
    case 'butter'
        [B, A] = butter(order, cutoff/((1/dt)/2), type);
    case 'ellip'
        if nargin < 7; 
            R = [0.5 20]; 
        elseif length(R) ~= 2 
            error(['An elliptical filter has been declared, but the ''R'' parameter',...
                ' seems not to be a two-valued vector! Enter ''R'' as a [Rp, Rs] ',...
                'vector with Rp decibels of peak-to-peak ripple and a minimum ',...
                'stopband attenuation of Rs decibels.']);
        end
        [B, A] = ellip(order, R(1), R(2), cutoff/((1/dt)/2), type);
    case 'cheby1'
        if nargin < 7; R = 0.5; end
        [B, A] = cheby1(order, R, cutoff/((1/dt)/2), type);
    case 'cheby2'
        if nargin < 7; R = 20; end
        [B, A] = cheby2(order, R, cutoff/((1/dt)/2), type);
    otherwise
        error('Wrong or unsupported ''filter_name'' parameter');
end

if ~isempty(X)
    s = size(X);
    if s(2) > 1 % TIME_SERIES matrix
        Y = zeros(s(1),s(2));
        for i=1:s(2)-1
            % find NaN and put to zero (in output set back to NaN)
            ind_NaN = find(isnan(X(:,i))); 
            X(ind_NaN,i) = 0;
            % filter
            Y(:,i) = filtfilt(B, A, X(:,i));
            % reset NaNs to NaN
            Y(ind_NaN,i) = NaN;
        end
        Y(:,end) = X(:,end); % copy time
    else
        Y = filtfilt(B, A, X); % simple column vector
    end
else
    Y = [];
end

end

%   Note that using (outside of the function) the commands 
%   H = freqz(B, A, freq_vec, sampling_freq); plot(freq_vec, abs(H));
%   will plot the frequency response of the filter for the frequencies
%   specified in freq_vec (all frequency values in Hz). 
