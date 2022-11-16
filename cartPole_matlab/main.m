%Main.m
%main program
%author Jun Hashimoto

clear all
close all

%%%% flag if 1 MATLAB, if 0 Octave %%%%
flag = 1;

if(flag ==0)
    [desc, pkg_flag] = pkg('describe', 'oct2mat');
    if( ~strcmp(char(pkg_flag(1,1)), 'Not installed') )
        pkg unload oct2mat
    end
    disp 'running ...'
    fflush(stdout);
end

%%%%%%%%%%%%%%%%%%%%%
%Basic Parameters
%%%%%%%%%%%%%%%%%%%%%
m_w= 48.2e-3; %Mass of wheels[kg]
m_b= 0.275; %Mass of whole body without wheels[kg]
r_w= 28.5e-3; %Radius of wheels [m]
I_w= 2.25e-5; %Moment of inertia of wheels around axis [kg*m*m]
d_phi=0.0001;                                          %friction coefficient
d_theta=0.0000002;                                     %friction coefficient
I_b= 4.36e-4;%Moment of inertia of body around COG [kg*m*m]
l_Cb=45.4e-3;
g=9.8;                                         %acceleration due to gravity[kg*m/s]

%Initial value of theta,phi
theta_0=0.0;
theta_dot_0=0;
phi_0=0;
phi_dot_0=0;

%Desired value of theta,phi
theta_d=0.0;
y_goal = 0.1;   % 0.1m forward
phi_d = y_goal / r_w;

theta_dot_d=0;
phi_dot_d=0;

%Max value of input torque
torque_max = 0.04408*1.7*2; 

%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%
%parameter arranging
%%%%%%%%%%%%%%%%%%%%%
a=(m_b+m_w)*r_w*r_w+I_w;
b=m_b*r_w*l_Cb;
c=m_b*l_Cb*l_Cb+I_b;
u=m_b*g*l_Cb;


%%%%%%%%%%%%%%%%%%%%%%%%%%%

%definition of matrix A,B,C,D
% Form of the state is x=[theta,phi,theta_dot,phi_dot]'a
E = [
    1 0 0 0;
    0 1 0 0;
    0 0 a+2*b+c a+b;
    0 0 a+b a];
A0 = [
0 0 1 0;
0 0 0 1;
u 0 -d_theta 0;
0 0 0 -d_phi
];
B0 = [0;0;0;1];
A= E \ A0;
B= E \ B0;
C= [0 1 0 0;
    0 0 1 0;];
D= [0;0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculation of feedback gain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%LQR
Q = diag([1 1 1 1])*0.01;
R = 1000;
N=0;
sys = ss(A,B,C,D);
sysd = c2d(sys, 0.001); %離散化
F=lqr(A,B,Q,R, N);
% p = [-100 -50 -5 -1];
% F = place(A,B,p);
Fmemo


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

A_M = sysd.A-sysd.B*F;
B_M = sysd.B*F;
C_M = diag([1,1,1,1]);
D_M = zeros(4,4);
P_M = ss(A_M, B_M, C_M, D_M, 0.001); 

%initial value
x0_origin=[theta_0;phi_0;theta_dot_0;phi_dot_0];

%time range
t=0.0:0.001:5.0;

ref = zeros(4, length(t));
ref(1,:) = theta_d;
ref(2,:) = phi_d;
ref(3,:) = theta_dot_d;
ref(4,:) = phi_dot_d;

if(flag)
    %MATLAB
    [y,t,x] = lsim(P_M, ref, t, x0_origin);
else
    %Octave
    [y,x] = lsim(P_M, ref', t, x0_origin);
    y = y';
	x = x';
end

% animation
figure(1);
for i=1:length(t)/50
    base_x = r_w*(x(i*50,1)+x(i*50,2));
    base_y = r_w;
    top_x = base_x + 0.15*sin(x(i*50,1)); 
    top_y = base_y + 0.15*cos(x(i*50,1));
    x_axis = [base_x top_x];
    y_axis = [base_y top_y];
    plot(x_axis, y_axis)
    hold on
    tmp_phi = linspace( 0, 2*pi, 90 );
    wheel_x = base_x + r_w*cos(tmp_phi);
    wheel_y = base_y + r_w*sin(tmp_phi);
    plot(wheel_x, wheel_y,'r')
    hold on
    plot([y_goal, y_goal], [0, 0.2], 'k')
    if(flag)
        %MATLAB
        axis equal
    else
        %Octave
        axis square
    end
    xlim([-0.2, 0.2]);
    ylim([0, 0.2]);
    xlabel('position (m)');
    ylabel('height (m)');
    pause(0.1)
    hold off
end

figure(2)
subplot(211)
plot(t, y);
hold on
plot(t,ref(2,:)','g:')
hold off
legend('\theta', '\phi', '\omega_{\theta}', '\omega_{\phi}','\phi ref');
xlabel('time (s)');
ylabel('angle[rad]/angular velocity[rad/s]');
subplot(212)
plot(t, F*(ref-x(:,[1:4])'), '--b')
hold on
tau_limit = ones(size(t))*torque_max;
plot(t, tau_limit, 'r:')
plot(t, -tau_limit, 'r:')
hold off
legend('\tau','\tau limit');
xlabel('time (s)');
ylabel('torque[Nm]');


if(max(abs(F*(ref-x(:,[1:4])'))) > torque_max)
    sprintf('input torque over')
end
