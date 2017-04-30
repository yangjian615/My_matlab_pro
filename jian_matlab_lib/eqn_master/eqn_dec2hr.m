function hr = eqn_dec2hr(dec)
%eqn_dec2hr Converts decimal numbers to 24-hr format
% 
% hr = eqn_dec2hr(dec) converts a list of numerical values from the decimal
% system (i.e. 13.5) to a list of strings with the values in the 24-hour
% format (i.e. 13:30).
% 

% turn negative hours to pos (i.e. -3 = 21)
negInd = find(dec < 0);
dec(negInd) = 24 + dec(negInd);

% find unacceptable values (they might still be negative vals if the
% original value was i.e. -50)
unaccInd = find(dec > 24 | dec < 0 | isnan(dec));

% Separate int part from remainder. Turn remainder to MINs.
hour = fix(dec);
hour_min = [hour, fix((dec-hour)*60)];
hr = num2str(hour_min, '%02d:%02d\n');

if ~isempty(unaccInd)
    maxStrlen = size(hr,2);
    nanStr = repmat(' ', [1,maxStrlen]);
    hr(unaccInd,:) = repmat(nanStr, [length(unaccInd),1]);
    hr = hr(:,end-4:end);
end

% hr = datestr(dec/24,'HH:MM'); % slow!
end