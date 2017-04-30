function miscells = Mission_cells()

NoChoicecell = cell(1,3);
NoChoicecell{1,1} = {'----';'----'};
NoChoicecell{1,2} = {'----'}; % this is only one element intentionally so the log_ar in 
% Menu_choice_Callback doesn't exceed matrix dimensions when referencing here
NoChoicecell{1,3} = {'----';'----'};
% NoChoicecell = cellfun(@(x) cho, NoChoicecell, 'UniformOutput', false);
%%%%%%%%%%%%%%%%

SWARMcell = cell(4,3);

SWARMcell{1,1} = {'A';'B';'C'};
    SWARMcell{1,2} = {'MAG_LR'}; SWARMcell{1,3}  = {'F';'B_VFM';'B_NEC'};
    SWARMcell{2,2} = {'MAG_HR'}; SWARMcell{2,3}  = {'B_VFM';'B_NEC'};
    SWARMcell{3,2} = {'MAG_CA'}; SWARMcell{3,3}  = {'F';'B_VFM';};                            
    SWARMcell{4,2} = {'EFI_PL'}; SWARMcell{4,3}  = {'E_NEC';'n'};
    SWARMcell{5,2} = {'EFI_TII'}; SWARMcell{5,3}  = {'E'};
    SWARMcell{6,2} = {'MAG_LR_PPRO'}; SWARMcell{6,3}  = {'F';'B_VFM';'B_NEC'};
%%%%%%%%%%%%%%%%

CHAMPcell = cell(5,3);

CHAMPcell{1,1} = {'1'}; 
    CHAMPcell{1,2} = {'OVM'};       CHAMPcell{1,3}  = {'B'};
    CHAMPcell{2,2} = {'FGM_FGM'};   CHAMPcell{2,3}  = {'B_FGM'};
    CHAMPcell{3,2} = {'FGMFGM'};    CHAMPcell{3,3}  = {'B_FGM'};
    CHAMPcell{4,2} = {'FGM_NEC'};   CHAMPcell{4,3}  = {'B_NEC'};
    CHAMPcell{5,2} = {'PLP'};       CHAMPcell{5,3}  = {'n'};
%%%%%%%%%%%%%%%%

ST5cell = cell(1,3);

ST5cell{1,1} = {'A';'B';'C';};
    ST5cell{1,2} = {'MAG'}; ST5cell{1,3} = {'B_SM';'B-IGRF_SM'}; 

%%%%%%%%%%%%%%%%
CLUSTERcell = cell(5,3);

CLUSTERcell{1,1} = {'1';'2';'3';'4'};
    CLUSTERcell{1,2} = {'FGM_FULL'};    CLUSTERcell{1,3}  = {'B_GSE'};
    CLUSTERcell{2,2} = {'FGM_5Hz'};     CLUSTERcell{2,3}  = {'B_GSE'};
    CLUSTERcell{3,2} = {'FGM_SPIN'};    CLUSTERcell{3,3}  = {'B_GSE'};
    CLUSTERcell{4,2} = {'EFW_FULL'};    CLUSTERcell{4,3}  = {'E_GSE';'E_ISR'};
    CLUSTERcell{5,2} = {'EFW_SPIN'};    CLUSTERcell{5,3}  = {'E_GSE';'E_ISR'};

%%%%%%%%%%%%%%%%

THEMIScell = cell(5,3);
cho = {'----'};
THEMIScell = cellfun(@(x) cho, THEMIScell, 'UniformOutput', false);

%%%%%%%%%%%%%%%%
    
miscells = struct();
miscells.NoChoice = NoChoicecell;
miscells.SWARM = SWARMcell;
miscells.CHAMP = CHAMPcell;
miscells.ST5 = ST5cell;
miscells.CLUSTER = CLUSTERcell;
miscells.THEMIS = THEMIScell;

end
% mis = {'SWARM',SWARMcell;'CHAMP','a'};
% 
% 
% lsg = 'E_NEC';
% cs = cellfun(@(x) find(strcmp(x,lsg)==1), mis,'UniformOutput', false)