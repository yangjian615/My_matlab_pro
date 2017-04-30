function [time_series, metadata] = eqn_readSwarmNative(filename, params)
%readSwarmNative Extract variables from Swarm data files
%
%   Aknowledgement: Many thanks to I. Sandberg (sandberg@noa.gr) for
%   writing the IDL script on which this function is based upon.

if nargin<2
    params = '';
end

SwarmDataType = filename(end-50:end-41);
metadata = getMeta(SwarmDataType);
time_series = [];

if isempty(params)
    disp('Enter one or more Variables as a cell input argument. Choose from:');
    disp(metadata.Variables);
   
    disp('    Use parameter ''matlab_time'' for time in the native matlab format');
else

fileMeta = dir(filename);
nRecords = (fileMeta.bytes - metadata.OtherDatasetsSize)/metadata.DatasetSize;
if mod(nRecords, 1) ~= 0
    disp('WARNING: File seems to contain partial or incomplete records!');
    nRecords = floor(nRecords);
end

nVars = length(params);
n = 0;
outputColumnIndex = [];
for i=1:length(params)
    if strcmp('matlab_time', params{i})
        outputColumnIndex = [outputColumnIndex; n+1]; %#ok<AGROW>
        n = n + 1;
    else
        f = find(strcmp(metadata.Variables, params{i}), 1);
        if isempty(f)
            disp(['Error: Cannot find variable named ''',params{i},'''. Please use one (or more) of the ']);
            disp('following:');
            disp(metadata.Variables);
            error('');
        else
            outputColumnIndex = [outputColumnIndex; n+1]; %#ok<AGROW>
            n = n + metadata.Dims(f,1)*metadata.Dims(f,2);
        end
    end
end

fid = fopen(filename, 'r', 'b');
time_series = zeros(nRecords, outputColumnIndex(end));

for i=1:nVars
    if strcmp('matlab_time', params{i})
        [time_data, ~] = eqn_readSwarmNative(filename, {'Day'; 'Sec'; 'Microsec'});
        t = datenum(2000,1,1) + time_data(:,1) + time_data(:,2)/(24*3600) + time_data(:,3)/(24*3600*10^6);
        time_series(:,outputColumnIndex(i)) = t;
    else    
        f = find(strcmp(metadata.Variables, params{i}), 1);
        nCols = metadata.Dims(f,1)*metadata.Dims(f,2);
        for j=1:nCols
            var_size = metadata.Offset(f+1) - metadata.Offset(f);
            fseek(fid, metadata.Offset(f) + (j-1)*(var_size/nCols), 'bof');
            x = fread(fid, [nRecords, 1], metadata.VarType{f}, metadata.DatasetSize-var_size/nCols);
            time_series(:,outputColumnIndex(i)+j-1) = x / metadata.ScalingFactor(f);
        end
    end
end

fclose(fid);


end

function meta = getMeta(SwarmDataType)
    meta = [];
    satellite = SwarmDataType(4);
    
    switch SwarmDataType
        case {'MAGA_LR_1B', 'MAGB_LR_1B', 'MAGC_LR_1B'}
            meta.Description = 'SWARM MAG Data - Low Resolution - Level 1B';
            meta.Satellite = ['SWARM SC ',satellite];
            meta.DatasetSize = 132;
            meta.OtherDatasetsSize = 292;
            meta.Variables = {'MDR_ID'; 'SyncStatus'; 'Day'; 'Sec'; 'Microsec'; 
    'Latitude'; 'Longitude'; 'Radius'; 'F'; 'dF_AOCS'; 'dF_other'; 'F_error';
    'B_VFM'; 'B_NEC'; 'dB_AOCS'; 'dB_other'; 'B_error'; 'q_NEC_CRF'; 'Att_error';
    'Flags_F'; 'Flags_B'; 'Flags_q'; 'Fill'; 'Flags_Platform'; 'ASM_Freq_Dev'};
            meta.Offset = [0;2;4;8;12;16;20;24;28;32;36;40;44;56;68;80;92;104;120;124;125;126;127;128;130;132];
            meta.ScalingFactor = 10.^[0;0;0;0;0;7;7;2;4;4;4;4;4;4;4;4;4;9;4;0;0;0;0;0;1];
            meta.Dims = [[1;1;1;1;1;1;1;1;1;1;1;1;3;3;3;3;3;4;1;1;1;1;1;1;1], ones(25,1)];
            meta.VarType = {'uint16'; 'uint16'; 'int32'; 'uint32'; 'uint32'; 'int32'; 'int32'; 
    'uint32'; 'uint32'; 'int32'; 'int32'; 'uint32'; 'int32'; 'int32'; 'int32';
    'int32'; 'uint32'; 'int32'; 'uint32'; 'uint8'; 'uint8'; 'uint8'; 'uint8';
    'uint16'; 'int16'};

        case {'MAGA_HR_1B', 'MAGB_HR_1B', 'MAGC_HR_1B'}
            meta.Description = 'SWARM MAG Data - High Resolution - Level 1B';
            meta.Satellite = ['SWARM SC ',satellite];
            meta.DatasetSize = 112;
            meta.OtherDatasetsSize = 292;
            meta.Variables = {'MDR_ID'; 'SyncStatus'; 'Day'; 'Sec'; 'Microsec'; 
    'Latitude'; 'Longitude'; 'Radius';
    'B_VFM'; 'B_NEC'; 'dB_AOCS'; 'dB_other'; 'B_error'; 'q_NEC_CRF'; 'Att_error';
    'Flags_B'; 'Flags_q'; 'Flags_Platform'};
            meta.Offset = [0;2;4;8;12;16;20;24;28;40;52;64;76;88;104;108;109;110;112];
            meta.ScalingFactor = 10.^[0;0;0;0;0;7;7;2;4;4;4;4;4;9;4;0;0;0];
            meta.Dims = [[1;1;1;1;1;1;1;1;3;3;3;3;3;4;1;1;1;1], ones(18,1)];
            meta.VarType = {'uint16'; 'uint16'; 'int32'; 'uint32'; 'uint32'; 'int32'; 'int32'; 
    'uint32'; 'int32'; 'int32'; 'int32';
    'int32'; 'uint32'; 'int32'; 'uint32'; 'uint8'; 'uint8'; 'uint16'};

        case {'MAGA_CA_1B', 'MAGB_CA_1B', 'MAGC_CA_1B'}
            meta.Description = 'SWARM MAG Data - Calibration File - Level 1B';
            meta.Satellite = ['SWARM SC ',satellite];
            meta.DatasetSize = 104;
            meta.OtherDatasetsSize = 292;
            meta.Variables = {'MDR_ID'; 'SyncStatus'; 'Day'; 'Sec'; 'Microsec'; 
    'Latitude'; 'Longitude'; 'Radius';
    'F'; 'dF_AOCS'; 'dF_other'; 'F_error'; 'F_VFM';
    'B'; 'dB_AOCS'; 'dB_other';
    'EU_VFM'; 'T_CDC'; 'T_CSC'; 'T_EU'; 'dt_VFM'};
            meta.Offset = [0;2;4;8;12;16;20;24;28;32;36;40;44;48;60;72;84;96;98;100;102;104];
            meta.ScalingFactor = 10.^[0;0;0;0;0;7;7;2;4;4;4;4;4;4;4;4;4;2;2;2;4];
            meta.Dims = [[1;1;1;1;1;1;1;1;1;1;1;1;1;3;3;3;3;1;1;1;1], ones(21,1)];
            meta.VarType = {'uint16'; 'uint16'; 'int32'; 'uint32'; 'uint32'; 
    'int32'; 'int32'; 'uint32'; 'uint32'; 'int32'; 'int32'; 'uint32'; 
    'uint32'; 'int32'; 'int32'; 'int32'; 'int32'; 'int16'; 'int16'; 'int16'; 
    'int16'};

        case {'EFIA_PL_1B', 'EFIB_PL_1B', 'EFIC_PL_1B'}
            meta.Description = 'SWARM EFI Data - Level 1B';
            meta.Satellite = ['SWARM SC ',satellite];
            meta.DatasetSize = 196;
            meta.OtherDatasetsSize = 0;
            meta.Variables = {'MDR_ID'; 'SyncStatus'; 'Day'; 'Sec'; 'Microsec'; 
    'Latitude'; 'Longitude'; 'Radius';
    'v_SC'; 'v_ion'; 'v_ion_error'; 'E'; 'E_error'; 'dt_LP'; 'n'; 'n_error';
    'T_ion'; 'T_ion_error'; 'T_elec'; 'T_elec_error'; 'U_SC'; 'U_SC_error';
    'v_ion_H'; 'v_ion_H_error'; 'v_ion_V'; 'v_ion_V_error'; 
    'rms_fit_H'; 'rms_fit_V'; 'var_x_H'; 'var_y_H'; 'var_x_V'; 'var_y_V';
    'dv_mtq_H'; 'dv_mtq_V'; 'SAA'; 'Flags_LP'; 'Flags_LP_n'; 'Flags_LP_T_elec';
    'Flags_LP_U_SC'; 'Flags_TII'; 'Flags_Platform'; 'Maneuver_Id'; 'Fill'};
            meta.Offset = [0;2;4;8;12;16;20;24;28;40;52;64;76;88;92;96;100;104;108;112;116;118;120;128;136;144;152;156;160;164;168;172;176;180;184;185;186;187;188;189;190;192;194;196];
            meta.ScalingFactor = 10.^[0;0;0;0;0;7;7;2;3;2;2;6;6;6;1;1;2;2;2;2;3;3;3;3;3;3;6;6;5;5;5;5;3;3;0;0;0;0;0;0;0;0;0];
            meta.Dims = [[1;1;1;1;1;1;1;1;3;3;3;3;3;1;1;1;1;1;1;1;1;1;2;2;2;2;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1], ones(43,1)];
            meta.VarType = {'uint16'; 'uint16'; 'int32'; 'uint32'; 'uint32'; 'int32'; 'int32'; 
    'uint32'; 'int32'; 'int32'; 'int32'; 'int32'; 'int32'; 'int32';
    'uint32'; 'uint32'; 'uint32'; 'uint32'; 'uint32'; 'uint32';
    'int16'; 'int16'; 'int32'; 'int32'; 'int32'; 'int32'; 'int32'; 'int32'; 
    'int32'; 'int32'; 'int32'; 'int32'; 'int32'; 'int32'; 
    'uint8'; 'uint8'; 'uint8'; 'uint8'; 'uint8'; 'uint8'; 
    'uint16'; 'uint16'; 'uint16'};

        otherwise
            
    end

end
end