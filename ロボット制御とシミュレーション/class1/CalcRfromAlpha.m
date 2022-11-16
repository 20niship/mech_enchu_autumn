% Calc R[3x3] from alpha_vec[3x1]
% alpha_vec = (alpha beta gamma)^T
% R=Rz(alpha)*Ry(beta)*Rz(gamma)
%
function [R] = CalcRfromAlpha(alpha_vec)

R = zeros(3,3);

cos_alpha = cos(alpha_vec(1,1));
cos_beta  = cos(alpha_vec(2,1));
cos_gamma = cos(alpha_vec(3,1));
sin_alpha = sin(alpha_vec(1,1));
sin_beta  = sin(alpha_vec(2,1));
sin_gamma = sin(alpha_vec(3,1));

R(1,1) = cos_alpha*cos_beta;
R(1,2) = cos_alpha*sin_beta*sin_gamma - sin_alpha*cos_gamma;
R(1,3) = cos_alpha*sin_beta*cos_gamma + sin_alpha*sin_gamma;
R(2,1) = sin_alpha*cos_beta;
R(2,2) = sin_alpha*sin_beta*sin_gamma + cos_alpha*cos_gamma;
R(2,3) = sin_alpha*sin_beta*cos_gamma - cos_alpha*sin_gamma;
R(3,1) = -sin_beta;
R(3,2) = cos_beta*sin_gamma;
R(3,3) = cos_beta*cos_gamma;

