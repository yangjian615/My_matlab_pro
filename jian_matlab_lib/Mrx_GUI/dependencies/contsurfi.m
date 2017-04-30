% contsurfi([ah],[[x],y],c,[range,[+max/norm/-fraction,[#levels]]])
% prepare for surfi and contourfi
% range >=< 0 => pos, total, or neg
% range ><  0 => scale max

function [ah,x,y,c,range,m,levels,argout]=contsurfi(varargin)
[ah,varargin,nargs] = axescheck(varargin{:});
if isempty(ah), ah=gca;end
try
    delete(getUserData(ah,'eztitle'))
end
x=[];y=[];c=[];
i=1;
while i<=nargs && getdim(varargin{i})>=1
    x=y;y=shiftdim(c);c=double(squeeze(full(varargin{i})));
    i=i+1;
end
if isempty(c),
    if isscalar(varargin{1})&&~ishandle(varargin{1})
        error('No valid input data! invalid handle?!');       
    else
        error('No valid input data!');
    end
end
N = find([cellfun(@isscalar,varargin),true],1);
switch N-1
    case 1
        x=1:size(c,2);
        y=1:size(c,1);
    case 2
        if length(y)==size(c,1);
            x=1:size(c,2);
        else
            x=y;
            y=1:size(c,1);
        end
    case 3
%         if ~all([length(y),length(x)]==size(c))
%             c = c';
%         end
end
range=0;
levels = 30;
m=-1;
c(c==Inf|c==-Inf)=NaN;
c(imag(c)~=0)=NaN;
if nargs>=i, range=varargin{i};i=i+1;
%     if range~=0, c(sign(range)*sign(c)<0)=0;end
 if nargs>=i, m=varargin{i};i=i+1;
  if m==0,
   if range==0
     c=c/max(abs(c(:)));m=1;
   else
     c=c/max(range*c(:));m=1;
   end
  end
  if nargs>=i, levels=varargin{i};i=i+1;
  end
 end
end
if m<0,
    if range==0
        m=-m*max(abs(c(:)));
    else
        m=-m*max(range*c(:));
    end
    if isnan(m),m=1;end
end
argout=varargin(i:end);
end