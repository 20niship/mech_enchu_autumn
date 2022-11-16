%%
% サンプル信号の作成
Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector
X = 5*sin(2*pi*50*t) + sin(2*pi*120*t);  % 50 Hz、振幅 5 の正弦波 + 120 Hz、振幅 1 の正弦波

% サンプル信号の描画
subplot(211); 
plot(1000*t, X, 'b'); hold on; 
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('t (milliseconds)')
ylabel('X(t)')

% FFTの計算
Y = fft(X);  % Yは複素数であることに注意
P = abs(Y/L);  % 両側スペクトルを計算
P = P(1:L/2+1)*2;  % 意味があるのはスペクトルの左半分 (片側スペクトル)
f = (0:(L/2))*Fs/L;  % 周波数の分解能はFs/L
subplot(212);
plot(f, P, 'b'); hold on;
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%% Matlab関数によるフィルタ設計
b = fir1(1, [0.01 0.99]);  % 周波数はfir1による設計ナイキスト周波数で規格化されていることに注意
Xf = filter(b, 1, X);

% designfiltによる設計
% dl = designfilt() 
% Xf = filter(dl, X);

subplot(211); 
plot(Xf, 'r')
subplot(212);
Y = fft(Xf);  % Yは複素数であることに注意
PF = abs(Y/L);  % 両側スペクトルを計算
PF = PF(1:L/2+1)*2;  % 意味があるのはスペクトルの左半分 (片側スペクトル)
plot(f, PF, 'r'); 

fvtool(b, 1)  % fir1の場合
% fvtool(dl)  % designfiltの場合
