function [A,Ady,Adx]=gsdn(c1,x,y,u,udy,udx,fpbz1)

nx=c1(1); ny=c1(2); mid=c1(3); hx=c1(4); hy=c1(5); psmax=c1(6); psmin=c1(7);

nl=1; nr=nx;

dpbz1=polyder(fpbz1); %dPt/dA

i1=1;
i2=nx;

for j=mid:-1:2   
   
   for i=nl:nr             
      
      dpt(i)=polyval(dpbz1,u(j,i));
      if u(j,i)<psmin
         dpt(i)=polyval(dpbz1,psmin);
      elseif u(j,i)>psmax
         dpt(i)=polyval(dpbz1,psmax);
      end  
      
      rhs(i)=-dpt(i);
      
   end
   
   %calculate d2A/dx2
   duxx=savgolfilter(hx,u(j,:),2,3,2);         
   
   d2u=rhs-duxx;   
   
   %advance Bx 
   udy(j-1,:)=udy(j,:)+d2u.*(y(j-1)-y(j));
   %advanace A
   u(j-1,:)=u(j,:)+udy(j,:).*(y(j-1)-y(j))+d2u.*(y(j-1)-y(j))^2;            
   
   
   wfac=2.; %adjustable weighting factor   
   
   %apply weighting function on vector pot. A
   u(j-1,i1:i2)=weightFunc1(nr,nl,j-1,ny,mid,y,u(j-1,:),wfac,i1,i2,-1);
      
   %smoothing Bx
   udy(j-1,:)=savgolfilter(hx,udy(j-1,:),2,4,0);
   
   %advance By
   udx(j-1,:)=savgolfilter(hx,-u(j-1,:),2,3,1);
   
end

A=u;
Adx=udx;
Ady=udy;
