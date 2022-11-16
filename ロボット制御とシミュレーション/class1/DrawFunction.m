% DrawFunction.m
% Last updated 2010.7.11
% author Kohei Odanaka

function [] = DrawFunction( chain )

wdh=[0.4 0.4 0.5];
for j=1:chain.linknum+2

    chain.link(j).p = chain.link(j).pos;
    chain.link(j).a = chain.link(j).axis;
 
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

radius    = 0.03;
len       = 0.1;
joint_col = 0;
for j=1:chain.endeffector_id
    if ~isempty( chain.link(j).vertex )  
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
    DrawCylinder(chain.link(j).p, chain.link(j).R*chain.link(j).axis, radius,len, joint_col);
end

view(38,14)
axis square
xlim([-3.0 3.0])
ylim([-3.0 3.0])
zlim([-0.5 2])
grid on
