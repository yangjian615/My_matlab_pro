classdef jian_irfmatlab
    %jian_irfmatlab Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        workpath=[];
        datadir=[];
        caaDirDefault='/data/caalocal';
    end
    
    methods
        function []=init(obj)
            
            obj.workpath = pwd;
            addpath(obj.workpath);
            addpath(genpath([obj.workpath filesep '.']));
            
            rmpath(genpath([obj.workpath '/data_cluster']));
            
            
            
            datastore('caa','localDataDirectory',obj.datadir);
            irf.log('critical','localDataDirectory is: ');
            disp(obj.datadir);
        end
        function obj = jian_irfmatlab(varargin)
            obj.workpath = pwd;
            if nargin<1
                obj.datadir =[pwd '/data_cluster/data/caalocal'];
            else if varargin{1, 1}=='data_path'
                    obj.datadir=varargin{1, 2};
                end
            end
            
        end
        
        function obj = reset(obj)            
            obj.workpath=pwd;
            obj.datadir=obj.caaDirDefault;
            
                    
        end
        
    end
    
end

