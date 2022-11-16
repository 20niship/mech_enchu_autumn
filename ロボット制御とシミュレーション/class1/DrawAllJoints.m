function DrawAllJoints(j)
global link
radius    = 0.03;
len       = 0.1;
joint_col = 0;

if j ~= 0  
    if ~isempty(link(j).vertex)
        vert = link(j).R * -link(j).vertex;
        for k = 1:3
            vert(k,:) = vert(k,:) + link(j).p(k); % adding x,y,z to all vertex
        end
        DrawPolygon(vert, link(j).face,0);
    end
    
   hold on
    
    i = link(j).mother;
    if i ~= 0
        Connect3D(link(i).p,link(j).p,'k',2);
    end
    DrawCylinder(link(j).p, link(j).R * link(j).a, radius,len, joint_col);
    
    
    DrawAllJoints(link(j).child);
%    DrawAllJoints(Chain.link(j).sister);
end
