clear all
close all

% load the manipulator model
chain = CreateChain;

% initialize the joint angle
start_theta = [0;0;0;0;0;0;0];
endtheta = [pi/7.; -pi/7.; -pi/7.; pi/7.; pi/7.; pi/7.; pi/7.];
% theta_list = linspace(0,pi/);

xe = [];

for c = 1:100
    clf;
    theta = endtheta * (c-1) / 99.;
    % theta = theta_list(c);
    [pos, att, chain] = ForwardKinematics(chain, theta);
    DrawFunction(chain);
    pause(0.01);
    p = [pos(1), pos(2), pos(3), att(1,1), att(1,2),att(1,3),att(2,2),att(2,3),att(3,3)];
    xe = [xe, p];
end

xe = reshape(xe, 9, 100);

load('fk_solution_check.mat')
gap = norm(xe - trajectory_solution);
gap
