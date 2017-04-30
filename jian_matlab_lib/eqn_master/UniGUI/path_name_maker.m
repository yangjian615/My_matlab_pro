function [output, type_index] = path_name_maker(name)

    if nargin < 1; savename = 'ma'; 
    else savename = name;
    end
    
    Options_cell = { '*.png','PNG image (*.png)';...
                     '*.jpg','JPEG image (*.jpg)';...
                     '*.bmp','BMP 24 bit image (*.bmp)';...
                     '*.eps','EPS file (*.eps)';...
                     '*.fig','Figures (*.fig)';...
                     '*.mat','MAT-files (*.mat)';...
                     '*.*',  'All Files (*.*)'};

    
    [filename, pathname, filterindex] = uiputfile(Options_cell,'Save figure',savename);
    
    output = [pathname, filename];
    type_index = filterindex;
end
 