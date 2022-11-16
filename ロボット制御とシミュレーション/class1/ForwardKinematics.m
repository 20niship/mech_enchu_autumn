% ForwardKinematics.m
% checked by Jun Hashimoto
% Last Updated 2010.11.1

function [end_effector_pos, end_effector_R, chain] = ForwardKinematics(chain, joint_angle)
    
chain = SetJointAngle(chain, joint_angle);

for i=1:chain.linknum+1
    chain.link(i+1).pos = chain.link(i).pos + chain.link(i).R * chain.link(i+1).rel_pos;
    chain.link(i+1).R =  chain.link(i).R * (chain.link(i+1).init_att * Rodrigues(chain.link(i+1).axis, chain.link(i+1).q));
end

%update center of gravity position
for i=1:chain.linknum+2
    chain.link(i).cog_pos = chain.link(i).pos+ chain.link(i).R * chain.link(i).rel_cog; %(2.2.17)
end

end_effector_pos = chain.link(chain.endeffector_id).pos;
end_effector_R = chain.link(chain.endeffector_id).R;

