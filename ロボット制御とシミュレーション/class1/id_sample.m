% id_sample.m
% This is a test program for ID using computed torque control.
% Last updated 2010.10.11
% author Hirokazu Tanaka

clear all
close all

%%%% flag if 1 MATLAB, if 0 Octave %%%%
flag = 1;

if(flag ==0)
    [desc, pkg_flag] = pkg('describe', 'oct2mat');
    if( ~strcmp(char(pkg_flag(1,1)), 'Not installed') )
        pkg unload oct2mat
    end
end

% load manipulator model
chain = CreateChain;

% set initial state
joints     = [0; 0; 0; 0; 0; 0; 0];
joints_vel = [0; 0; 0; 0; 0; 0; 0];
joints_acc = [0; 0; 0; 0; 0; 0; 0];
[end_pos, end_R, chain] = ForwardKinematics(chain, joints);
[end_vel, end_a_vel, chain] = ForwardKinematicsVelocity(chain, joints_vel);
[end_acc, end_a_acc, chain] = ForwardKinematicsAcceleration(chain, joints_acc);

T  = 5.0;    % simulation duration time[sec]
dt = 0.05;  % sampling interval [sec]
N  = round(T/dt); % number of simulation samples

trajectory = zeros(3,N);
joint_torque = zeros(chain.linknum,N);
t = zeros(1,N);

joint_angle_d = zeros(chain.linknum,N);
joint_vel_d   = zeros(chain.linknum,N);
joint_acc_d   = zeros(chain.linknum,N);

omega = 2*pi/T;

for i=1:N
    t = (i-1)*dt;
    joint_angle_d(:,i) = ((omega/T)*(t-sin(omega*t)/omega)/omega)*ones(chain.linknum,1);
    joint_vel_d(:,i)   = (omega/T)*(1-cos(omega*t))/omega*ones(chain.linknum,1);
    joint_acc_d(:,i)   = (omega/T)*sin(omega*t)*ones(chain.linknum,1);  % desired acceleration is sin wave
end


for i=1:N
    t(i) = (i-1)*dt;
    [joint_torque(:,i), chain] = InverseDynamics(chain, joint_angle_d(:,i), joint_vel_d(:,i), joint_acc_d(:,i));

    % endeffctor position for drawing
    trajectory(:,i)           = chain.link(chain.linknum+2).pos;
    
    % for drawing
    if(i==1 || i==N || rem(i,20)==0)
        DrawFunction(chain)
    end
end


load('id_solution_check.mat')
n = norm(joint_torque - joint_torque_solution);
n

plot3(trajectory(1,1:i), trajectory(2,1:i), trajectory(3,1:i))
zlim([-2.0 2.0])
title('ID simulation');
xlabel('x');
ylabel('y');
zlabel('z');
hold off;

figure
subplot(211)
plot(t,joint_angle_d')
ylabel('Joint Angle [rad]')
subplot(413)
% figure
plot(t,joint_vel_d')
ylabel('Joint Angular Velocty [rad/s]')
subplot(414)
plot(t,joint_acc_d')
xlabel('time [sec]')
ylabel('Joint Angular Acceleration [rad/(s*s)]')

figure
plot(t,joint_torque')
xlabel('time [sec]')
ylabel('Joint Torque [Nm]')


