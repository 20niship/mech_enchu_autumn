% See Matlab documantation at 
% https://jp.mathworks.com/help/matlab/ref/fft.html

%%
% �T���v���M���̍쐬
Fs = 10000;                % Sampling frequency                    
T = 1/Fs;                  % Sampling period       
L = 150;                   % Length of signal
t = (0:L-1)*T;             % Time vector
S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);  % 50 Hz�A�U�� 0.7 �̐����g + 120 Hz�A�U�� 1 �̐����g
% S = 0.7*sin(2*pi*600*t);   % 600 Hz�A�U�� 0.7 �̐����g
X = S + 2*randn(size(t));  % ���ϒl 0�A���U 4 �̃z���C�g�m�C�Y��S�ɍ�����

% X = sin(2*pi*400*t) + 2*randn(size(t));  % ���ϒl 0�A���U 4 �̃z���C�g�m�C�Y��S�ɍ�����
% X = sin(2*pi*600*t) + 2*randn(size(t));  % ���ϒl 0�A���U 4 �̃z���C�g�m�C�Y��S�ɍ�����

% �T���v���M���̕`��
subplot(411); 
plot(1000*t, S)
title('Clean Signal')
xlabel('t (milliseconds)')
ylabel('X(t)')

subplot(412); 
plot(1000*t, X)
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('t (milliseconds)')
ylabel('X(t)')

%%
% FFT�̌v�Z
Y = fft(X);  % Y�͕��f���ł��邱�Ƃɒ���
P = abs(Y/L);  % �����X�y�N�g�����v�Z
subplot(413);
f = (0:L-1)*Fs/L;  % ���g���̕���\��Fs/L
plot(f, P);  % �����X�y�N�g���͍��E�Ώ̂ł��邱�Ƃɒ���
xlabel('f (Hz)')
ylabel('|P1(f)|')

P = P(1:L/2+1)*2;  % �Ӗ�������̂̓X�y�N�g���̍����� (�Б��X�y�N�g��)
f = (0:(L/2))*Fs/L;  % ���g���̕���\��Fs/L
subplot(414);
plot(f, P);
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
