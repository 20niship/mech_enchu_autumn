clear all
close all

% load the manipulator model
chain = CreateChain;

% initialize the joint angle
theta = [pi/7; -pi/7; -pi/7; pi/7; pi/7; pi/7; pi/7];

% calculate forward kinematics for the joint angle
[pos att chain] = ForwardKinematics(chain, theta);

% draw the robot
DrawFunction(chain)

zlim([-1.5 2]) % specify the z-axis range for the plot
title('Forward Kinematics');
xlabel('x [m]');
ylabel('y [m]');
zlabel('z [m]');