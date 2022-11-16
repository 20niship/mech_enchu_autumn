function MakeRigidBody(j, wdh, mass)
%global link


link(j).m = mass;                                    % ����
link(j).c = [0 0 0]';                                % �d�S
link(j).I = [1/12*(wdh(2)^2 + wdh(3)^2) 0 0;...
            0 1/12*(wdh(1)^2 + wdh(3)^2)  0;...
            0 0 1/12*(wdh(2)^2 + wdh(3)^2)] * mass; % �����e���\��
link(j).vertex = [
   0      0      0;
   0      wdh(2) 0;
   wdh(1) wdh(2) 0;
   wdh(1) 0      0;
   0      0      wdh(3);
   0      wdh(2) wdh(3);
   wdh(1) wdh(2) wdh(3);
   wdh(1) 0      wdh(3);
]';                             % ���_���W
for n=1:3
    link(j).vertex(n,:) = link(j).vertex(n,:) - wdh(n)/2;  % ���_�𕨑̒��S��
end
link(1).face = [
   1 2 3 4; 2 6 7 3; 4 3 7 8;
   1 5 8 4; 1 2 6 5; 5 6 7 8;
]';                             % �|���S��
