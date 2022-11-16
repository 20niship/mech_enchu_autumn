function [chain] = SetJointAcceleration(joint_acc, chain)

for i=1:chain.linknum
    chain.link(i+1).qdd = joint_acc(i);
end