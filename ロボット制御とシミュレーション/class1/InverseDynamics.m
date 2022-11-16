% InverseDynamics.m
% This is a program of Newton-Euler Algorithm.
% Last updated 2010.9.1
% author Hirokazu Tanaka
% debugger Jun Hashimoto

function [joint_torque, chain] = InverseDynamics(chain, joint_angle, joint_vel, joint_acc)

joint_torque = [];

% set gravity acceleration  pp.126 ----------------------------------------
chain.link(1).acc(3) = 9.8; % - -> +
%---------------------------------------------------------------------------

% forward kinematics [ base link -> end-effector ]-------------------------
[end_pos, end_R, chain]     = ForwardKinematics(chain, joint_angle);
[end_vel, end_a_vel, chain] = ForwardKinematicsVelocity(chain, joint_vel);
[end_acc, end_a_acc, chain] = ForwardKinematicsAcceleration(chain, joint_acc);
%---------------------------------------------------------------------------

% force and moment calculation [ end-effector -> base link ]---------------

% external force and moment at the end-effector is zero.
chain.link(chain.linknum+2).force = zeros(3,1);
chain.link(chain.linknum+2).moment = zeros(3,1);

for i=1:chain.linknum+1 %linknum->linknum+1
    j = chain.linknum - i + 2;  % link number [ end-effector -> base link ] % - i + 2 -> - i + "3"
    % inertia force (3.3.73)
    chain.link(j).inertia_force = chain.link(j).mass*chain.link(j).cog_acc;
    % inertia moment (3.3.74)
    I = chain.link(j).R*chain.link(j).I*chain.link(j).R'; % coordinate change of inertia matirx
    chain.link(j).inertia_moment = I*chain.link(j).ang_acc +...
        cross(chain.link(j).ang_vel, I*chain.link(j).ang_vel);
    
    % joint force  (3.3.75)
    if i==1
        chain.link(j).force = chain.link(j).inertia_force;
    else
        chain.link(j).force = chain.link(j+1).force + chain.link(j).inertia_force;
    end

    %joint torque  (3.3.76)
    if i==1
        chain.link(j).moment = chain.link(j).inertia_moment +...
            cross(chain.link(j).R*chain.link(j).rel_cog,chain.link(j).inertia_force);
    else
        chain.link(j).moment = chain.link(j).inertia_moment + chain.link(j+1).moment+...
            cross(chain.link(j).R*chain.link(j).rel_cog,chain.link(j).force)-...
            cross(chain.link(j).R*(chain.link(j).rel_cog-chain.link(j+1).rel_pos),chain.link(j+1).force);
    end
end

for j=2:chain.linknum+1; % +1->+2
    joint_torque = [joint_torque; (chain.link(j).R*chain.link(j).axis)'*chain.link(j).moment];
end

% cancel gravity acceleration
chain.link(1).acc(3) = 0;
