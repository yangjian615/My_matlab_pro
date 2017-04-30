function hour_cel = hour_fix(hour_str)

%     hour_str = '12:54:00';

    N = length(hour_str);
    hour_num = zeros(6,1);
    hour_pz = {'0';'0';'0';'0';'0';'0'};
    k=1;
    
    for i=1:N
        h_digit = sscanf(hour_str(i),'%d');
        if ~isempty(h_digit)
            hour_num(k)=h_digit;
            hour_pz{k} = num2str(h_digit);
            k=k+1;
        end
    end
    if (10*hour_num(1)+hour_num(2)) > 23
        hour_pz{1} = '2';
        hour_pz{2} = '3';
    end
    if (10*hour_num(3)+hour_num(4)) > 59
        hour_pz{3} = '5';
        hour_pz{4} = '9';
    end
    if (10*hour_num(5)+hour_num(6)) > 59
        hour_pz{5} = '5';
        hour_pz{6} = '9';
    end 
     hour_cel = [hour_pz{1},hour_pz{2},':',hour_pz{3},hour_pz{4},':',hour_pz{5},hour_pz{6}];
end
