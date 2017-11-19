function choices(Title1,Title2,Menu,Callback,Unknown)
% ZhouQianwei's choices function for HOSA toolbox usage
% SIMIT
% 2012-4-8

Unknown = Unknown;
Title = [Title1,':',Title2];
[x,y] = size(Menu);
MENU = [];
for i = 1:x
    buffer = Menu(i,:);
    index = max(strfind(buffer,' '));
    if isempty(index) ~= 1
        buffer = buffer(1:index-1);
    end
    MENU = [MENU,{buffer}];
end
[x,y] = size(Callback);
CALLBACK = [];
for i = 1:x
    buffer = Callback(i,:);
    index = min(strfind(buffer,' '));
    if isempty(index) ~= 1
        buffer = buffer(1:index-1);
    end
    CALLBACK = [CALLBACK,{buffer}];
end
    
Cho = menu(Title,MENU);

fh = str2func(CALLBACK{Cho});
fh();


end