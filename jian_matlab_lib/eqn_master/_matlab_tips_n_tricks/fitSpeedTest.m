N = 100;
L = 100;
t = (1:L)';

tic
for i=1:N
    x = rand(L,1);
    P = polyfit(t,x,1);
    trend = t*P(1) + P(2);
end
toc


tic
for i=1:N
    x = rand(L,1);
    f = fit(t,x,'poly1');
    trend = t*f.p1 + f.p2;
end
toc