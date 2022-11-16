close all;
clear all;

%% �S�؃f�[�^�̓ǂݍ���
load('record_heart.mat','record');
x = record;
Fs = 8000;  % �T���v�����O���g��
figure(1);
% subplot(211); plot(x);
% subplot(212); spectrogram(x, 128, 120, 128, Fs, 'yaxis');

%% Q1 �K�؂ȃt�B���^��݌v���C�m�C�Y����������fx����낤�I
% dl = designfilt();
% fvtool(dl)
% fx = filter(dl, x);
% �܂��́C
b = fir1(50, 2*1.5/4000, "LOW");
% freqz(b);
% fx = filter(b, 1, x);

Fs = 8000;  % �T���v�����O���g��
% b = 1;
fx = filter(b, 1, x);
% figure(2);
% freqz(b);

%% �t�B���^�[�O��̔g�`�̕\��
figure(3);
subplot(311)
plot(x);
hold on;
plot(fx);

%% Q2 �S���̃^�C�~���O�����o���悤�I
% �i�q���g�P�j臒l�����ɕ֗��Ȋ֐��Ffind (e.g., k = find(x>0))
% �i�q���g�Q�j�s�[�N�����o����֐��Ffindpeaks, islocalmin, islocalmax
% �@�@�@�@�@�@�@�@�@'MinSeparation'�͕֗��ȃp�����[�^�Ȃ̂ŗ��p���悤�D
tpeak = find(islocalmin(fx, 'MinSeparation', 5000));
plot(tpeak, fx(tpeak), 'o');

%% Q3 �S�����̕ϓ���\�����悤�I
% �S���^�C�~���O�̍�������S���Ԋu���Z�o���C���̋t�����Ƃ�����C
% 1��������̐S���� (dout) ���Z�o����D
% �������P�ɁCplot(1./(diff(tpeak)/Fs)*60)�Ƃ���ƁC
% ���Ԏ������Ԋu�ł͂Ȃ��̂ŁC�⊮���ē��Ԋu�ɒ����D
% �i�q���g�R�j�⊮�̊֐��Finterp1
% �i�q���g�S�j�P�b�Ԋu�̎��Ԏ�: tout = 0:ceil(length(fx)/Fs);
subplot(312);
tout = 0:ceil(length(fx)/Fs);
% dout = zeros(length(tout), 1);  % ���̍s�̓_�~�[�Ȃ̂ŏ����Ă�������
% dout = interp1...(�⊮������������)
A = 60./(diff(tpeak)/Fs);
X = tpeak(1:end-1)/Fs;
dout = interp1(X, A, tout, 'nearest');
plot(tout, dout);
% plot(tpeak(1:end-1), A);
ylabel('�S����')
xlabel('����, �b')

%% �X�y�N�g����\��
% interp�����NaN���܂܂�Cfft�ł��Ȃ����Ƃ�����̂ŁCNaN�������D
% NaN�̏������Fx(isnan(x))=[];
subplot(313)
dout(isnan(dout)) = [];
if rem(length(dout), 2) == 1, dout = dout(1:end-1); end  % �����T���v��
Y = fft(dout);  % Y�͕��f���ł��邱�Ƃɒ���
L = length(dout);
P = abs(Y/L);  % �����X�y�N�g�����v�Z
P = P(2:L/2+1)*2;  % �Ӗ�������̂̓X�y�N�g���̍����� (�Б��X�y�N�g��)
f = (1:(L/2))/L;  % ���g���̕���\��Fs/L
plot(f, P)
xlabel('f (Hz)')
ylabel('|P1(f)|')
