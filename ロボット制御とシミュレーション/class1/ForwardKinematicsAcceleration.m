% ForwardKinematicsAcceleration.m
% checked by Jun Hashimoto
% Last Updated 2010.9.1

function [end_effector_acc, end_effector_ang_acc, chain] = ForwardKinematicsAcceleration(chain, joint_acc)

chain = SetJointAcceleration(joint_acc, chain);

e_z=[0 0 1]'; %constant vector

for i=1:chain.linknum+1 % chain.linknum->chain.linknum+1

    % origin of link coordinate systems
    chain.link(i+1).ang_acc = chain.link(i).ang_acc +...
        chain.link(i+1).R*(e_z*chain.link(i+1).qdd) +...
        cross(chain.link(i+1).ang_vel, chain.link(i+1).R*(e_z*chain.link(i+1).qd)); % (3.3.68) R,ang_vel‚Ìindex‚ði+1‚É•ÏX
    chain.link(i+1).acc = chain.link(i).acc +...
        cross(chain.link(i).ang_acc, chain.link(i).R*chain.link(i+1).rel_pos) +...
        cross(chain.link(i).ang_vel, cross( chain.link(i).ang_vel, chain.link(i).R*chain.link(i+1).rel_pos)); % (3.3.65)
    % acceleration of center of gravity
    chain.link(i+1).cog_acc = chain.link(i+1).acc +...
        cross(chain.link(i+1).ang_acc, chain.link(i+1).R * chain.link(i+1).rel_cog) +...
        cross(chain.link(i+1).ang_vel, cross( chain.link(i+1).ang_vel, chain.link(i+1).R * chain.link(i+1).rel_cog)); % (3.3.66)
end

end_effector_acc = chain.link(chain.endeffector_id).acc; % 8->chain.linknum+2
end_effector_ang_acc = chain.link(chain.endeffector_id).ang_acc;
