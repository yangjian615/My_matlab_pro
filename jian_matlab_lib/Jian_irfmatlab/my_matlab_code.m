function [varargout] = my_matlab_code(varargin)
%my_matlab_code General info
%   
%   my_matlab_code('check') Checks versions of my_matlab_code-matlab
%
%   my_matlab_code('help') Same as help my_matlab_code.
%
%   my_matlab_code('path') Returns or prints path to repo.
%
%   my_matlab_code('ver') Returns version of repo.
%
%   Author: Jian Yang


    pm = {'check','help','path','ver'};
    md = Jian.incheck(varargin,pm);
    
    switch lower(md)
        case 'check'
            disp(['my_matlab_code',my_matlab_code('ver')])
        case 'help'
            help my_matlab_code
        case 'path'
            varargout{1} = fileparts(which('my_matlab_code.m'));
        case 'ver'
            fid = fopen('+my_matlab_code/Contents.m');
            verstr = fgets(fid);
            if(nargout == 1)
                varargout{1} = verstr(3:end);
            else
                fprintf(verstr(3:end));
            end
    end

end

