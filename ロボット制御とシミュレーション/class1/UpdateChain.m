% UpdateChain.m
% This function updates chain state.
% Last updated 2010.10.11
% author Hirokazu Tanaka

function [end_effector_pos, chain] = UpdateChain(chain, time_step)

for i=1:chain.linknum+2

    chain.link(i).q = chain.link(i).q + time_step * chain.link(i).qd;
    chain.link(i).qd = chain.link(i).qd + time_step * chain.link(i).qdd;
end

joints = GetJointAngle(chain);
[end_effector_pos, end_effector_R, chain] = ForwardKinematics(chain, joints);
joints_vel = GetJointVelocity(chain);
[end_effector_vel, end_effector_ang_vel, chain] = ForwardKinematicsVelocity(chain, joints_vel );

