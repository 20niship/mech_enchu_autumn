function [chain] = SetJointVelocity(joint_vel, chain)

for i=1:chain.linknum
    chain.link(i+1).qd = joint_vel(i);
end