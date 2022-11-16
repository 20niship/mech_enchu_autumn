% CalcLinInertiaMatrix.m
% This is used for calculation of link inertia matrix in CreateChain.
% m:[input] mass of link
% axis:[input] height direction of a cylinder
% r:[input] radius of link
% h:[input] height of link
% I:[output] inertia matrix around cog
% Last update 10.07.11
% Author Hirokazu Tanaka

function [I] = CalcLinkInertiaMatrix(m, axis, r, h)

% assume that all joints can be approximated as a cylinder.
I = zeros(3,3);
switch axis
    case 'x',
        I(1,1) = m*r*r/2;
        I(2,2) = m*(r*r/4 + h*h/12);
        I(3,3) = m*(r*r/4 + h*h/12);
    case 'y',
        I(1,1) = m*(r*r/4 + h*h/12);
        I(2,2) = m*r*r/2;
        I(3,3) = m*(r*r/4 + h*h/12);
    case 'z',
        I(1,1) = m*(r*r/4 + h*h/12);
        I(2,2) = m*(r*r/4 + h*h/12);
        I(3,3) = m*r*r/2;
    otherwise,
        I = zeros(3, 3);
end

