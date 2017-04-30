clc
clear
%%
Bz=0;
Dp=2.5;
%%
if Bz>=0
    r0=(11.4+0.013*Bz)*(Dp)^(1/-6.6);
else
    r0=(11.4+0.14*Bz)*(Dp)^(1/-6.6);
end
a=(0.58-0.01*Bz)*(1+0.01)*Dp;

theta=0:pi/2000:pi*3/5;
for i=1:size(theta,2)
    r(i)=r0*(2/(1+cos(theta(i))))^a;
    x(i)=r(i)*cos(theta(i));
    z1(i)=r(i)*sin(theta(i)); 
    z2(i)=-r(i)*sin(theta(i));
end
plot(x,z1,'k')
hold on
plot(x,z2,'k')
%
alpha=pi/2:pi/20:3/2*pi;    %½Ç¶È[pi,2*pi] 
R  =  1;                   %°ë¾¶ 
x  =  R*cos(alpha); 
y  =  R*sin(alpha); 
plot(x,y,'k-') 
fill(x,y,'k');
alpha  =  0:pi/20:2*pi;    %½Ç¶È[0,pi] 
x  =  R*cos(alpha); 
y  =  R*sin(alpha);
plot(x,y,'k-') 
