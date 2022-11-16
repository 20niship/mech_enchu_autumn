% Calc alpha_vec[3x1] from R[3x3]
% alpha_vec = (alpha beta gamma)^T
% R=Rz(alpha)*Ry(beta)*Rz(gamma)
% pair:choose alpha...
% pair:0->alpha=atan2(r_21,r_11)
% pair:1->alpha=atan2(r_21,r_11)}pi

function [alpha_vec] = CalcAlphafromR(R, pair)

alpha_vec = zeros(3,1);

% if r_33=0 -> cannnot calcurate alpha_vec

if R(3,1) == 0
    fprintf( 'Cannot calcurate eular angle from R!!\n' );
elseif R(3,1) ~ =0
    if pair == 0
        alpha_vec(1,1) = atan2(R(2,1), R(1,1));
    elseif pair == 1
        if atan2(R(2,1), R(1,1)) > -2*pi && atan2(R(2,1), R(1,1)) <= 0
            alpha_vec(1,1) = atan2(R(2,1), R(1,1)) + pi;
        else
            alpha_vec(1,1) = atan2(R(2,1), R(1,1)) - pi;
        end
    else 
        alpha_vec(1,1) = atan2(R(2,1), R(1,1));
    end
    alpha_vec(2,1) = atan2(-R(3,1),...
        R(1,1)*cos(alpha_vec(1,1)) + R(2,1)*sin( alpha_vec(1,1)));
    alpha_vec(3,1) = atan2(R(1,3)*sin(alpha_vec(1,1)) - R(2,3)*cos(alpha_vec(1,1)),...
        -R(1,2)*sin(alpha_vec(1,1)) + R(2,2)*cos(alpha_vec(1,1)));
end