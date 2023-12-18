# Project Title: Swarm Simulation

## Description

This project provides a simple MATLAB simulation of a swarm of drones moving within a defined area. Each drone is represented as an object with various properties, including its position, velocity, direction angle, field of view, and view distance. The drones navigate through the simulation space, avoiding collisions with each other and scanning their surroundings.

The simulation includes a graphical user interface (GUI) built using MATLAB's figure and uicontrol components. The GUI allows users to control the simulation with play and pause buttons. The drones move continuously, and their positions are updated in real-time on the display.

![Swarm Simulation](https://github.com/Generalns/swarm-simulation/blob/main/DroneSimulation.png?raw=true)

## Getting Started

To run the simulation, follow these steps:

1. Open MATLAB.
2. Copy and paste the code from the provided `DroneSimulationGUI.m`, `Map.m`, `Position.m`, `Drone.m`, and `Swarm.m` files into MATLAB's editor.
3. Run the `DroneSimulationGUI` class constructor to initialize the simulation.
4. Use the "Play" button to start the simulation, and the "Pause" button to pause it.

## Customization

You can customize the simulation by adjusting parameters such as the number of drones, their initial properties, and the simulation area size.

### Adjusting the Number of Drones

```matlab
% Inside DroneSimulationGUI.m
obj.swarm = Swarm(10);  % You can adjust the number of drones by changing the argument (e.g., Swarm(15))
```
### Customizing Drone Properties
```matlab
% Inside Drone.m constructor
obj = Drone(i, obj.DEFAULT_VELOCITY, direction_angle, obj.DEFAULT_FIELD_OF_VIEW, obj.DEFAULT_VIEW_DISTANCE);
```

You can modify the default values for velocity, direction angle, field of view, and view distance.
