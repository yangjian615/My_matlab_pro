function [compField] = compress_field(orField,middleIndex,pow)
%Jian.COMPRESS_FIELD compresses 3D E- or B-field 
%   compField = Jian.COMPRESS_FIELD(orField, middleIndex,pow) - compresses
%   the original field orField around middleIndex with power pow.

compField = orField;

r = abs(orField(:,1)-orField(middleIndex,1));
f = (1-r/max(r)).^pow;
for i = 1:length(orField)
    if i < middleIndex-2 || i > middleIndex+2
        compField(i,2:4) = orField(i,2:4)*f(i);
    end
end

end