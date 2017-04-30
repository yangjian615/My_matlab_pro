function entr = eqn_ShannonEntropyOfCounts( cnt )
%ShannonEntropyOfCounts Computes the Shannon Entropy of a list of counts
%
%   H = eqn_ShannonEntropyOfCounts( cnt ), where 'cnt' is a list with the 
%   occurence counts for some events and H is the computed Shannon Entropy
%   value, according to the equation H = - Sum[ pi * ln(pi) ]. Elements of
%   'cnt' can be zeros. 

% ----------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <constantinos@noa.gr> wrote this file.  As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return.   Constantinos
% Papadimitriou
% ----------------------------------------------------------------------------

p = cnt(cnt>0);
p = p / sum(p);
entr = -sum(p .* log(p));

end

