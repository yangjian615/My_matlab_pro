function [wr]=weightFunc1(nr,nl,j,ny,mid,y,qq,ff,i1,i2,updn)


for i=nl:nr
   if updn==1      
      yfactor=ff*((y(j)-y(mid)))/((y(ny)-y(mid)));
   end   

   if updn==-1
      yfactor=ff*((y(j)-y(mid)))/((y(1)-y(mid)));
   end
   
   k1=0.5*(yfactor/3);
   k2=1-(yfactor/3);
   k3=0.5*(yfactor/3);
   
   if(i==1)
      w(1,1)=k1*qq(2)+k2*qq(1)+k3*qq(2);
   end
   if(i==nr)
      w(1,nr)=k1*qq(nr-1)+k2*qq(nr)+k3*qq(nr-1);
   end
   if((i>nl)&(i<nr))
      w(1,i)=k1*qq(i+1)+k2*qq(i)+k3*qq(i-1);
   end      
end

wr=w(i1:i2);