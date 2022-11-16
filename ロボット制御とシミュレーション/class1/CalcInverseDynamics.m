function [ joint_torque ] = CalcInverseDynamics(chain)

% suppose that forward kinematics has been done.

inv_dynamics(1);

joint_torque = [];
for i=1:7
    joint_torque = [ joint_torque; link(i).torque ];
end