%% セッティング
% 音楽CDなどでは、一般に以下のサンプリング周波数が利用される。
% これは、ナイキスト周波数をヒトの可聴域の上限(約22kHz)に合わせるためである。
fs = 44100;

rec_time = 5;                   % [s] この秒数だけ音声ファイルを作成
t = 0:1/fs:rec_time;            % 作成する音声データの横軸に対応
f = 1000;                       % 作成する音声の周波数
amplitude = 0.01;               % 作成した音の音量の調整
y = amplitude .* sin(2*pi*f*t); % サイン波の計算

%% 音を流す
% 自分の耳で聞いて確かめる場合は、音の大きさに注意すること。

% soundで再生すると、yがそのまま再生される。
% soundscで再生すると、yが[-1,1]に自動で調整されるので、
% 音声を流すのに必要なamplitudeを無視できる。
% ただし、音圧レベル(dB)が一緒になるわけではないので、
% 周波数によっては、音がとても大きくなる可能性がある。

% sound(y, fs);    
soundsc(y, fs); 

%% 音を保存する
filename = '1kHz.wav';
audiowrite(filename, y, fs);
