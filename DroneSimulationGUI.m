classdef DroneSimulationGUI < handle
    properties
        fig
        playButton
        pauseButton
        axesHandle
        swarm
        isPlaying = true
        startTime
        timer
    end
    
    methods
        function obj = DroneSimulationGUI()
            % Create the main figure
            obj.fig = figure('Name', 'Drone Simulation', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);
            
            % Create play button
            obj.playButton = uicontrol('Style', 'pushbutton', 'String', 'Play', 'Position', [20, 20, 80, 30], 'Callback', @(src, event) obj.playSimulation());
            
            % Create pause button
            obj.pauseButton = uicontrol('Style', 'pushbutton', 'String', 'Pause', 'Position', [120, 20, 80, 30], 'Callback', @(src, event) obj.pauseSimulation());
            
            % Create axes for drone display
            obj.axesHandle = axes('Parent', obj.fig, 'Position', [0.1, 0.1, 0.8, 0.8]);
            
            % Initialize the swarm
            obj.swarm = Swarm(10);  % You can adjust the number of drones
            
            % Display initial drone positions
            obj.plotDrones();
        end
        
        function playSimulation(obj)
            obj.isPlaying = true;
            
            % Start the timer
            obj.startTime = tic;
            
            % Define a timer to update the display every 0.005 seconds
            obj.timer = timer('ExecutionMode', 'fixedRate', 'Period', 0.005, 'TimerFcn', @(src, event) obj.updateDisplay());
            start(obj.timer);
        end

        function updateDisplay(obj)
            obj.swarm = obj.swarm.move();
            if(obj.swarm.checkIfGridsEmpty())
                % Stop the timer
                stop(obj.timer);
                
                % Calculate the elapsed time
                elapsedTime = toc(obj.startTime);
                
                % Display the time passed on the screen
                disp(['Simulation completed in ' num2str(elapsedTime) ' seconds.']);
                
                obj.isPlaying = false;
            end
            obj.plotDrones();
            drawnow;
        end
        
        function pauseSimulation(obj)
            obj.isPlaying = false;
            
            % Stop the timer
            stop(obj.timer);
        end
        
        function plotDrones(obj)
            cla(obj.axesHandle); % Clear the axes before plotting
            hold on
        
            for i = 1:obj.swarm.number_of_drones
                % Plot drone position
                x = obj.swarm.drone_members(i).position.x;
                y = obj.swarm.drone_members(i).position.y;
                scatter(obj.axesHandle, x, y, 250, 'o', 'filled', 'MarkerFaceColor', obj.swarm.drone_members(i).lineColor, 'MarkerEdgeColor', obj.swarm.drone_members(i).lineColor);
                text(obj.axesHandle, x, y, num2str(i), 'FontSize', 12, 'Color', 'k', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        
                for j = 1:length(obj.swarm.drone_members(i).map.drone_list)
                    % Plot scanned area
                    scannedDrone = obj.swarm.drone_members(i).map.drone_list(j);
                    direction_angle = scannedDrone.direction_angle;
                    scan_angle = scannedDrone.field_of_view;
                    view_distance = scannedDrone.view_distance;
        
                    % Calculate endpoints of the view field
                    endpoint1 = [x + view_distance * cosd(direction_angle - scan_angle/2), y + view_distance * sind(direction_angle - scan_angle/2)];
                    endpoint2 = [x + view_distance * cosd(direction_angle + scan_angle/2), y + view_distance * sind(direction_angle + scan_angle/2)];
        
                    % Define vertices of the polygon to fill
                    vertices = [x, y; endpoint1; linspace(endpoint1(1), endpoint2(1), 10)', linspace(endpoint1(2), endpoint2(2), 10)'; endpoint2; x, y];
        
                    % Fill the polygon with the corresponding lineColor
                    fill(vertices(:, 1), vertices(:, 2), obj.swarm.drone_members(i).lineColor, 'FaceAlpha', 0.1, 'EdgeColor', 'none');
                end
            end
        
            xlim(obj.axesHandle, [0, 50]);
            ylim(obj.axesHandle, [0, 50]);
            hold off
        end


    end
end
