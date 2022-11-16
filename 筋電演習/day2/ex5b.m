%%
% �T���v���M���̍쐬
Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector
X = 5*sin(2*pi*50*t) + sin(2*pi*120*t);  % 50 Hz�A�U�� 5 �̐����g + 120 Hz�A�U�� 1 �̐����g

% �T���v���M���̕`��
subplot(211); 
plot(1000*t, X, 'b'); hold on; 
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('t (milliseconds)')
ylabel('X(t)')

% FFT�̌v�Z
Y = fft(X);  % Y�͕��f���ł��邱�Ƃɒ���
P = abs(Y/L);  % �����X�y�N�g�����v�Z
P = P(1:L/2+1)*2;  % �Ӗ�������̂̓X�y�N�g���̍����� (�Б��X�y�N�g��)
f = (0:(L/2))*Fs/L;  % ���g���̕���\��Fs/L
subplot(212);
plot(f, P, 'b'); hold on;
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%% Matlab�֐��ɂ��t�B���^�݌v
b = fir1(1, [0.01 0.99]);  % ���g����fir1�ɂ��݌v�i�C�L�X�g���g���ŋK�i������Ă��邱�Ƃɒ���
Xf = filter(b, 1, X);

% designfilt�ɂ��݌v
% dl = designfilt() 
% Xf = filter(dl, X);

subplot(211); 
plot(Xf, 'r')
subplot(212);
Y = fft(Xf);  % Y�͕��f���ł��邱�Ƃɒ���
PF = abs(Y/L);  % �����X�y�N�g�����v�Z
PF = PF(1:L/2+1)*2;  % �Ӗ�������̂̓X�y�N�g���̍����� (�Б��X�y�N�g��)
plot(f, PF, 'r'); 

fvtool(b, 1)  % fir1�̏ꍇ
% fvtool(dl)  % designfilt�̏ꍇ
