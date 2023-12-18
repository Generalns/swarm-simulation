classdef Map
 
    properties
        size_x,
        size_y,
        drone_list
    end
    
    methods
        function obj = Map()
            obj.drone_list = [];
        end
        
        function obj = addDrone(obj,drone)
            drone.map = obj;
            obj.drone_list = [obj.drone_list,drone];
        end

        function drone = getDrone(obj,drone_id)
            drone=[];
            for i = 1:length(obj.drone_list)
                if obj.drone_list(i).drone_id == drone_id
                    drone = obj.drone_list(i);
                    break;
                end
            end
            
            if isempty(drone)
                disp(['Drone with ID ' num2str(drone_id) ' not found.']);
            end
        end
    end
end

