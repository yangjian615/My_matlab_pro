function [F_2d] = hia_sum_over_pol(F_3d,varargin)
%Jian.HIA_SUM_OVER_POL Sums a 4D ion HIA matrix over the polar angle.
%
%   ionMat = Jian.HIA_SUM_OVER_POL(ion4d) Given F_3d of size 8x16Nx31,
%   sums over polar angle with factor cos(th). Returns 2d matrix ionMat
%   with size Nx16x31.
%   
%   Also works with reduced energy resolution.
%
%   See also:   Jian.GET_HIA_DATA
%

pm1 = {'full','sw'};
thMode = Jian.incheck(varargin,pm1);

tn = size(F_3d,2); % Number of time steps
en = size(F_3d,3); % Number of energy bins

switch thMode
    case pm1{1} % full
        thRange = 1:8;
    case pm1{2} % sw
        thRange = 4:5;
end

F_2d = zeros(tn,en);
th = Jian.get_hia_values('theta')'; % Equatorial angle

for i = thRange
    for j = 1:tn
        for k = 1:en
            fval = F_3d(i,j,k)*cosd(th(i));
            F_2d(j,k) = F_2d(j,k)+fval;
        end
    end
end