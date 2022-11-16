function [joint_angle] = GetJointAngle(chain)

end_effector_id = chain.linknum + 1;
for i=2:end_effector_id
    joint_angle(i-1, 1) = chain.link(i).q;
end