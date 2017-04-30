function [varargout] = Jian(varargin)
%Jian General info
%   
%   Jian('check') Checks versions of Jian-matlab and irf-matlab.
%
%   Jian('help') Same as help Jian.
%
%   Jian('path') Returns or prints path to repo.
%
%   Jian('ver') Returns version of repo.
%
%   Author: Jian Yang


    pm = {'check','help','path','ver'};
    md = Jian.incheck(varargin,pm);
    
    switch lower(md)
        case 'check'
            disp(['Jian-matlab ',Jian('ver')])
            irf('check')
        case 'help'
            help Jian
        case 'path'
            varargout{1} = fileparts(which('Jian.m'));
        case 'ver'
            fid = fopen('+Jian/Contents.m');
            verstr = fgets(fid);
            if(nargout == 1)
                varargout{1} = verstr(3:end);
            else
                fprintf(verstr(3:end));
            end
    end

end

