%DrawPolygon.m
%Last Updated 2011.09.09
%Original Author: unknown
%Modified by Kanade Kubota 

function DrawPolygon(vert, face,col)

%%%% flag if 1 MATLAB, if 0 Octave %%%%
flag = 1;

if nargin == 2
    color = [0.5 0.5 0.5];
    h = patch('faces', face', 'vertices', vert', 'FaceColor', color);
 else
    if size(face,2)~=0
    color = ones(size(face,2), 1)*col;
    else 
       color=[0.0 1.0 0.0];
    end

    if(flag)
        h = patch('Vertices', vert', 'Faces', face', 'FaceVertexCData', color, 'FaceColor', 'flat');
    else 
        if size(face,1) == 4
            MyPatch(vert',face',0.2);  
        end;
    end;
end     
