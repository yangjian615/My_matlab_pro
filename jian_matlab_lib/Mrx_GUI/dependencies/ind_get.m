function out=ind_get(v1,v2)
% out=ind_get(v1,v2) finds the indices of v1 which best corresponds to the
% valuse of v2

for i=1:length(v2)
    [~,out(i)]=min(abs(v1-v2(i))); % find nearest
    %out(i)=find(v1==v2(i)); % exact search
end