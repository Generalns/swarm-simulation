classdef Swarm
    properties
        drone_members,
        number_of_drones,
        DEFAULT_VELOCITY = 0.5,
        DEFAULT_DIRECTION_ANGLE = 60,
        DEFAULT_FIELD_OF_VIEW = 60,
        DEFAULT_VIEW_DISTANCE = 10,
        grids = cell(51,51)
    end
    
    methods
        function obj = Swarm(number_of_drones)
            obj.number_of_drones = number_of_drones;
            obj.drone_members = Drone.empty(0, number_of_drones);  % Initialize an empty array
            for x = 0:50
                for y = 0:50
                    obj.grids{x+1, y+1} = [x, y];
                end
            end
            for i = 1:number_of_drones
                direction_angle =360 * rand(1);
                drone = Drone(i, obj.DEFAULT_VELOCITY, direction_angle, obj.DEFAULT_FIELD_OF_VIEW, obj.DEFAULT_VIEW_DISTANCE);
                obj = obj.addDrone(drone);
            end
            
            for j = 1:number_of_drones
                obj.drone_members(j) = obj.scanMapForDrones(obj.drone_members(j));
            end
        end


        function obj = addDrone(obj,drone)
            obj.drone_members = [obj.drone_members,drone];
        end

        function [drone,updatedGrids] = scanMapForDrones(obj, drone)
            map = Map();
            drone.map = map.addDrone(drone);
            for i = 1:obj.number_of_drones
                if i ~= drone.drone_id % Skip checking against itself
                    delta_x = obj.drone_members(i).position.x - drone.position.x;
                    delta_y = obj.drone_members(i).position.y - drone.position.y;
                    distance = sqrt(delta_x^2 + delta_y^2);
                    theta = atan2(delta_y, delta_x);
                    theta = rad2deg(theta); % Convert theta to degrees
                    
                    % Calculate relative angle within the drone's field of view
                    relative_angle = mod(theta - drone.direction_angle + 180, 360) - 180;
                    
                    min_angle = -drone.field_of_view/2;
                    max_angle = drone.field_of_view/2;
                    
                    if (distance <= drone.view_distance) && (relative_angle >= min_angle) && (relative_angle <= max_angle)
                        drone.map = drone.map.addDrone(obj.drone_members(i));
                        drone = drone.turnAround();
                        disp(['Drone with ID ' num2str(drone.drone_id) ' detected another drone with ID ' num2str(obj.drone_members(i).drone_id)]);
                        disp(['Direction angle: ' num2str(drone.direction_angle) ]);

                    end
                end
            end
            for gridX = 1:size(obj.grids, 1)
                for gridY = 1:size(obj.grids, 2)
                    gridPoint = obj.grids{gridX, gridY};
        
                     if ~isempty(gridPoint)
                        delta_x = gridPoint(1) - drone.position.x;
                        delta_y = gridPoint(2) - drone.position.y;
                        distance = sqrt(delta_x^2 + delta_y^2);
                        theta = atan2(delta_y, delta_x);
                        theta = rad2deg(theta);
        
                        % Calculate relative angle within the drone's field of view
                        relative_angle = mod(theta - drone.direction_angle + 180, 360) - 180;
        
                        min_angle = -drone.field_of_view/2;
                        max_angle = drone.field_of_view/2;
        
                        if (distance <= drone.view_distance) && (relative_angle >= min_angle) && (relative_angle <= max_angle)
                            % Mark the grid point for removal
                            obj.grids{gridX, gridY} = [];
                            disp(['Grid point (' num2str(gridPoint(1)) ',' num2str(gridPoint(2)) ') is scanned by drone with ID ' num2str(drone.drone_id)]);
                        end
                    end
                end
            end

            updatedGrids = obj.grids;
        end

        function isGridsEmpty = checkIfGridsEmpty(obj)
            % Initialize the flag to true
            isGridsEmpty = true;
        
            % Iterate over the grid points
            for gridX = 1:size(obj.grids, 1)
                for gridY = 1:size(obj.grids, 2)
                    % Check if the current grid point is not empty
                    if ~isempty(obj.grids{gridX, gridY})
                        % If any non-empty point is found, set the flag to false and break the loop
                        isGridsEmpty = false;
                        break;
                    end
                end
                % Break the outer loop if a non-empty point is found
                if ~isGridsEmpty
                    break;
                end
            end
        end
        % function obj = printAllMaps(obj)
        %     for i = 1:obj.number_of_drones
        %         figure('name', ['Map of drone with id: ' num2str(i)]);
        %         hold on
        %         for j = 1:length(obj.drone_members(i).map.drone_list)
        %             x = obj.drone_members(i).map.drone_list(j).position.x;
        %             y = obj.drone_members(i).map.drone_list(j).position.y;
        %             id = obj.drone_members(i).map.drone_list(j).drone_id;
        % 
        %             % Plot 'o' symbol
        %             scatter(x, y, 'o');
        % 
        %             % Add text label with drone ID
        %             text(x, y, num2str(id), 'FontSize', 12, 'Color', 'k', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        %         end
        %         for j = 1:length(obj.drone_members(i).map.drone_list)
        %             x = obj.drone_members(i).map.drone_list(j).position.x;
        %             y = obj.drone_members(i).map.drone_list(j).position.y;
        %             direction_angle = obj.drone_members(i).map.drone_list(j).direction_angle;
        %             scan_angle = obj.drone_members(i).map.drone_list(j).field_of_view;
        %             view_distance = obj.drone_members(i).map.drone_list(j).view_distance;
        %             % Calculate endpoints of the view field
        %             endpoint1 = [x + view_distance * cosd(direction_angle - scan_angle/2), y + view_distance * sind(direction_angle - scan_angle/2)];
        %             endpoint2 = [x + view_distance * cosd(direction_angle + scan_angle/2), y + view_distance * sind(direction_angle + scan_angle/2)];
        % 
        %             % Plot the view field
        %             plot([x, endpoint1(1)], [y, endpoint1(2)], '--', 'Color', rand(1,3)); % Use a random color
        %             plot([x, endpoint2(1)], [y, endpoint2(2)], '--', 'Color', rand(1,3)); % Use a different random color
        %         end
        % 
        %         xlim([0, 50]);
        %         ylim([0, 50]);
        %         hold off
        %     end
        % end

        % function obj = printMap(obj,drone_id)
        % 
        %         %figure('name', ['Map of drone with id: ' num2str(drone_id)]);
        %         %hold on
        %         for j = 1:length(obj.drone_members(drone_id).map.drone_list)
        %             x = obj.drone_members(drone_id).map.drone_list(j).position.x;
        %             y = obj.drone_members(drone_id).map.drone_list(j).position.y;
        %             id = obj.drone_members(drone_id).map.drone_list(j).drone_id;
        % 
        %             % Plot 'o' symbol
        %             scatter(x, y, 'o');
        % 
        %             % Add text label with drone ID
        %             text(x, y, num2str(id), 'FontSize', 12, 'Color', 'k', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        %         end
        %         for j = 1:length(obj.drone_members(drone_id).map.drone_list)
        %             x = obj.drone_members(drone_id).map.drone_list(j).position.x;
        %             y = obj.drone_members(drone_id).map.drone_list(j).position.y;
        %             direction_angle = obj.drone_members(drone_id).map.drone_list(j).direction_angle;
        %             scan_angle = obj.drone_members(drone_id).map.drone_list(j).field_of_view;
        %             view_distance = obj.drone_members(drone_id).map.drone_list(j).view_distance;
        %             % Calculate endpoints of the view field
        %             endpoint1 = [x + view_distance * cosd(direction_angle - scan_angle/2), y + view_distance * sind(direction_angle - scan_angle/2)];
        %             endpoint2 = [x + view_distance * cosd(direction_angle + scan_angle/2), y + view_distance * sind(direction_angle + scan_angle/2)];
        % 
        %             % Plot the view field
        %             plot([x, endpoint1(1)], [y, endpoint1(2)], '--', 'Color', rand(1,3)); % Use a random color
        %             plot([x, endpoint2(1)], [y, endpoint2(2)], '--', 'Color', rand(1,3)); % Use a different random color
        %         end
        % 
        %         xlim([0, 50]);
        %         ylim([0, 50]);
        %         hold off
        % 
        % 
        % end

        function obj = move(obj)
            for i = 1:obj.number_of_drones
                obj.drone_members(i) = obj.drone_members(i).move();
            end
            for j = 1:obj.number_of_drones
                [obj.drone_members(j),updatedGrids] = obj.scanMapForDrones(obj.drone_members(j));
                obj.grids = updatedGrids;
            end
        end


    end
end

