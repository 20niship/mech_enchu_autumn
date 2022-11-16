% Rodrigues.m
% Last updated 2010.7.9
% author Taku Kashiwagi

function R = Rodrigues(a, theta)

theta = norm(a)*theta;
if norm(a) == 0
    R = eye(3);
    R
else
    wn= a/norm(a);
    w_dash = [0 -wn(3) wn(2); wn(3) 0 -wn(1); -wn(2) wn(1) 0];
    R = eye(3) + w_dash*sin(theta) + (w_dash^2)*(1-cos(theta));
    %R
end