clear all
close all

chain = CreateChain;
qini  = [-pi; pi/3; -pi/4; pi/3; pi/7; 2*pi/5; pi/7];
[~,~,chain] = ForwardKinematics(chain, qini);
[~,~,chain] = ForwardKinematicsVelocity(chain, zeros(chain.linknum));
[~,~,chain] = ForwardKinematicsAcceleration(chain, zeros(chain.linknum));

% [end_pos, end_R, chain] = ForwardKinematics(chain, qini);
N = 200;
trajectory = zeros(3,N);
acc_lst = zeros(chain.linknum,N);
joint_torque = zeros(chain.linknum,N);
joint_angle_d = zeros(chain.linknum,N);
joint_vel_d   = zeros(chain.linknum,N);
joint_acc_d   = zeros(chain.linknum,N);

for i=1:200
    v = GetJointVelocity(chain);
    a = GetJointAngle(chain);
    Tf = [120 * v(1); 120*v(2); 120*v(3); 75*v(4); 75*v(5); 15*v(6); 7.5*v(7)];
    [acc, chain] = UnitVectorMethod(chain, a, v, -Tf);
    chain = SetJointAcceleration(acc, chain);
    [~, chain] = UpdateChain(chain,0.005);

    acc_lst(:,i) = acc;
    trajectory(:,i) = chain.link(chain.linknum+2).pos;
    joint_torque(:,i) = -Tf;
    joint_angle_d(:,i) = a;
    joint_vel_d(:,i)   = v;
    joint_acc_d(:,i)   = acc;

    if(i==1 || i==N || rem(i,10)==0)
        DrawFunction(chain);
        pause(0.01);
    end
end

load("fd_solution_check.mat")
n=norm(acc_lst- joints_acc_solution);
n

plot3(trajectory(1,1:i), trajectory(2,1:i), trajectory(3,1:i))
title('ID simulation');
zlim([-2.0 2.0])
xlabel('x');
ylabel('y');
zlabel('z');
hold off;

figure
subplot(211)
plot(joint_angle_d')
ylabel('Joint Angle [rad]')
subplot(413)
% figure
plot(joint_vel_d')
ylabel('Joint Angular Velocty [rad/s]')
subplot(414)
plot(joint_acc_d')
xlabel('time [sec]')
ylabel('Joint Angular Acceleration [rad/(s*s)]')

figure
plot(joint_torque')
xlabel('time [sec]')
ylabel('Joint Torque [Nm]')
