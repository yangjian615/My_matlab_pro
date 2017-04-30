function ComponentList = eqn_transformOldComponentToNew(ComponentMatrix)
%eqn_transformOldComponentToNew     Helper Function
% 
% "OldComponent" was a matrix, where each line had one '1' and the rest '0'
% values. The place where the '1' was, was the index of the selected
% component, i.e. [0, 1, 0, 0] was Y, [1, 0, 0, 0] was X etc with [0, 0, 0,
% 1] being the total Magnitude of the vector: sqrt(X^2 + Y^2 + Z^2)
%
% New Component is a list of numbers, from 1 to 7, where each number is the
% decimal value of the binary representation of the component selection
% according to the rule:
%           X  Y  Z
% ONLY X : [1, 0, 0] = 4 (dec value of binary '100')
% ONLY Y : [0, 1, 0] = 2 (dec value of binary '010')
% ONLY Z : [0, 0, 1] = 1 (dec value of binary '001')
% TOTAL  : [1, 1, 1] = 7 (dec value of binary '111')
% |X+Y|  : [1, 1, 0] = 6 (dec value of binary '110')
% |X+Z|  : [1, 0, 1] = 5 (dec value of binary '101')
% |Y+Z|  : [0, 1, 1] = 3 (dec value of binary '011')
%
% The function trasforms an old binary Component Matrix (4x4) to a new 
% decimal Component List (4x1).
%

ComponentList = nan(4,1);

for i=1:size(ComponentMatrix,1)
    val = find(ComponentMatrix(i,:) == 1);
    if isempty(val)
        ComponentList(i) = 0;
    elseif val == 4;
        ComponentList(i) = 7;
    else
        ComponentList(i) = val;
    end
end    


end

