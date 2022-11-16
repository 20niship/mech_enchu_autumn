%% 手作りfilter 移動平均　low pass
% 信号生成
t = linspace(0, 4*pi, 400);
x = sin(t) + 0.5*rand(size(t));
figure
plot(x)
hold on

% サイン波に乗っている雑音を取り除くために，11個のデータを移動平均
b = [1 1 1 1 1 1 1 1 1 1 1];
b = b/length(b);  % 正規化
plot(filter(b, 1, x))
title('low pass')
fvtool(b)  % フィルタの特性を可視化
% freqz(b)
