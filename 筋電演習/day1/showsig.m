clear all;
Fs = 16000;  % サンプリング周波数（Hz）
RNG = 2;  % 表示する時間（秒）
Mic = audioDeviceReader(Fs);  % サンプリング周波数Fsで，1024個のデータを取得．
record = zeros(1);

while(true)
    audio = step(Mic);  % Micから入力読み込み
    record = vertcat(record, audio);  % recordに全記録を保存
    peak2peak = max(audio) - min(audio);

%% 生波形描画    
    t = (1:length(record))/Fs;
    plot(t, record);
    xlim([max(t)-RNG, max(t)]);  % 直近RNG秒の範囲を表示
    % myRecording = partvec(record, 10*Fs);  % 直近10秒の切り出し
    xlabel('時間[s]');
    title(num2str(peak2peak));  % 振幅
    drawnow limitrate nocallbacks  % 描画グラフをリアルタイムで更新
    if length(record) > Fs*6000  % 60秒で終了
        break;
    end
end

%% 時系列データの最後から長さLを切り出す関数
function vec_ = partvec(vec, L)
    if length(vec) > L
        vec_ = vec(end-L+1:end);
    else
        vec_ = vec;
    end
end
