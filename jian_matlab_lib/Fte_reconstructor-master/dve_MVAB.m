function [maxvv,intvv,minvv,qratio,lamda1,lamda2,lamda3]=MVAB(bc,ncase)
n=3;
bs=zeros(3,1);
for j=1:ncase
   bs(1)=bs(1)+bc(j,1)
   bs(2)=bs(2)+bc(j,2)
   bs(3)=bs(3)+bc(j,3)
end
disp('bx')
bs(1)=bs(1)/ncase%bx
disp('by')
bs(2)=bs(2)/ncase%by
disp('bz')
bs(3)=bs(3)/ncase%bz

a=zeros(3);
for j=1:ncase
   for i=1:n
      for k=1:n
         a(i,k)=a(i,k)+bc(j,i)*bc(j,k);
      end
   end
end

for i=1:n
   for k=1:n
      a(i,k)=(a(i,k)/ncase)-bs(i)*bs(k);
   end
end

X=zeros(3);
X=a;
[V,D]=eig(X);

evec1=V(:,1);
evec2=V(:,2);
evec3=V(:,3);

vn1=sqrt(evec1(1)*evec1(1)+evec1(2)*evec1(2)+evec1(3)*evec1(3));
vn2=sqrt(evec2(1)*evec2(1)+evec2(2)*evec2(2)+evec2(3)*evec2(3));
vn3=sqrt(evec3(1)*evec3(1)+evec3(2)*evec3(2)+evec3(3)*evec3(3));

evec1=evec1./vn1;
evec2=evec2./vn2;
evec3=evec3./vn3;
evector=[evec1';evec2';evec3'];

evalue1=D(1,1);
evalue2=D(2,2);
evalue3=D(3,3);
evalue=[evalue1 evalue2 evalue3];

imax=find(evalue==max(evalue));
imin=find(evalue==min(evalue));
iint=find(evalue~=max(evalue) & evalue~=min(evalue));

maxvv=evector(imax,:);
intvv=evector(iint,:);
minvv=evector(imin,:);

lamda1=evalue(imax);
lamda2=evalue(iint);
lamda3=evalue(imin);

lamda=[lamda1 lamda2 lamda3];
qratio=evalue(iint)/evalue(imin);


