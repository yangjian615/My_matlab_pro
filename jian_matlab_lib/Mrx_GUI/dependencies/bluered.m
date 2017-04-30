function cout=bluered(len,lims)
if nargin < 1
   len = size(get(gcf, 'Colormap'), 1);
end
if isscalar(len)
    lims = [1 len];
    len  = 1:len;
else
    if nargin < 2
        lims = [min(len(:)),max(len(:))];
    else
        len = max(lims(1),min(lims(2),len));
    end
end
% map data onto -1:1
% .9375 = 15/16 --- to ensure min ~= max
x = ((len(:)-lims(1))/diff(lims)*2-1)*.9375;

% transformation rgb2gray
% T = inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]);
% coef = T(1,:);
coef =  [281/940 , 1622/2763 , 283/2482];


B = 1-max(0,x)-max(0,-x).^3;
R = flipud(B);
G = min(1,max(0,(1-abs(x)-R*coef(1)-B*coef(3))./coef(2)));
c = [R,G,B];
if nargout>0
    cout=c;
else
    colormap(c)
end
end