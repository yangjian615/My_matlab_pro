function Xmfa = eqn_mfa(X, meanX, R)
%eqn_mfa Transforms X to a mean-field coordinate system.
%
%   Xmfa = eqn_mfa(X, meanX, R), transforms the vectors in 'X' to their
%   mean field alligned coordinate system, according to the mean field
%   specified in 'meanX' and positional vectors specified in 'R'. In all
%   cases, variables are Nx3 matrices, with each time instant
%   corresponding to the same row (of 3 elements) of the input and output 
%   matrices. 'R' is the positional vector (same format). 
%   All input matrices must be given in the same coordinate system.
%   'Xmfa' will be a Nx3 matrix, with the MFA values of 'X'. The three 
%   columns correspond to the 'poloidal', 'toroidal' and 'compressional'
%   components respectively.
%
%   About MFA: The MFA system is an orthogonal coordinate system. Its third
%   component (compressional) is defined by the direction of the mean
%   field. Its second component (azimuthal) is being derived by the cross 
%   product of the compressional component with the positional vector R.
%   Lastly, the first component (poloidal) of the MFA system is computed
%   by the direction of the cross product of the second and third unitary 
%   vectors.
%
%   Note: Tested against irf_convert_fac() for validation. Many thanks to
%   Yuri Khotyaintsev!

L = size(X,1);
if nargin < 3 % no R input => set position to [1,0,0]
    R = [ones(L,1), zeros(L,2)];
end

% Xmfa_unitary = N_of_measurements x 3 coordinates x 3 unitary vectors 
% Each unitary vector of MFA has a different 3D representation in
% the original coordinate system (pol, tor, compr). Since all calculations
% are performed in the original system, we must have the three unitary
% vectors of the MFA in that system as well.
Xmfa_unitary = zeros(L,3,3); 

% Initialize final Xmfa column matrix
Xmfa = zeros(L,3);

Xmfa_unitary(:,:,3) = bsxfun(@rdivide, meanX, sqrt(meanX(:,1).^2+meanX(:,2).^2+meanX(:,3).^2));

Xmfa(:,3) = dot(X, Xmfa_unitary(:,:,3), 2);

Xazim = cross(Xmfa_unitary(:,:,3), R, 2);
Xmfa_unitary(:,:,2) = bsxfun(@rdivide, Xazim, sqrt(Xazim(:,1).^2+Xazim(:,2).^2+Xazim(:,3).^2));

Xmfa(:,2) = dot(X, Xmfa_unitary(:,:,2), 2);

Xpol = cross(Xmfa_unitary(:,:,2), Xmfa_unitary(:,:,3), 2);
Xmfa_unitary(:,:,1) = bsxfun(@rdivide, Xpol, sqrt(Xpol(:,1).^2+Xpol(:,2).^2+Xpol(:,3).^2));

Xmfa(:,1) = dot(X, Xmfa_unitary(:,:,1), 2);



end

