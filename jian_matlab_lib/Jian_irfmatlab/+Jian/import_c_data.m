function [] = import_c_data(x1,x2)
%Jian.IMPORT_C_DATA Downloads data from CSA, stores it in data/caalocal.
%   Always downloads for all s/c.
%   Jian.IMPORT_C_DATA a calendar shows up that lets the user choose the time
%   interval. The calendar is not secure, do not choose more than a couple
%   of days! Then the user is asked to if they want to download certain
%   data products.
%   Jian.IMPORT_C_DATA(tint) uses specified time interval instead of the
%   calendar.
%   Jian.IMPORT_C_DATA(mode) if input is a string the mode specifies the
%   download instead of quesitions.
%   Jian.IMPORT_C_DATA(tint,mode) manual input.
%
%   Remember to run local.c_update afterwards.
%
%   mode:
%       'fgm'   - Only downloads FGM data.  C?_CP_FGM_FULL
%       'efw'   - Only downloads EFW data.  C?_CP_EFW_L2_E3D_GSE
%       'cisMom'   - Only downloads cisMom data.  C?_CP_CIS_HIA_ONBOARD_MOMENTS
%       'cisHiapsd'   - Only downloads cisHiapsd data. C?_CP_CIS-HIA_HS_MAG_IONS_PSD
%       ...
%
%
%   Use at own risk
%
%   Warning: Takes a lot of bandwidth and disk space!!


getData = [];
getData.fgmData = 0;
getData.efwData = 0;
getData.cisHiaData = 0;
getData.cisMomData = 0;

if(nargin == 0)
    tint = get_ui_date();
    getData = ask_data(getData);
elseif(nargin == 1)
    if(length(x1) == 2 && ~ischar(x1)) % tint input
        tint = x1;
        getData = ask_data(getData);
    elseif(ischar(x1)) %type input
        tint = get_ui_date();
        getData = set_get_data(getData,x1);
    end
elseif(nargin == 2)
    tint = x1;
    getData = set_get_data(getData,x2);
end


irf.log('warning','Downloading the chosen data...')
if(getData.fgmData == 1)
    caa_download(tint,'C?_CP_FGM_FULL');
end
if(getData.efwData == 1)
    caa_download(tint,'C?_CP_EFW_L2_E3D_GSE');
end
if(getData.cisHiaData == 1)
    caa_download(tint,'C?_CP_CIS-HIA_HS_MAG_IONS_PSD');
end
if(getData.cisMomData == 1)
    caa_download(tint,'C?_CP_CIS_HIA_ONBOARD_MOMENTS');
end

irf.log('warning','moving data to data/caalocal')
[~,cmdout] = system('mv ./CAA/* data/caalocal');
irf.log('warning',['terminal output:',cmdout])

irf.log('warning','removing CAA folder...')
[~,cmdout] = system('rm -r ./CAA');
irf.log('warning',['terminal output:',cmdout])


end

function getData = set_get_data(getData,type)
switch type
    case 'fgm'
        getData.fgmData = 1;
        
    case 'efw'
        getData.efwData = 1;
    case 'cisMom'
        getData.cisMomData = 1;
    case 'cisHiapsd'
        getData.cisHiaData = 1;        
        
    otherwise
        irf.log('critical','invalid input')
end
end



function getData = ask_data(getData)
getData.fgmData = irf_ask('Download FGM data? 0/1 [%]>','getData.fgmData',0);
getData.efwData = irf_ask('Download EFW data? 0/1 [%]>','getData.efwData',0);
getData.cisHiaData = irf_ask('Download 3D CIS-HIA data? 0/1 [%]>','getData.cisHiaData',0);
getData.cisMomData = irf_ask('Download CIS onboard moments? 0/1 [%]>','getData.cisMomData',0);

end

function tint = get_ui_date()

disp('Select start date:')

f = figure();
h = uicontrol(f,'Style', 'pushbutton', 'Position', [20 150 20 20],'visible','off');
f.Visible = 'off';
uicalendar('DestinationUI',{h, 'String'},...
    'SelectionType',1,...
    'OutputDateFormat','yyyy mm dd HH MM SS',...
    'InitDate','01-Jan-2002');

waitfor(h,'String');
val1 = get(h,'String');
irf.log('warning',['Start date: ',val1])
disp('Select stop date:')
uicalendar('DestinationUI',{h, 'String'},...
    'SelectionType',1,...
    'OutputDateFormat','yyyy mm dd HH MM SS',...
    'InitDate',datenum(val1,'yyyy mm dd HH MM SS'));
waitfor(h,'String');
val2 = get(h,'String');
irf.log('warning',['Stop date:  ',val2])

tint = [irf_time(str2num(val1)),irf_time(str2num(val2))];

end

