function out=getMRXlangdata(shot)
% out=getMRXlangdata(shot)
%
% gets Langmuir probe data for shot
%
% Jan. 2016, Adrian von Stechow

conf = initMRX;
m = loadMRXshot(shot,conf);
out = m.LangData;