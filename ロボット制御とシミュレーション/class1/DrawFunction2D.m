% DrawFunction2D.m
% This function draws the manipulator from the 2 dimensional view.
% Last updated 2010.10.11
% author Seiya Hamano

function [] = DrawFunction2D(chain)

wdh=[0.4 0.4 0.5];
for j=1:chain.linknum+2

    chain.link(j).R=eye(3);
    chain.link(j).p=chain.link(j).pos;
    chain.link(j).a=chain.link(j).axis;
    chain.link(j).child=chain.link(j).child; 
    chain.link(j).mother=chain.link(j).mother; 
 
    chain.link(j).vertex = [
       wdh(1)*2.5/5 wdh(2)*2.5/5 0;
       wdh(1)*2.5/5 wdh(2)*2.5/5 0;
       wdh(1)*2.5/5 wdh(2)*2.5/5 0;
       wdh(1)*2.5/5 wdh(2)*2.5/5 0;
       0      0      wdh(3);
       0      wdh(2) wdh(3);
       wdh(1) wdh(2) wdh(3);
       wdh(1) 0      wdh(3);]';      

    for n=1:2
        chain.link(j).vertex(n,:) = chain.link(j).vertex(n,:) - wdh(n)/2;  % Œ´“_‚ğ’ê–Ê’†S‚Ö
    end

    chain.link(1).face = [
       1 2 3 4; 2 6 7 3; 4 3 7 8;
       1 5 8 4; 1 2 6 5; 5 6 7 8;
    ]'; 

end

%clf
cla

radius    = 0.03;
len       = 0.1;
joint_col = 0;

for j=1:chain.linknum+2
    if ~isempty(chain.link(j).vertex)
        vert = chain.link(j).R * -chain.link(j).vertex;
        for k = 1:3
            vert(k,:) = vert(k,:) + chain.link(j).p(k); % adding x,y,z to all vertex
        end
        DrawPolygon(vert, chain.link(j).face, 0);
    end
    
   hold on
    
    i = chain.link(j).mother;
    if i ~= 0
        Connect3D(chain.link(i).p, chain.link(j).p, 'k', 2);
    end
    DrawCylinder(chain.link(j).p, chain.link(j).R*chain.link(j).a, radius,len, joint_col);

    %    DrawAllJoints(Chain.link(j).sister);
end


%view(38,14)
axis equal
xlim([-1.5 1.5])
ylim([-1.5 1.5])
%zlim([-0.5 2])
grid on
