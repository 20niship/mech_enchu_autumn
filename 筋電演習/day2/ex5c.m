close all;
clear all;

%% 心筋データの読み込み
load('record_heart.mat','record');
x = record;
Fs = 8000;  % サンプリング周波数
figure(1);
% subplot(211); plot(x);
% subplot(212); spectrogram(x, 128, 120, 128, Fs, 'yaxis');

%% Q1 適切なフィルタを設計し，ノイズを除去したfxを作ろう！
% dl = designfilt();
% fvtool(dl)
% fx = filter(dl, x);
% または，
b = fir1(50, 2*1.5/4000, "LOW");
% freqz(b);
% fx = filter(b, 1, x);

Fs = 8000;  % サンプリング周波数
% b = 1;
fx = filter(b, 1, x);
% figure(2);
% freqz(b);

%% フィルター前後の波形の表示
figure(3);
subplot(311)
plot(x);
hold on;
plot(fx);

%% Q2 心拍のタイミングを検出しよう！
% （ヒント１）閾値処理に便利な関数：find (e.g., k = find(x>0))
% （ヒント２）ピークを検出する関数：findpeaks, islocalmin, islocalmax
% 　　　　　　　　　'MinSeparation'は便利なパラメータなので利用しよう．
tpeak = find(islocalmin(fx, 'MinSeparation', 5000));
plot(tpeak, fx(tpeak), 'o');

%% Q3 心拍数の変動を表示しよう！
% 心拍タイミングの差分から心拍間隔を算出し，その逆数をとった後，
% 1分あたりの心拍数 (dout) を算出する．
% ただし単に，plot(1./(diff(tpeak)/Fs)*60)とすると，
% 時間軸が等間隔ではないので，補完して等間隔に直す．
% （ヒント３）補完の関数：interp1
% （ヒント４）１秒間隔の時間軸: tout = 0:ceil(length(fx)/Fs);
subplot(312);
tout = 0:ceil(length(fx)/Fs);
% dout = zeros(length(tout), 1);  % この行はダミーなので消してください
% dout = interp1...(補完を完成させる)
A = 60./(diff(tpeak)/Fs);
X = tpeak(1:end-1)/Fs;
dout = interp1(X, A, tout, 'nearest');
plot(tout, dout);
% plot(tpeak(1:end-1), A);
ylabel('心拍数')
xlabel('時間, 秒')

%% スペクトルを表示
% interpするとNaNが含まれ，fftできないことがあるので，NaNを除く．
% NaNの除き方：x(isnan(x))=[];
subplot(313)
dout(isnan(dout)) = [];
if rem(length(dout), 2) == 1, dout = dout(1:end-1); end  % 偶数サンプル
Y = fft(dout);  % Yは複素数であることに注意
L = length(dout);
P = abs(Y/L);  % 両側スペクトルを計算
P = P(2:L/2+1)*2;  % 意味があるのはスペクトルの左半分 (片側スペクトル)
f = (1:(L/2))/L;  % 周波数の分解能はFs/L
plot(f, P)
xlabel('f (Hz)')
ylabel('|P1(f)|')
