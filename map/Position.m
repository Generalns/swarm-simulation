classdef Position
    properties
        x,
        y
    end
    
    methods
        function obj = Position(position_x,position_y)
            obj.x = position_x;
            obj.y = position_y;
        end
    end
end

