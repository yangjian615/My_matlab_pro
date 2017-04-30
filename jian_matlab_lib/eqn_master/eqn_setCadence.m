function [it, ix] = eqn_setCadence(t, x, SAMPLING_TIME, tlims)
%eqn_setCadence Sets values of a series to constant cadence (so that they
%correspond to time instants of constant difference) and places NaNs to
%data gaps (times with no values).
%
%   [it, ix] = eqn_setCadence(t, x, dt), reads values in column matrix 'x' 
%   that correspond to time instants 't'. The time values can be in any
%   order, but they must alwasy pair with their corresponding 'x' values.
%   The function creates series 'it', spanning times from the min to the
%   max of 't', with a constant time difference of 'dt' throught the series
%   and their corresponding 'ix' values. 
%   If for a particular point in time there are no data in 'x', then the 
%   corresponding value of 'ix' will be set to NaN. 
%   If for a particular point in time there are multiple data points in 'x'
%   the function will only aknowledge the first one and discard the rest 
%   To take the mean() of concurrent values use a downsampling function 
%   instead, such as eqn_downsample(). 
%
%   [it, ix] = eqn_setCadence(t, x, dt, tlims), same as above, but for a
%   particular interval in time, specified by 'tlims', which must be a
%   2-element vector with the initial and final times of this interval.
% 
%   Since missing points in the data are replaced with NaN values, it might
%   be usefull to run "eqn_interpolateNaN()" after every call to
%   eqn_setCadence().
% 

if length(t) ~= length(x)
    error('setCadence: Vectors have unequal lengths!');
end

if nargin<4
    tlims = [min(t), max(t)];
elseif sum(size(tlims)) ~= 3
    error('Wrong ''tlims'' parameter! Must be a 2-element vector.');
end

if nargin<3
    error('setCadence: More input arguments needed! Must provide at least t, x and dt');
end

% sort values 
[sorted_t, sort_ind] = sort(t,1,'ascend');
t = sorted_t;
x = x(sort_ind,:);

% clear duplicate times
d = diff(t);
d = find(d == 0);
if ~isempty(d)
    disp(['eqn_setCadence: WARNING: Duplicate Timestamps detected & Removed! (',num2str(length(d)),')']); disp(' ');
    t(d) = [];
    x(d,:) = [];
end

[L, nCols] = size(x);

% SET CADENCE
it = (tlims(1):SAMPLING_TIME:tlims(end))';
iL = length(it);
ix = NaN(iL, nCols);

% it(1) will always be tlims(1), BUT it(end) might be smaller than
% tlims(end), if the tlims range is not exactly divisable by the
% SAMPLING_TIME! So when setting the indLims below, take as upper limit the
% tlims(end) and not the it(end), to make sure you have covered all points!
% This bug resulted in many series ending in NaNs!!!
indLims = [find(t >= it(1), 1, 'first'), find(t <= tlims(end), 1, 'last')];
if ~isempty(indLims) && size(indLims,2) == 2
    t = t(indLims(1):indLims(2));
    x = x(indLims(1):indLims(2),:);

% A small time_offset is used to facilitate comparison, as it was found
% that some times two consecutive points ie 00:10 & 00:20 can be attributed
% to the first and third (instead of first and second) consecutive indices,
% due to rounding errors.
    time_offset = SAMPLING_TIME*0.001;
    timeIndices = fix((t - it(1) + time_offset)/SAMPLING_TIME) + 1;
    ix(timeIndices,:) = x((1:end),:);
end
end