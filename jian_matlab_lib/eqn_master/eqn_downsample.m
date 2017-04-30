function [new_t, new_x] = eqn_downsample(t, x, old_Dt, new_Dt)
%eqn_downSample Changes the sampling rate of a series to a lower one.
%
%   [newT, newX] = eqn_downSample(t, x, old_Dt, new_Dt), creates new time
%   series based on values 'x' in times 't' separated by a constant time
%   difference 'old_Dt', according to a new sampling time equal to
%   'new_Dt'. If more than one values of the old series correspond to one
%   point in the new, then the function will take the average of the old
%   values. 'x' is a column of values or a matrix of more than one columns 
%   (for more than one variables) with each row corresponding to a single
%   point in time, specified by the corresponding row of 't'. 
%
%   The old series must have a constant time difference equal to 'old_Dt'
%   throughout the entire data. If there are missing values, they should
%   have been set to NaNs (use eqn_setCadence() for this).
%
%   The values in the i-th position of 'new_x' will correspond to to the 
%   average of the values in the original 'x', for times between new_t(i)
%   and new_t(i) + new_Dt, so that the values of the 'new_t' array
%   correspond to the begining of each time interval of length 'new_Dt'.
%

L = length(t);
if size(x,1)~= L;
    error('x and t vectors are of unequal lengths!');
end

nCols = size(x,2);

ratio = new_Dt/old_Dt;
if ratio < 1
    error(['New sampling time is smaller than the original! Correct this,'...
        'or use an upsampling method instead (i.e. some interpolation '...
        'routine).']);
end

low = fix(ratio);
high = ceil(ratio);

% The Method: Say there is time series of times: t = [1,2,3,...] and values
% x = [x1, x2, x3, ...]. The initial sampling time is old_Dt = diff(t) = 1,
% constant throughout. Suppose a new sampling time old_Dt' = 2.3 is needed. The
% new times then will be t' = [1, 3.3, 5.6, 7.9, 10.2, ...] and for the new
% x' one must take values between these times and aggregate them i.e.
% taking their mean value. So the new x' will be given by:
% x' = [ <x1,x2,x3>, <x4,x5>, <x6,x7>, <x8,x9,x10>, ...], to correspond to 
% the time above with <> denoting averaging. This is like taking two moving
% averages, one of width 3 points and on of 2 and then selecting the 
% appropriate values to pass to the final array. This is what takes place 
% below. For this example there are 3 N_fields, with field_width = [3, 2, 
% 2], meaning that the averaging takes place for 3 old points for the first
% new point, 2 for the next and 2 for the next of that and then the cycle 
% repeats (again 3,2,2 and again 3,2,2 and so on). 3 is denoted as the High
% rate and 2 the Low. If they are the same, a simple moving average is
% performed. Else, both moving averages are calculated and the correct
% indexes selected for the final result.

if low ~= high
    N_fields = fix(1/(ratio-low-0.000001));
    field_width = low*ones(N_fields,1); field_width(1) = high;
    offset = filter(1,[1,-1],field_width);
    width = offset(end);
    
    % residue calculates if there are any values left at the end to be
    % aggregated to the last point in the new series
    new_residue = mod(L,width);
    new_L = fix(L/width)*N_fields;
    if new_residue > 0
        new_L = new_L + 1;
        if new_residue <= high
            new_residue = mod(new_residue,high);
        else
            new_L = new_L + fix((new_residue-high)/low);
            new_residue = mod(new_residue-high,low);
        end
    end
    residue = 1;
    % 'new_residue' concerns the new series so it is either one or zero.
    % There either are 'residue' points in the old series to aggregate to a
    % single new one, or not.
    if new_residue == 0; 
        residue = 0; 
    else
        new_L = new_L + 1;
    end;
    new_x = nan(new_L, nCols);
    
    for i=1:nCols
        % High (first Field)
        m = 1;
        f = filter(ones(field_width(m),1), 1, x(:,i));
        new_x(m:N_fields:new_L-residue,i) = f(offset(m):width:L) / field_width(m);

        % Low (the rest Fields)
        f = filter(ones(field_width(2),1), 1, x(:,i));
        for m=2:N_fields
            new_x(m:N_fields:new_L-residue,i) = f(offset(m):width:L) / field_width(m);
        end

        % the last point 
        if new_residue > 0
            new_x(end,i) = mean(x(L-new_residue+1:L,i));
        end
    end
else
    % Low == High, so just do it in one pass
    
    % residue calculates if there are any values left at the end to be
    % aggregated to the last point in the new series
    residue = mod(L,low);
    % 'new_residue' concerns the new series so it is either one or zero.
    % There either are 'residue' points in the old series to aggregate to a
    % new one, or not.
    new_residue = 1; if residue == 0; new_residue = 0; end;
    new_L = ceil(L/low);
    new_x = nan(new_L, nCols);
    for i=1:nCols
        f = filter(ones(low,1),1,x(:,i));
    
        new_x(1:1:new_L-new_residue,i)= f(low:low:end) / low;
        if residue ~= 0
            new_x(end,i) = mean(x(L-residue+1:L,i));
        end
    end
end

new_t = (t(1):new_Dt:t(1)+new_Dt*(new_L-1))';

end