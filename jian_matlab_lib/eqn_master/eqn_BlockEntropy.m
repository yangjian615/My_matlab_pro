function varargout = eqn_BlockEntropy(X, GLIDING, N_max)
%eqn_BlockEntropy Computes the Block Entropy of a symbolic series
%
%   H = eqn_BlockEntropy(X, GLIDING), calculates the Block Entropies H of a
%   symbolic series X (integer values from 0 to some maximum), using the
%   gliding technique if 'GLIDING' is set to true or the lumping technique
%   if 'GLIDING' is set to false. H will be computed for as many block
%   lengths as is statistically plausible, approx. N_max = log(L/10) taking 
%   the base-'alpha' logarithm, with 'alpha' the alphabet size of the 
%   symbolic series).
%
%   H = eqn_BlockEntropy(X, GLIDING, N_max), as above but for a preset
%   maximum block length equal to N_max. 
%
%   [H, alpha] = eqn_BlockEntropy( ... ), as above, but also outputs the
%   alphabet size 'alpha', namely the number of different symbols used in
%   the input series. 
%
%   Note: The way the code is written, it is not faster to perform Lumping
%   instead of Gliding, so make your choice only based on physical grounds
%   and not on computational speed issues.


if nargout > 3 || nargin > 3
    error('eqn_BlockEntropy: ERROR: Wrong number of I/O parameters');
end

minimum = min(X); 
if minimum < 0
    error('eqn_BlockEntropy: ERROR: Negative values in input series!');
end

s = sum(abs(mod(X,1)));
if s > 0
    error('eqn_BlockEntropy: ERROR: Input Series are not composed of integers. Probably non-symbolic input.');
end

maximum = max(X);
ALPHABET_SIZE = maximum + 1;

if nargin < 3
    MAX_BLOCK_LENGTH = round(eqn_logarithm(length(X)/10, ALPHABET_SIZE));
    if GLIDING == false
        % use different criterion for lumping, one that solves:
        % x = log_a( (L/x)/10) => x + log_a(x) = log_a(L/10) =>
        % x = W( (L/10) * ln(a) ) / ln(a), W() being the  Lambert W function
        MAX_BLOCK_LENGTH = round(lambertw((length(X)/10) * log(ALPHABET_SIZE)) / log(ALPHABET_SIZE));
    end
    if MAX_BLOCK_LENGTH < 1; MAX_BLOCK_LENGTH = 1; end;
else
    MAX_BLOCK_LENGTH = N_max;
end

H = zeros(MAX_BLOCK_LENGTH, 1);

if nargin == 3;
    rank = cell(MAX_BLOCK_LENGTH,1);
end

% calculate H(1) outside the next loop to make it faster
% 'vals' holds all possible values 
% histc() is used instead of hist(), because it proved to be faster, even
% though in this context hist() would be a more natural choice
vals = (0:1:ALPHABET_SIZE)'; 
cnt = histc(X, vals); 
H(1) = eqn_ShannonEntropyOfCounts(cnt);

if nargin == 3;
    s = cnt(cnt>0);
    rank{1} = sort(s, 1, 'descend');
end

for BLOCK_LENGTH = 2:MAX_BLOCK_LENGTH
    % the combination of 'key' and filter() transforms the symbolic blocks
    % to their numeric representation in a base-a system, with 'a' being
    % the ALPHABET_SIZE (i.e. binary for base-2 etc)
    vals = (0:1:ALPHABET_SIZE^BLOCK_LENGTH)';
    key = ALPHABET_SIZE.^(0:BLOCK_LENGTH - 1)';
    x_glid = filter(key, 1, X);
    x_glid = x_glid(BLOCK_LENGTH:end);
    
    if GLIDING == false
        % use only the parts that correspond to lumping
        x_glid = x_glid(1:BLOCK_LENGTH:end);
    end
    
    cnt = histc(x_glid, vals);
    H(BLOCK_LENGTH) = eqn_ShannonEntropyOfCounts(cnt);
    
    if nargin == 3;
        s = cnt(cnt>0);
        rank{BLOCK_LENGTH} = sort(s, 1, 'descend');
    end
end

if nargout >= 1
    varargout{1} = H;
else
    H %#ok<NOPRT>
end
if nargout == 2
    varargout{2} = ALPHABET_SIZE;
end
if nargout == 3
    varargout{3} = rank;
end

end

