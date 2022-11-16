function CalcHomoTransMat(chain)

for i=1:7
    %Humanoid Robot eq(2.55)
    rel_att = Rodorigues(link(i+1).axis, link(i+1).q);    
    rel_T(1:3, 1:3) = rel_R;
    rel_T(1:3, 4) = chain.link(i+1).rel_pos;
    rel_T(4, 1:3) = zeros(1, 3);
    rel_T(4, 4) = 1;
    
    chain.link(i+1).T = chain.link(i).T * rel_T;
end