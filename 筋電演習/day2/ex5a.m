%% ����filter �ړ����ρ@low pass
% �M������
t = linspace(0, 4*pi, 400);
x = sin(t) + 0.5*rand(size(t));
figure
plot(x)
hold on

% �T�C���g�ɏ���Ă���G������菜�����߂ɁC11�̃f�[�^���ړ�����
b = [1 1 1 1 1 1 1 1 1 1 1];
b = b/length(b);  % ���K��
plot(filter(b, 1, x))
title('low pass')
fvtool(b)  % �t�B���^�̓���������
% freqz(b)
