function SetupRigidBody(j, shape, com)
% shape: dimension [x y z], org: origin [x0 y0 z0]
global link

vert = [
   0      0      0;
   0      shape(2) 0;
   shape(1) shape(2) 0;
   shape(1) 0      0;
   0      0      shape(3);
   0      shape(2) shape(3);
   shape(1) shape(2) shape(3);
   shape(1) 0      shape(3);
]';

%　原点移動
vert(1,:) = vert(1,:) -shape(1)/2 + com(1);
vert(2,:) = vert(2,:) -shape(2)/2 + com(2);
vert(3,:) = vert(3,:) -shape(3)/2 + com(3);

face = [
   1 2 3 4;
   2 6 7 3;
   4 3 7 8;
   1 5 8 4;
   1 2 6 5;
   5 6 7 8;
]';

link(j).vertex = vert;
link(j).face   = face;
link(j).c      = com;
link(j).I = [1/12*(shape(2)^2 + shape(3)^2) 0 0;...
            0 1/12*(shape(1)^2 + shape(3)^2)  0;...
            0 0 1/12*(shape(2)^2 + shape(3)^2)] * link(j).m; % 慣性テンソル
