% InverseKinematics.m
% This is a program of Inverse Kinematics Algorithm.
% Last updated 2010.7.16
% author Hirokazu Tanaka

function [joint_angle, chain, loop_num, err_norm, q_trajectory] = InverseKinematics(chain, des_pos, des_R)

ik_gain = 0.5;

q_trajectory = [];

% [ SECTION ] ADD =====
errs = [];

for k=1:30
    % save joint angle history
    q_trajectory = [q_trajectory, GetJointAngle(chain)]; 
    % calculate jacobian at current configuration
    J = CalcBasicJacobian(chain);

    % calculate error between desired configuration and current configuration
    error = CalcConfigError(des_pos, des_R, chain.link(chain.endeffector_id).pos, chain.link(chain.endeffector_id).R);   
    % for record of convergence
    err_norm = norm(error);

    % [ SECTION ] ADD =====
    errs = [errs err_norm];


    % if the error is sufficiently small, IK ends.
    if err_norm < 1E-6
        joint_angle = GetJointAngle(chain);
        loop_num = k;
        err_message = 'IK solved';
        q_trajectory = [q_trajectory, GetJointAngle(chain)]; 
        return
    end

   % TODO
   % delta_q = ik_gain*(J \ error);  % '\' means Gaussian elimination
   delta_q = ik_gain*(pinv(J) * error);

   %ik_gain = 0.31;
   %delta_q = ik_gain*(transpose(J) * error);



   % add delta_q to each joint angle
   tmp_angle = [];
   for j=2:chain.endeffector_id-1     % link(1) is the base link and link(9) is the end-effector
       tmp_angle = [tmp_angle; chain.link(j).q + delta_q(j-1)];
   end
   % update configuration
   [~, ~, chain] = ForwardKinematics(chain, tmp_angle);


% [ SECTION ] ADD =====
%plot(errs)
clf;
DrawFunction(chain);
pause(0.05);

end
joint_angle = GetJointAngle(chain);
q_trajectory = [q_trajectory, GetJointAngle(chain)]; 
loop_num = k;

