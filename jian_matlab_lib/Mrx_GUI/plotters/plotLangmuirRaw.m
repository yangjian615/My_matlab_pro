% unused script, cleanup needed

l    = load(c.highGfLangDataPath2); % langmuir probe data

figure(1)
clf
hold on

for i=1:4
    Te{i} = l.TeMean(l.probe==i);
    ne{i} = l.neMean(l.probe==i);
    pe{i} = ne{i}.*Te{i};
end

subplot(3,1,1)
for i=1:4
    plot(Te{i},'.-')
    hold on
    title('Te')
end
legend('1','2','3','4')

subplot(3,1,2)
for i=1:4
    plot(ne{i},'.-')
    hold on
    title('ne')
end
legend('1','2','3','4')

subplot(3,1,3)
for i=1:4
    hold on
    plot(pe{i},'.-')
    title('pe')
end
legend('1','2','3','4')