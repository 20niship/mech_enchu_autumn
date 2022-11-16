% ForwardKinematicsVelocity.m
% checked by Jun Hashimoto
% Last Updated 2010.9.1

function [end_effector_vel, end_effector_ang_vel, chain] = ForwardKinematicsVelocity(chain, joint_vel)

chain = SetJointVelocity(joint_vel, chain);

for i=1:chain.linknum+1 %linknum->linknum+1
    chain.link(i+1).ang_vel = chain.link(i).ang_vel + chain.link(i+1).R * (chain.link(i+1).axis * chain.link(i+1).qd);
    chain.link(i+1).vel = ...
            chain.link(i).vel + ...
            chain.link(i+1).R * chain.link(i+1).axis + ...
            cross(chain.link(i).ang_vel, chain.link(i+1).R * chain.link(i+1).rel_pos);
end

end_effector_vel = chain.link(chain.endeffector_id).vel; %linknum->linknum+2
end_effector_ang_vel = chain.link(chain.endeffector_id).ang_vel;