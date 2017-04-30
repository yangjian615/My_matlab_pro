function [xIntersect,yIntersect] = intersect_line_data(k,m,xData,yData)
%Jian.INTERSECT_LINE_DATA Finds intersection between a line and data points
%   [x,y] = Jian.INTERSECT_LINE_DATA(k,x,xData,yData) returns intersect
%   point between data and a line y = k*x+m.


len = length(xData);
lX = xData;
lY = k*lX+m;

yFlat = yData-lY;

interInd = find(yFlat(1:end-1).*yFlat(2:end)<=0,1);

%xIntersect = lX(interInd);


%refined
if(interInd == len)
    kA = diff(yData(interInd-1:interInd))/diff(xData(interInd-1:interInd));
    mA = yData(interInd)-kA*xData(interInd);
elseif(interInd == 1)
    kA = diff(yData(interInd:interInd+1))/diff(xData(interInd:interInd+1));
    mA = yData(interInd)-kA*xData(interInd);
else
    kA = diff(yData(interInd:interInd+1))/diff(xData(interInd:interInd+1));
    mA = yData(interInd)-kA*xData(interInd);
end


xIntersect = (m-mA)/(kA-k);
yIntersect = k*xIntersect+m;
end