% calc Jacobian from BasicJacobian
% BasicJacobian:J_basic
% alpha_vec:eular angle , alpha_vec=(alpha beta gamma)^T
%
function [J] = CalcJacobianfromBasicJacobian(J_basic, alpha_vec)

K = zeros(6,6);

% K = E 0
%     0 K_zyx

K(1,1) = 1;
K(2,2) = 1;
K(3,3) = 1;
K(4,5) = -sin(alpha_vec(1,1));
K(4,6) = cos(alpha_vec(1,1)*sin(alpha_vec(2,1));
K(5,5) = cos(alpha_vec(1,1));
K(5,6) = sin(alpha_vec(1,1))*sin(alpha_vec(2,1));
K(6,4) = 1;
K(6,6) = cos(alpha_vec(2,1));

J = inv(K)*J_basic;