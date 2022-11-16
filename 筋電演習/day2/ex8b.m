function ex8b(coef)
% coefは，ex8aで作った重み
% pred = glmval(coef, fout', 'logit');
% が大きければ/a/，小さければ/i/．
% エラー: audioDeviceReader/setup
% となったら，clearしてください

Fs = 8000;
Mic = audioDeviceReader('SampleRate', Fs);
delete(findobj(gcf, 'Type', 'Axes'))

while 1
    audio = step(Mic);  % Micから入力読み込み
    
    %% 生波形描画
    t = (1:length(audio))/Fs;
    subplot(211);
    plot(t, audio);
    xlim([0, max(t)]);  % 直近1sの範囲を表示
    xlabel('時間[s]');
    
    %% FFT
    subplot(223);
    fout = abs(fft(audio));
    fout = fout(1:length(fout)/2+1);
    findpeaks(fout, 'MinPeakDistance', 10);
    %fout(1:10) = 0;  % 識別時に使わない部分を除外（この例では低周波数データ）
    % ソートしてFFTのピークを抽出
    [pks, locs] = findpeaks(fout, 'SortStr', 'descend', 'MinPeakDistance', 10);
    xlim([0, length(fout)/2]);
    ylim([0, 20]);
    
    pred = glmval(coef, fout', 'logit');

    feature_x = pks(1);  % 特徴量1を設計
    feature_y = pred;  % 特徴量2を設計
    subplot(224); hold on;
    %xlim([0, 10]);
    %ylim([0, 1]);

    if feature_x<0 & feature_y<0
        title('a');  % 特徴量に基づく分類条件
        plot(feature_x, feature_y, '.b');
    elseif feature_x<0 & feature_y > 0
        title('i');
        plot(feature_x, feature_y, '.r');
    else
        title('s');
        plot(feature_x, feature_y, '.k');
    end
    
    drawnow;  % 描画グラフをリアルタイムで更新
    if strcmp(get(gcf, 'currentcharacter'), 'q')  % qおしたら終わり(break)
        set(gcf, 'currentcharacter', '0');
        break
    end
end
