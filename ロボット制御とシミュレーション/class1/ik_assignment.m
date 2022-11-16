% id_sample.m
% This is a test program for ID using computed torque control.
% Last updated 2010.10.11
% author Hirokazu Tanaka

clear all
close all


chain = CreateChain;

% set initial state
joints     = [-pi; pi/3; -pi/4; pi/3; pi/7; 2*pi/5; pi/7];
[end_pos, end_R, chain] = ForwardKinematics(chain, joints);

p_d = [-0.4687; -1.072; 1.063];
R_d = [
    0.6506 -0.6383 -0.4114; 
    0.5977 0.7646 -0.2411;
    0.4684 -0.0890 0.8790;
];

[joint_angle, chain, loop_num, err_norm, q_trajectory] = InverseKinematics(chain, p_d, R_d);

