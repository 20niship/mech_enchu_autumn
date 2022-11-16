function [] = DrawManipulator( chain )

joint_pos = [];
for i=1:7
    joint_pos = [joint_pos, chain.link(i).abs_pos];
end

figure
plot3(joint_pos(1,:), joint_pos(2,:), joint_pos(3,:), 'linewidth', 3)
xlabel('X')
ylabel('Y')
zlabel('Z')
