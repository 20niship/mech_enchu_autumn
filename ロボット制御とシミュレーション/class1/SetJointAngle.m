function [ret] = SetJointAngle(chain, joint_angle)

ret = chain;

for i=1:chain.linknum
        ret.link(i+1).q = joint_angle(i);
end
