% Tsyganenko's GEOPACK Library
% Translated from original FORTRAN April 10-11, 2003
% By Paul O'Brien (original by N.A. Tsyganenko)
% Paul.OBrien@aero.org (Nikolai.Tsyganenko@gsfc.nasa.gov)
%
% Translation supported by NSF Grant ATM 0202107
%
% All subroutines in separate files as GEOPACK_*.m
%
% Updates:
%  April 18, 2003 - corrected index error in RECALC in extrapolation after year 2000
%  April 21, 2003 - reduced ERR tolerance in TRACE to 0.0001 per email from NAT
% c     ##########################################################################
% c     #                                                                        #
% c     #                             GEOPACK-2003                               #
% c     #                     (MAIN SET OF FORTRAN CODES)                        #
% c     #                                                                        #
% c     ##########################################################################
% C
% c
% c  This collection of subroutines is a result of several upgrades of the original package
% c  written by N. A. Tsyganenko in 1979. This version is dated April 9, 2003.
% c
% c
% c  This package represents an in-depth revision of the previous version, with significant
% c  changes in the format of calling statements. Users should familiarize themselves with
% c  the new formats and rules, and accordingly adjust their source codes, as specified
% c  below. Please consult the documentation file geopack-2003.doc for detailed descriptions
% c  of individual subroutines.
% c
% c  The following changes were made to the previous release of GEOPACK (Jan 5, 2001).
% c
% c (1) Subroutine IGRF, calculating the Earth's main field:
% 
% c   (a) Two versions of this subroutine are provided here. In the first one (IGRF_GSM)
% c     both input (position) and output (field components) are in the Geocentric Solar-
% c     Magnetospheric Cartesian coordinates, while the second one (IGRF_GEO) uses sphe-
% c     rical geographical (geocentric) coordinates, as in the older releases.
% 
% c   (b) updating of all expansion coefficients is now made separately in the s/r RECALC,
% c     which also takes into account the secular change of the coefficients within
% c     a given year (at the Earth's surface, the rate of the change can reach 7 nT/month).
% 
% c   (c) the optimal length of spherical harmonic expansions is now automatically set
% c     inside the code, based on the radial distance, so that the deviation from the
% c     full-length approximation does not exceed 0.01 nT. (In the previous versions,
% c     the upper limit NM of the order of harmonics had to be specified by users),
% c
% c  (2) Subroutine DIP, calculating the Earth's field in the dipole approximation:
% 
% c   (a) no longer accepts the tilt angle via the list of formal parameters. Instead,
% c     the sine SPS and cosine CPS of that angle are now forwarded into DIP via the
% c     first common block /GEOPACK1/.  Accordingly, there are two options: (i) to
% c     calculate SPS and CPS by calling RECALC before calling DIP, or (ii) to specify
% c     them explicitly. In the last case, SPS and CPS should be specified AFTER the
% c     invocation of RECALC (otherwise they would be overridden by those returned by
% c     RECALC).
% 
% c   (b) the Earth's dipole moment is now calculated by RECALC, based on the table of
% c     the IGRF coefficients and their secular variation rates, for a given year and
% c     the day of the year, and the obtained value of the moment is forwarded into DIP
% c     via the second common block /GEOPACK2/. (In the previous versions, only a single
% c     fixed value was provided for the geodipole moment, corresponding to the most
% c     recent epoch).
% c
% c  (3) Subroutine RECALC now consolidates in one module all calculations needed to
% c     initialize and update the values of coefficients and quantities that vary in
% c     time, either due to secular changes of the main geomagnetic field or as a result
% c     of Earth's diurnal rotation and orbital motion around Sun. That allowed us to
% c     simplify the codes and make them more compiler-independent.
% c
% c  (4) Subroutine GEOMAG is now identical in its structure to other coordinate trans-
% c     formation subroutines. It no longer invokes RECALC from within GEOMAG, but uses
% c     precalculated values of the rotation matrix elements, obtained by a separate
% c     external invocation of RECALC. This eliminates possible interference of the
% c     two subroutines in the old version of the package.
% c
% c  (5) Subroutine TRACE (and the subsidiary modules STEP and RHAND):
% c
% c   (a) no longer needs to specify the highest order of spherical harmonics in the
% c     main geomagnetic field expansion - it is now calculated automatically inside the
% c     IGRF_GSM (or IGRF_GEO) subroutine.
% c
% c   (b) the internal field model can now be explicitly chosen by specifying the para-
% c      meter INNAME (either IGRF_GSM or DIP).
% c
% c  (6) A new subroutine BCARSP was added, providing a conversion of Cartesian field
% c     components into spherical ones (operation, inverse to that performed by the sub-
% c     routine  BSPCAR).
% c
% c  (7) Two new subroutines were added, SHUETAL_MGNP and T96_MGNP, providing the position
% c     of the magnetopause, according to the model of Shue et al. [1998] and the one
% c     used in the T96 magnetospheric magnetic field model.
% c
% c
% C
% C ############################################################################
% C #    EXAMPLE1 and EXAMPLE2 GIVE EXAMPLES OF TRACING FIELD LINES      #
% C #      USING THE GEOPACK SOFTWARE  (release of April 9, 2003)              #
%          GEOPACK_test tests coordinate transforms
% C ############################################################################
% C
%function [XF,YF,ZF,XX,YY,ZZ,M] = GEOPACK;
%GEOPACK_test;
%[XF,YF,ZF,XX,YY,ZZ,M] = GEOPACK_EXAMPLE1;
%[XF,YF,ZF,XX,YY,ZZ,M] = GEOPACK_EXAMPLE2;

