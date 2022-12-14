vert = link(1).R*link(1).vertex;
for k = 1:3
    vert(k,:) = vert(k,:) + link(1).p(k);   % adding x,y,z to all vertex
end
color = [0.5 0.5 0.5];
newplot
h = patch('faces', chain.link(1).face', 'vertices', vert', 'FaceColor', color);   
axis equal
view(3)
xlim(AX); ylim(AY); zlim(AZ);
grid on
text(0.25, -0.25, 0.75, ['time=', num2str(time(n), '%5.3f')])
drawnow