clear all;
Fs = 8000;
Mic = audioDeviceReader(Fs);
record = zeros(1);

while(true)
    audio = step(Mic);  % Micから入力読み込み
    record = vertcat(record, audio);  % recordに全記録を保存

%% 生波形描画
    subplot(3, 1, 1);
    t = (1:length(record))/Fs;
    plot(t, record);
    xlim([max(t)-10, max(t)]);  % 直近10sの範囲を表示
    title('生波形')
    myRecording = partvec(record, 10*Fs);
    xlabel('時間[s]');
    
    if length(myRecording) < Fs*2  % 計測時間が2s以下なら残りの解析をしない
       continue 
    end
%% スペクトログラム表示
    subplot(3, 1, 2)
    spectrogram(myRecording, 128, 120, 128, Fs, 'yaxis');
    colorbar('off');
    title('スペクトログラム')
%% fft表示
    subplot(3, 1, 3)
    Y = abs(fft(myRecording));
    L = length(myRecording);
    P2 = abs(Y/L);
    P1 = abs(P2(1:round(L/2)));
    f = Fs*(1:round(L/2))/L;  % 周波数軸の生成
    plot(f, P1)
    title('fft')
    xlabel('周波数[Hz]')
    
    drawnow limitrate nocallbacks  % 描画グラフをリアルタイムで更新
    
end

%% 時系列データの最後から長さLを切り出す関数
function vec_ = partvec(vec, L)
    if length(vec) > L
        vec_ = vec(end-L+1:end);
    else
        vec_ = vec;
    end
end
