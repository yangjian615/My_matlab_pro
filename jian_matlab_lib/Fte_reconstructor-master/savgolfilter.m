function [yc]=savgolfilter(delx,yy,xn,np,dn)
%dn=0, for smoothing
%dn=1, for first derivative
%dn=2, for second derivative

x=-xn:xn; %data points for smoothing
hs=[];

for x0=-xn:xn
    h=savgolrev(x,np,dn,x0);
    hs=[hs h'];
end

npt=length(yy);
yc=zeros(1,npt);

for i=1:xn
   yc(i)=hs(:,1)'*[yy(i:i+2*xn)]';
end

for i=npt-xn:npt
   yc(i)=hs(:,2*xn+1)'*[yy(i-2*xn:i)]';
end

for i=xn+1:npt-xn-1
   yc(i)=hs(:,xn+1)'*[yy(i-xn:i+xn)]';
end

if dn>0
   yc=yc./delx^dn;
end
