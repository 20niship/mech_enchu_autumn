% CreateChain.m
% This is for generating manipulator model.
% All geometric and dynamical parameters are contained in the variable 'c'.
% last updated 10.10.11
% author Kohei Odanaka and Hirokazu Tanaka

function [c] = CreateChain()

% 7 DOF manipulator

% joint number
c.linknum = 7;
c.endeffector_id = c.linknum+2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% link description
%  [base] |  |   [link1] |  |   [link2] |  |   [link3] |  |   [link4] |  |   [link5] |  |   [link6] |  |   [link7] 
%         |  ^           |  ^           |  ^           |  ^           |  ^           |  ^           |  ^
%         | joint1       | joint2       | joint3       | joint4       | joint5       | joint6       | joint7
%Å@ id:1        id:2           id:3           id:4           id:5          id:6            id:7           id:8

% If a link does not have parent or child link, 
% its id is 0.

% from base link to link7
for i = 1:8
    c.link(i).id = i;
    c.link(i).mother = i-1;
    c.link(i).child = i+1;
end

% link(9):end-effector
c.link(9).id = 9;
c.link(9).mother = 8;
c.link(9).child = 0;      % end-effector has no child link.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geometric parameters

% link length
l1 = 0.8;           % [m]
l2 = 0.8;           % [m]
l3 = 0.8;           % [m]
d1 = 0.15;          % [m]
d2 = 0.15;          % [m]
d3 = 0.15;          % [m]
hand_length = 0.2;  % [m]

% base link (link0)
c.link(1).axis = [0; 0; 0];
c.link(1).rel_pos = [0; 0; 0];
c.link(1).init_att = [1 0 0;0 1 0;0 0 1];

% joint1 & link1
c.link(2).axis = [0; 0; 1];               % axis vector observed from current link. 3-dimensional column vector.
c.link(2).rel_pos = [0; 0; 0];            % relative position to parent link. described in parent link.Å@3-dimensional column vector.
c.link(2).init_att = [1 0 0;0 1 0;0 0 1]; % relative attitude to parent link when joint angle is 0.

% joint2 & link2
c.link(3).axis = [0; 0; 1];
c.link(3).rel_pos = [d1; 0; 0];
c.link(3).init_att = [1 0 0;0 1 0;0 0 1];

% joint3 & link3
c.link(4).axis = [0; 0; 1];
c.link(4).rel_pos = [l1; 0; 0];
c.link(4).init_att = [1 0 0;0 0 1;0 -1 0];

% joint4 & link4
c.link(5).axis = [0; 0; 1];
c.link(5).rel_pos = [l2; 0; 0];
c.link(5).init_att = [0 0 1;0 1 0;-1 0 0];

% joint5 & link5
c.link(6).axis = [0; 0; 1];
c.link(6).rel_pos = [0; 0; d2];
c.link(6).init_att = [0 0 -1;0 1 0;1 0 0];

% joint6 & link6
c.link(7).axis = [0; 0; 1];
c.link(7).rel_pos = [l3; 0; 0];
c.link(7).init_att = [0 0 1;0 1 0;-1 0 0];

% joint7 & link7
c.link(8).axis = [0; 0; 1];
c.link(8).rel_pos = [0; -d3; 0];
c.link(8).init_att = [1 0 0;0 0 -1;0 1 0];

% end-effector
c.link(9).axis = [0; 0; 1];
c.link(9).rel_pos = [0; hand_length; 0];
c.link(9).init_att = [0 -1 0;1 0 0;0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dynamic parameters

% mass
m1 = 30;       % [kg]
m2 = 30;       % [kg]
m3 = 25;       % [kg]
m4 = 15;       % [kg]
m5 = 25;       % [kg]
m6 = 15;       % [kg]
m7 = 10;       % [kg]

% radius
r1 = 0.15;     % [m]
r2 = 0.10;     % [m]
r3 = 0.08;     % [m]

% base link
c.link(1).mass = 100;                        % Mass of link [kg]
c.link(1).I = c.link(1).mass*eye(3);         % Inertia matrix of link. This is defined as relative value to its link coordination. [kg*m^2]
c.link(1).rel_cog = zeros(3,1);              % position of center of gravity. This is defined as relative value to its link coordination. [m]

% link1
c.link(2).mass = m1;
c.link(2).I = CalcLinkInertiaMatrix(m1, 'x', r1, d1);
c.link(2).rel_cog = [(d1)/2; 0; 0];

% link2
c.link(3).mass = m2;
c.link(3).I = CalcLinkInertiaMatrix(m2, 'x', r1, l1);
c.link(3).rel_cog = [(l1)/2; 0; 0];

% link3
c.link(4).mass = m3;
c.link(4).I = CalcLinkInertiaMatrix(m3, 'x', r2, l2);
c.link(4).rel_cog = [(l2)/2; 0; 0];

% link4
c.link(5).mass = m4;
c.link(5).I = CalcLinkInertiaMatrix(m4, 'z', r2, d2);
c.link(5).rel_cog = [0; 0; (d2)/2];

% link5
c.link(6).mass = m5;
c.link(6).I = CalcLinkInertiaMatrix(m5, 'x', r3, l3);
c.link(6).rel_cog = [(l3)/2; 0; 0];

% link6
c.link(7).mass = m6;
c.link(7).I = CalcLinkInertiaMatrix(m6, 'y', r3, d3);
c.link(7).rel_cog = [0; -(d3)/2; 0];

% link7
c.link(8).mass = m7;
c.link(8).I = CalcLinkInertiaMatrix(m7, 'y', r3, hand_length);
c.link(8).rel_cog = [0; hand_length/2; 0];

% end-effector
c.link(9).mass = 0;
c.link(9).I = zeros(3,3);
c.link(9).rel_cog = [0; 0; 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% joint angle

for i=1:9
    c.link(i).q   = 0;     % joint angle          [rad]
    c.link(i).qd  = 0;     % joint velocity       [rad/sec]
    c.link(i).qdd = 0;     % joint acceleration   [rad/sec^2]
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computational result of Forward Kinematics

for i=1:9
    c.link(i).pos     = zeros(3,1);     % absolute position observed from absolute coordinate system. 3-dimensional column vector [m]
    c.link(i).R       = eye(3);         % absolute attitude observed from absolute coordinate system. 3*3 matrix.
    c.link(i).cog_pos = zeros(3,1);     % absolute cog position observed from absolute coordinate system. 3-dimensional column vector [m]
    c.link(i).vel     = zeros(3,1);     % absolute velocity observed from absolute coordinate system. 3-dimensional column vector [m/s]
    c.link(i).ang_vel = zeros(3,1);     % absolute angular velocity observed from absolute coordinate system. 3-dimensional column vector [rad/s]
    c.link(i).cog_vel = zeros(3,1);     % absolute cog velocity observed from absolute coordinate system. 3-dimensional column vector [m/s]
    c.link(i).acc     = zeros(3,1);     % absolute acceleration observed from absolute coordinate system. 3-dimensional column vector [m/s^2]
    c.link(i).ang_acc = zeros(3,1);     % absolute angular acceleration observed from absolute coordinate system. 3-dimensional column vector [rad/s^2]
    c.link(i).cog_acc = zeros(3,1);     % absolute cog acceleration observed from absolute coordinate system. 3-dimensional column vector [m/s^2]
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computational result of Inverse Dynamics

for i=1:9
    c.link(i).force          = zeros(3,1);     % force applied to the link observed from absolute coordinate system. 3-dimensional column vector [N]
    c.link(i).moment         = zeros(3,1);     % moment applied to the cog observed from absolute coordinate system. 3-dimensional column vector [Nm]
    c.link(i).inertia_force  = zeros(3,1);     % inertia force observed from absolute coordinate system. 3-dimensional column vector [N]
    c.link(i).inertia_moment = zeros(3,1);     % inertia moment observed from absolute coordinate system. 3-dimensional column vector [Nm]
end
