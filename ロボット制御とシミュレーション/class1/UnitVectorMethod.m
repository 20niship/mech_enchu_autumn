% UnitVectorMethod.m
%unit vector method for Forward Dynamics
%Last Updated 2010/07/21
%programmed by Taku KASHIWAGI

function [joint_acc, chain] = UnitVectorMethod(chain, joint_angle, joint_vel, joint_torque);
% joint_acc: Joint Acceleration
DoF = chain.linknum; % 自由度 = 関節数 = ベースリンクを除いたリンクの数
[c, ~] = InverseDynamics(chain, joint_angle,joint_vel, zeros(DoF, 1));

M = zeros(DoF, DoF);
for i=1:DoF
    ei = zeros(DoF,1);
    ei(i) = 1.0;
    [ti,~] = InverseDynamics(chain, joint_angle, joint_vel, ei);
    M(:,i) = ti - c;
end
% joint_acc = M \ (joint_torque - c);
joint_acc = inv(M) * (joint_torque - c);
