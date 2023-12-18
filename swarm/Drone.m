classdef Drone
    properties
        drone_id,
        velocity,
        direction_angle,
        field_of_view,
        view_distance,
        position,
        map,
        lineColor
    end
    
    methods
        function obj = Drone(drone_id, velocity, direction_angle, field_of_view, view_distance)
            obj.drone_id = drone_id;
            obj.velocity = velocity;
            obj.direction_angle = direction_angle;
            obj.field_of_view = field_of_view;
            obj.view_distance = view_distance;
            position = Position(0.1 + (49.9 - 0.1) * rand(1),0.1 + (49.9 - 0.1) * rand(1)); 
            obj.position = position;
            map = Map();
            obj.map = map.addDrone(obj);
            obj.lineColor = rand(1, 3);
        end
        function obj = turnAround(obj)
            obj.direction_angle = mod(90 + obj.direction_angle, 360);
            
    
            % Update the new position using the reflected angle
            obj.position.x = obj.position.x + (obj.velocity * cos(deg2rad(obj.direction_angle)));
            obj.position.y = obj.position.y + (obj.velocity * sin(deg2rad(obj.direction_angle)));
        end
        function obj = move(obj)
            new_position_x = obj.position.x + (obj.velocity * cos(deg2rad(obj.direction_angle)));
            new_position_y = obj.position.y + (obj.velocity * sin(deg2rad(obj.direction_angle)));
            if(new_position_x<50 && new_position_x>0 && new_position_y<50 && new_position_y>0)
                obj.position.x = new_position_x;
                obj.position.y = new_position_y;
            else
                % Drone hits a wall, update direction_angle for reflection
                if new_position_x >= 50 || new_position_x <= 0
                    obj.direction_angle = mod(180 - obj.direction_angle, 360);
                end
        
                if new_position_y >= 50 || new_position_y <= 0
                    obj.direction_angle = mod(-obj.direction_angle, 360);
                end
        
                % Update the new position using the reflected angle
                obj.position.x = obj.position.x + (obj.velocity * cos(deg2rad(obj.direction_angle)));
                obj.position.y = obj.position.y + (obj.velocity * sin(deg2rad(obj.direction_angle)));
            end
        end
    end
end
