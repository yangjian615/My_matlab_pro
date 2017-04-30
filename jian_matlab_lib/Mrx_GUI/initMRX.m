function out = initMRX
% out = initMRX
%
% Initializes paths for MRX data processing and loads configuration data
% saved in config.txt
%
% out: struct containing paths defined in config.txt
%
% Jan. 2016, Adrian von Stechow

if ~(exist('mrxGUI','file')==2) % check if mrxGUI has been added to path
    thisPath = fileparts(mfilename('fullpath'));
    
    addpath(fullfile(thisPath,'getters'))
    addpath(fullfile(thisPath,'plotters'))
    addpath(fullfile(thisPath,'evaluation'))
    addpath(fullfile(thisPath,'postprocess'))
    addpath(genpath(fullfile(thisPath,'mrxGUI')))
    addpath(fullfile(thisPath,'dependencies'))
    addpath(fullfile(thisPath,'probes'))
    addpath(fullfile(thisPath,'old'))
    
end


out=loadconf('mrxGUI/config.txt');