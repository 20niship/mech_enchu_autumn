% CalcBasicJacobian.m
% Last updated 2010.10.11
% author Jun Hashimoto

function [J_basic] = CalcBasicJacobian(chain)

J_basic = zeros(6, chain.linknum);

end_effector_id = chain.linknum + 2;
% calculate column vector of basic Jacobian ( link1 -> end effector )
for n=2:end_effector_id-1
    a_w = chain.link(n).R*chain.link(n).axis;                     % joint axis vector from world coordinate
    p   = chain.link(end_effector_id).pos - chain.link(n).pos;    % relative position vector from link(n) to link(7)
    J_basic(:, n-1) = [cross(a_w, p); a_w];                       % calcurate cols of J_basic
end



