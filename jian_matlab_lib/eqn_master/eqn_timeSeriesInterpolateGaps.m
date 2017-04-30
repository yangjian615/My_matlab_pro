function [it, idata] = eqn_timeSeriesInterpolateGaps(t, data, SAMPLING_TIME)
%timeSeriesInterpolateGaps Interpolates missing values in time series.
%
%   [it, idata] = eqn_timeSeriesInterpolateGaps(t, data, SAMPLING_TIME)
%   Linearly interpolates missing data values. Time corresponding to each
%   datum is given in column 't' (preferable in matlabd format, but simple
%   integers will work as well) and the data are stored in matrix 'data',
%   with each column being a time series (i.e. the xyz components of some
%   variable measured at times 't'). 'SAMPLING_TIME' is a single number 
%   denoting the time between consecutive data points (in the same units or
%   format as in 't'), namely, if there were no gaps then diff(t) should 
%   take the value 'SAMPLING_TIME' for all points. The outputs are the
%   interpolated time column 'it' and interpolated data matrix 'idata'.
%   
%   [it, idata] = eqn_timeSeriesInterpolateGaps(t, data), as above, but if
%   'SAMPLING_TIME' is not given, it will be set as the most common value 
%   in diff(t).
%
%   (a gap in the data is considered where diff(t) > 2 * SAMPLING_TIME)


if nargin<3
    SAMPLING_TIME = mode(diff(t));
end

f = find(diff(t) > SAMPLING_TIME*2);

if ~isempty(f)
    s = size(data);
    L = length(f);

    % find how many additional points will be interpolated for each segment
    addPoints = zeros(L,1);
    for i=1:length(f)
            addPoints(i) = fix((t(f(i)+1) - t(f(i))) / SAMPLING_TIME) - 1;
    end

    % allocate new vars
    iL = L + sum(addPoints);
    it = zeros(iL,1);
    idata = zeros(iL,s(2));

    % initial points (correct)
    it(1:f(1)) = t(1:f(1));
    idata(1:f(1),:) = data(1:f(1),:);
    ii = f(1)+1;

    for i=1:length(f)
        int_t = linspace(t(f(i)),t(f(i)+1),addPoints(i)+2);
        int_t = int_t(2:end-1); % first point is already in the series
        if ~isempty(int_t)
            it(ii:ii+addPoints(i)-1) = int_t;
            for j=1:s(2)
                int_x = linspace(data(f(i),j),data(f(i)+1,j),addPoints(i)+2);
                int_x = int_x(2:end-1);
                idata(ii:ii+addPoints(i)-1,j) = int_x;
            end
            ii = ii + addPoints(i);
        end

        if i<length(f)
            for k=f(i)+1:f(i+1)
                it(ii) = t(k);
                idata(ii,:) = data(k,:);
                ii = ii+1;
            end
        else
            for k=f(i)+1:length(t)
                it(ii) = t(k);
                idata(ii,:) = data(k,:);
                ii = ii+1;
            end
        end
    end
else
    it = t;
    idata = data;
end
end