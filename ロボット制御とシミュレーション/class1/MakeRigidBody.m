function MakeRigidBody(j, wdh, mass)
%global link


link(j).m = mass;                                    % 質量
link(j).c = [0 0 0]';                                % 重心
link(j).I = [1/12*(wdh(2)^2 + wdh(3)^2) 0 0;...
            0 1/12*(wdh(1)^2 + wdh(3)^2)  0;...
            0 0 1/12*(wdh(2)^2 + wdh(3)^2)] * mass; % 慣性テンソル
link(j).vertex = [
   0      0      0;
   0      wdh(2) 0;
   wdh(1) wdh(2) 0;
   wdh(1) 0      0;
   0      0      wdh(3);
   0      wdh(2) wdh(3);
   wdh(1) wdh(2) wdh(3);
   wdh(1) 0      wdh(3);
]';                             % 頂点座標
for n=1:3
    link(j).vertex(n,:) = link(j).vertex(n,:) - wdh(n)/2;  % 原点を物体中心へ
end
link(1).face = [
   1 2 3 4; 2 6 7 3; 4 3 7 8;
   1 5 8 4; 1 2 6 5; 5 6 7 8;
]';                             % ポリゴン
