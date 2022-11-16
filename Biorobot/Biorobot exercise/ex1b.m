%信号の作成
f_s = 8192;               %Define frame rate

t = 0:1/f_s:10;  % signal evaluation time, サンプルレートは1/f_sとする。
D = 0:1:10;          % pulse delay times
w = 0.02;          % width of each pulse
yp = 0.8 * square(10*(t-0.5) / pi) .* pulstran(t,D,@rectpuls,w);   % generate plustran vector

plot(t,yp)
% ylim([-0.5 2])

xlabel('Time (s)')
ylabel('Waveform(V)')