function [joint_vel] = GetJointVelocity(chain)

end_effector_id = chain.linknum + 1;
for i=2:end_effector_id
    joint_vel(i-1, 1) = chain.link(i).qd;
end