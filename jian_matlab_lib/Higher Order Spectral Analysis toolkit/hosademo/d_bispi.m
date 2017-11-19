%D_BISPI  HOSA Demo: Indirect estimate of the bispectrum (bispeci)
%       

echo off 
% A. Swami Oct 18, 1997.
% Copyright (c) 1991-2001 by United Signals & Systems, Inc. 
%       $Revision: 1.6 $

%     RESTRICTED RIGHTS LEGEND
% Use, duplication, or disclosure by the Government is subject to
% restrictions as set forth in subparagraph (c) (1) (ii) of the 
% Rights in Technical Data and Computer Software clause of DFARS
% 252.227-7013. 
% Manufacturer: United Signals & Systems, Inc., P.O. Box 2374, 
% Culver City, California 90231. 
%
%  This material may be reproduced by or for the U.S. Government pursuant 
%  to the copyright license under the clause at DFARS 252.227-7013. 

clear, clc, 

echo on 

%      BISPECI: bispectrum estimation using the indirect method
%
% Sample cumulants, C3(m,n), -M <= m,n <= M are estimated from the data.
% A lag-domain window, w(m,n), is applied, and then the FT is computed, i.e.,
%   bispectrum =  FT {   C3(m,n) w(m,n)  }
%
% The data for the demo is a synthetic for the quadratic-phase coupling (QPC)
% problem, and consist of four unity amplitude harmonics with frequencies
% 0.1 Hz, 0.15 Hz, 0.25 Hz and 0.40 Hz.  64 independent realizations, each 
% consisting of 64 samples, were generated using routine QPCGEN. The starting 
% phases for the harmonics with frequencies, 0.1 Hz, 0.15 Hz and 0.40 Hz were 
% chosen independently from an uniform distribution; the starting phase of the
% third harmonic, at 0.25 Hz, was set equal to the the sum of the starting 
% phases of the harmonics at 0.1 Hz and 0.15 Hz. White Gaussian noise with a
% variance of 1.5 was added to the signal.  Note that the harmonics at 
% (0.1, 0.15, 0.25) are both frequency- and phase-coupled; whereas those at 
% (0.15, 0.25, 0.40) are frequency-coupled, but not phase-coupled.  
%
% We will compute third-order cumulants C(m,n) for -21 <= m,n <= 21 and use 
% an FFT length of 128. The hexagonal window function will be used. 
%
% Hit any key to continue 
pause

load qpc
clf
[dbi,w] = bispeci (zmat, 21, 64, 0, 'unbiased', 128, 1); 
set (gcf, 'Name','HOSA - BISPECI')


% The contour plot shows a shark peak at (f1,f2) = (0.10,0.15);  the 
% other 11 peaks are due to the symmetry properties of the bispectrum.
% In general, we need to concentrate only on the region 0 <= f1 <= f2. 
% The sharpness of the contour peaks indicates the presence of quadratic 
% phase-coupling. 

% Hit any key to continue
pause
echo off 
clc
