%MyPatch.m
%Last Updated 2011.09.9
%Author Kanade Kubota 

function []=MyPatch(vertex, index, color)

% vertex=[0 0 0; 1 0 0; 1 0 1; 0 0 1; 0 1 0; 1 1 0; 1 1 1; 0 1 1];
% index = [1 2 3 4; 5 6 7 8; 1 4 8 5];
% color = 0.2;
if size(vertex,2)~=3
    fprintf('err at MyPatch\n')
    return;
elseif size(index,2)~=4
    fprintf('err at MyPatch. sI= (%d %d) \n',sI(1),sI(2));
    return;
end;

for i=1:size(index,1)
    V1=vertex(index(i,1),:);
    V2=vertex(index(i,2),:);
    V3=vertex(index(i,3),:);
    V4=vertex(index(i,4),:);
    X=[V1(1),V2(1);V4(1),V3(1)];
    Y=[V1(2),V2(2);V4(2),V3(2)];
    Z=[V1(3),V2(3);V4(3),V3(3)];
    C=[color,color;color,color];
    surf(X,Y,Z,C)
    hold on;
end;














    
               



