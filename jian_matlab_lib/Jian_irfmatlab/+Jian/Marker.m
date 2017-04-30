classdef Marker
    %Jian.MARKER Class for storing shapes.
    %
    %   Holds an array of patches that have some shape. This allows for
    %   custom markers in Matlab.
    %
    %   MARKER Properties:
    %       Shapes  -   Vector of graphic objects
    %       Size    -   Size of shapes (has no use)
    %       Color   -   Color of shapes, only one color allowed
    %       Visible -   'on' or 'off'
    %       N       -   Number of shapes in vector
    %
    %   MARKER Constructor:
    %       m = Jian.MARKER(hArray) Where hArray is a vector with patches
    %       or other graphic objects.
    %
    
    properties
        Shapes
        Size = 1;
        Color = [0,0,0]
        Visible = 'on'
    end
    
    properties(SetAccess = immutable)
        N
    end
    
    
    %% Methods
    methods
        %Constructor
        function obj = Marker(hAr)
            obj.Shapes = hAr;
            obj.Visible = 'on';
            obj.N = length(obj.Shapes);
            obj.update_color
        end
        
        % Set methods
        function obj = set.Color(obj,color)
            obj.Color = color;
            obj.update_color;
        end
        
        function obj = set.Visible(obj,value)
            if(strcmp(value,'on') || strcmp(value,'off'))
                obj.Visible = value;
                obj.update_visible;
            else
                error('Unknown value of Visible')
            end
        end
    end
    
    
    % Hidden methods
    methods(Hidden = true, Access = protected )
        
        function [] = update_color(obj)
            for i = 1:obj.N
                obj.Shapes(i).EdgeColor = obj.Color;
                obj.Shapes(i).FaceColor = obj.Color;
            end
        end
        
        function [] = update_visible(obj)
            for i = 1:obj.N
                obj.Shapes(i).Visible = obj.Visible;
            end
        end
%         function [] = update_size(obj)
%             obj.Shapes = 
%         end
        
        
    end
    
end

