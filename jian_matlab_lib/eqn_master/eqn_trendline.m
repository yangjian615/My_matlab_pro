 function Y = eqn_trendline(X, order)
%eqn_trendline Fits a simple polynomial on the time series to capture
%the trend in the data
%
%   Y = eqn_trendline(X)
%   Fits a least squares line on the data and outputs the value of this
%   line corresponding to each data point in the input series. X is a
%   column-vector of the values of the series or a TIME_SERIES_FORMAT 
%   column matrix, in which case the output will also be in a
%   TIME_SERIES_FORMAT.
%   
%   Y = eqn_trendline(X, order), as above, but for a polynomial of maximum
%   order equal to the 'order' parameter.
%
%   Note: If there are NaN values in the data, the fitting will ignore
%   them, but the output trendline will be given for all points in the data
%   including NaNs. 

s = size(X);
if s(2) == 1
    t = (1:s(1))';
    Y = zeros(s(1),1);
else
    t = X(:,end);
    Y = zeros(s(1),s(2));
    Y(:,end) = t;
end

if nargin<2
    order = 1;
end

for i = 1:s(2)
    % ignore NaNs - Fit according to X(notNAN) but give the output for all
    % times specified in 't' (inlc. NaNs)
    fnan = find(isnan(X(:,i))>0);
    if ~isempty(fnan)
        fNOTnan = setdiff( (1:s(1))', fnan);
        iX = X(fNOTnan, i);
        it = t(fNOTnan);
    else
        iX = X(:,i);
        it = t;
    end
    
    
    if order > 1
        P = polyfit(it, iX, order);
        f = P(end-1)*t + P(end);
        for polyIndex = 1:order-1
            f = f + P(polyIndex)*t.^(order + 1 - polyIndex);
        end
    elseif order == 1
        % faster linear fit accodring to Wolfram's
        % http://mathworld.wolfram.com/LeastSquaresFitting.html
        N = length(iX);
        Mx = mean(it);
        My = mean(iX);
        SSxx = sum(it.^2) - N*Mx^2;
        SSxy = sum(it.*iX) - N*Mx*My;

        b = SSxy/SSxx;
        a = My - b*Mx;
        f = b*t + a;
    end
    
    Y(:,i) = f;
end

%plot(t,X(:,1),'x',t,Y(:,1),'-r');
%xlim([t(1) t(end)]);

end