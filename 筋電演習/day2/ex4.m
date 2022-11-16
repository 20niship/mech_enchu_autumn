% See Matlab documantation at 
% https://jp.mathworks.com/help/matlab/ref/fft.html

%%
% サンプル信号の作成
Fs = 10000;                % Sampling frequency                    
T = 1/Fs;                  % Sampling period       
L = 150;                   % Length of signal
t = (0:L-1)*T;             % Time vector
S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);  % 50 Hz、振幅 0.7 の正弦波 + 120 Hz、振幅 1 の正弦波
% S = 0.7*sin(2*pi*600*t);   % 600 Hz、振幅 0.7 の正弦波
X = S + 2*randn(size(t));  % 平均値 0、分散 4 のホワイトノイズをSに混ぜる

% X = sin(2*pi*400*t) + 2*randn(size(t));  % 平均値 0、分散 4 のホワイトノイズをSに混ぜる
% X = sin(2*pi*600*t) + 2*randn(size(t));  % 平均値 0、分散 4 のホワイトノイズをSに混ぜる

% サンプル信号の描画
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
% FFTの計算
Y = fft(X);  % Yは複素数であることに注意
P = abs(Y/L);  % 両側スペクトルを計算
subplot(413);
f = (0:L-1)*Fs/L;  % 周波数の分解能はFs/L
plot(f, P);  % 両側スペクトルは左右対称であることに注意
xlabel('f (Hz)')
ylabel('|P1(f)|')

P = P(1:L/2+1)*2;  % 意味があるのはスペクトルの左半分 (片側スペクトル)
f = (0:(L/2))*Fs/L;  % 周波数の分解能はFs/L
subplot(414);
plot(f, P);
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
