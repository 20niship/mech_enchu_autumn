% CalcConfigError.m
% This function calculates position and attitude error.
% 
% Last updated 2010.10.11
% author Hirokazu Tanaka

function [config_error] = CalcConfigError(des_pos, des_R, cur_pos, cur_R)

% calculate position error
pos_error = des_pos - cur_pos;

% calculate attitude error
% Ritude error is represented as an axis and a rotation angle
% which generate the rigid motion from cur_R to des_R

% calculate error of attitude matrix
R_error = (cur_R^-1)*des_R;
% RobotMotion pp.33 [property6]
theta = acos((trace(R_error) - 1)/2);  % pp.34, eq.(2.1.23)
if theta == 0
    w_error = [0; 0; 0];  % the case in which cur_R is equivalent to des_R
else
    w_error = (theta/(2*sin(theta)))*[R_error(3,2) - R_error(2,3); ...
                                      R_error(1,3) - R_error(3,1); ...
                                      R_error(2,1) - R_error(1,2)];  % pp.33, eq.(2.1.15) and rotation angle theta
    w_error = cur_R*w_error;
end

config_error = [pos_error; w_error];