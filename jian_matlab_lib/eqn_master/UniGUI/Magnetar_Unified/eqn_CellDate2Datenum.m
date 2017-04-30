function dateRange = eqn_CellDate2Datenum(DateCell)
%eqn_CellDate2Datenum Converts cell of strings to datenum
%
%   Converts the cell of strings that emerges from SwarmGUI to a vector of
%   two datenum values (begining date and end date).
%

DateMat = [DateCell{1,1}, DateCell{2,1}, DateCell{3,1}, ...
    DateCell{4,1}(1:2), DateCell{4,1}(4:5), DateCell{4,1}(7:8); ...
    DateCell{1,2}, DateCell{2,2}, DateCell{3,2}, ...
    DateCell{4,2}(1:2), DateCell{4,2}(4:5), DateCell{4,2}(7:8)];

    
dateRange = datenum(DateMat, 'yyyymmddHHMMSS')';

end

