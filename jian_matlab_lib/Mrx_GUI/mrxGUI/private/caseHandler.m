function data = caseHandler(handles,select,tInd)
% data = caseHandler(handles,select,tInd)
% returns dataset according to selection string
% handles: gui handles struct
% select:  string of selection
% tInd:    time index to plot
%
% Jan. 2016, Adrian von Stechow

switch select
    
    case 'coil currents'
        
        tmp = getappdata(handles.figure1,'fastCurrents');
        data.values = [tmp.TF_Current tmp.PF_Current tmp.SF_Current]./1000;
        data.time   = tmp.time;
        data.label  = 'I [kA]';
        data.legend = {'TF','PF','SF'};
        data.xtra   = NaN;
        data.ylims  = [0 50];
        
    case 'rec. rate'
        
        tmp = getappdata(handles.figure1,'magData');
        data.values = -tmp.Poloidal_Nulls.Ephi;
        data.time   = getappdata(handles.figure1,'time');
        data.label  = 'E [V/m]';
        data.legend = NaN;
        data.xtra   = {'hline(h,0)'};
        data.ylims  = [-50 250];
        
    case 'x-point r pos.'
        
        tmp = getappdata(handles.figure1,'magData');
        data.values = tmp.Poloidal_Nulls.x*1000;
%         multiNulls = size(data.values,1)>1; % multiple nulls detected
        data.time   = getappdata(handles.figure1,'time');
        data.label  = 'r [mm]';
        data.legend = NaN;
        data.xtra   = {'hline(h,375)'};
        data.ylims  = NaN;
        
        % get center crossing time point
        % TODO handle multiple X-points better, right now only uses first
        % one
        tCross = data.time(ind_get(data.values(1,:),375));
            
        setappdata(handles.figure1,'tCross',tCross)
        
    case 'x-point z pos.'
        
        tmp = getappdata(handles.figure1,'magData');
        data.values = tmp.Poloidal_Nulls.z*1000;
        data.time   = getappdata(handles.figure1,'time');
        data.label  = 'z [mm]';
        data.legend = NaN;
        data.xtra   = {'hline(h,0)'};
        data.ylims  = NaN;
        
    case 'total current'
        
        tmp = getappdata(handles.figure1,'magData');
        data.values = [tmp.I_2D./1000; squeeze(min(min(tmp.Jy)))'/2e5];
        data.time   = getappdata(handles.figure1,'time');
        data.label  = 'I [kA]';
        data.legend = NaN;
        data.xtra   = {'hline(h,0)'};
        data.ylims  = NaN;
        
    case 'density'
        
        langData = loadLangmuir(handles);
        
        data.values = [langData.ne];
        data.time   = langData(1).time;
        data.label  = 'n [m^{-3}]';
        data.legend = NaN;
        data.xtra   = NaN;
        data.ylims  = [0 20];
        
    case  'electron temperature'
        
        langData = loadLangmuir(handles);
        
        data.values = [langData.Te];
        data.time   = langData(1).time;
        data.label  = 'T_e [eV]';
        data.legend = NaN;
        data.xtra   = NaN;
        data.ylims  = [0 15];
        
    case  'Jy'
        
        tmp = getappdata(handles.figure1,'magData');
        
        data.values = tmp.Jy(:,:,tInd)/1e6;
        data.time   = getappdata(handles.figure1,'time');
        data.label  = ' [MA/m^2]';
        data.legend = NaN;
        data.xtra   = NaN;
%         data.ylims  = [-1 1]*max(max(max(abs(tmp.Jy(:,:,260:400)))))*1e-6;
        data.ylims  = [-1 1];
        data.rx     = tmp.Poloidal_Nulls.x(1,tInd);
        data.zx     = tmp.Poloidal_Nulls.z(1,tInd);
        
    case  'By'
        
        tmp = getappdata(handles.figure1,'magData');
        
        %TODO better way subtract guide field?
        data.values = (tmp.By(:,:,tInd)-mean(mean(tmp.By(:,:,tInd))))*1e3;
        data.time   = getappdata(handles.figure1,'time');
        data.label  = ['[mT], mean ' num2str(mean(mean(tmp.By(:,:,tInd)))*1000)];
        data.legend = [];
        data.xtra   = NaN;
        data.ylims  = NaN;
        data.rx     = tmp.Poloidal_Nulls.x(1,tInd);
        data.zx     = tmp.Poloidal_Nulls.z(1,tInd);
        
        
    case  'Bz'
        
        tmp = getappdata(handles.figure1,'magData');
        
        data.values = tmp.Bz(:,:,tInd)*1e3;
        data.time   = getappdata(handles.figure1,'time');
        data.label  = ' [mT]';
        data.legend = NaN;
        data.xtra   = NaN;
        data.ylims  = NaN;
        data.rx     = tmp.Poloidal_Nulls.x(1,tInd);
        data.zx     = tmp.Poloidal_Nulls.z(1,tInd);
        
    case  'Ey'
        
        tmp = getappdata(handles.figure1,'magData');
        
        data.values = tmp.Ephi(:,:,tInd);
        data.time   = getappdata(handles.figure1,'time');
        data.label  = ' [V/m]';
        data.legend = NaN;
        data.xtra   = NaN;
        data.ylims  = [-250 250];
        data.rx     = tmp.Poloidal_Nulls.x(1,tInd);
        data.zx     = tmp.Poloidal_Nulls.z(1,tInd);
        
    case  'Jx'
        
        tmp = getappdata(handles.figure1,'magData');
        
        data.values = tmp.Jx(:,:,tInd);
        data.time   = getappdata(handles.figure1,'time');
        data.label  = ' [MA/m^2]';
        data.legend = NaN;
        data.xtra   = NaN;
        data.ylims  = NaN;
        data.rx     = tmp.Poloidal_Nulls.x(1,tInd);
        data.zx     = tmp.Poloidal_Nulls.z(1,tInd);
        
    case  'Jz'
        
        tmp = getappdata(handles.figure1,'magData');
        
        data.values = tmp.Jz(:,:,tInd);
        data.time   = getappdata(handles.figure1,'time');
        data.label  = ' [MA/m^2]';
        data.legend = NaN;
        data.xtra   = NaN;
        data.ylims  = NaN;
        data.rx     = tmp.Poloidal_Nulls.x(1,tInd);
        data.zx     = tmp.Poloidal_Nulls.z(1,tInd);
        
    case  'Flux'
        
        tmp = getappdata(handles.figure1,'magData');
        
        data.values = tmp.Flux(:,:,tInd);
        data.time   = getappdata(handles.figure1,'time');
        data.label  = ' [T/m^2]';
        data.legend = NaN;
        data.xtra   = NaN;
        data.ylims  = [min(data.values(:)) max(data.values(:))];
        data.rx     = tmp.Poloidal_Nulls.x(1,tInd);
        data.zx     = tmp.Poloidal_Nulls.z(1,tInd);
        
    otherwise
        
        data.values = NaN;
        data.label  = '';
        data.time   = NaN;
        data.legend = NaN;
        data.xtra   = NaN;
        data.ylims  = NaN;
        
end

end

function langData = loadLangmuir(handles)
% loads langmuir probe data if that hasn't been done yet

if isappdata(handles.figure1,'langData')
    % already loaded!
    langData = getappdata(handles.figure1,'langData');
else
    tmp = getappdata(handles.figure1,'matFile');
    setappdata(handles.figure1,'langData',tmp.LangData);
    langData = tmp.LangData;
end

end