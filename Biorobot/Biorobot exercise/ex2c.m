%View and select audio device
d = daq.getDevices;
%dev_inとdev_outを定義しよう
dev_in = d(2);
dev_ou = d(4);

%Create an input session
s = daq.createSession('directsound');
addAudioInputChannel(s, dev_in.ID, 1);
addAudioOutputChannel(s, dev_ou.ID, 1);
s.IsContinuous = true;
s.Rate = 8192; %For hallelujah
f_s = s.Rate;

%Setup graph display
hf = figure;
hp = plot(zeros(1000,1));
T = title('Discrete FFT Plot');
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
grid on;

% Queue the output example (Hallelujah)
load handel;
queueOutputData(s,0.1*repmat(y(1:4096),1,1));
    
%Add DataAvailable listener
DFFT = @(src, event) continuous_fft(event.Data, src.Rate, hp);
EMGtoEMS = @(src, event) wave_gen(src, event, f_s);
hl1 = addlistener(s, 'DataAvailable', DFFT);
hl2 = addlistener(s, 'DataRequired', EMGtoEMS);

%%ここにout_ampを初期値を0にて宣言する
assignin('base','out_amp',0)

%Start!
startBackground(s)

%% self-defined functions
function continuous_fft(data, Fs, plotHandle)
    % Calculate FFT(data) and update plot with it. 
    
    %%ここにパフォーマンスのいいFFTを組み込もう
    s = size(data);
    p = nextpow2(s(1));
    nextPowerOfTwo = 2^p;
    h = fft(data, nextPowerOfTwo);
    abs_h = abs(h);
    plotRange = abs_h;
    
    % 筋電は50~100Hzの範囲にあることが多いので、ローパスを掛ける
    %b = fir1(10, [50/(Fs/2) 100/(Fs/2)]); %Method1: ナイキスト=4000Hz 50Hz~100Hz  
    b = fir1(10, 100/4000, 'low'); %Method2: ナイキスト=4000Hz, ~100Hz
    Xf = filter(b, 1, abs_h); %
    
    %さらにローパス
    b2=[1 1 1 1 1 1 1 1 1 1]; %移動平均(Simple Moving Average)：ローパスフィルタ
    b2 = b2/length(b2); %正規化
    Xf_SMA = filter(b2,1,Xf);
    
    freqRange = (0:nextPowerOfTwo-1) * (Fs / nextPowerOfTwo);  % Frequency range
    gfreq = freqRange(1:plotRange);  % Only plotting upto n/2 (as other half is the mirror image)
    
    set(plotHandle, 'ydata', Xf_SMA(1:end/2), 'xdata', gfreq); % Updating the plot
    drawnow; % Update the plot
    
    %%ifをつかって，max(Xf_SMA)がある値を超えるとout_ampを１にする、その他の場合out_ampを0にする。音で切り替わるように値を決定する．
    max(Xf_SMA)
    if max(Xf_SMA) > 7
        out_amp = 1.0;
    else
        out_amp = 0.0;
    end
    out_amp
    % Modify output parameters
    assignin('base','out_amp',out_amp) %Take the amplitude @5Hz, and update f_ou in base workspace 
end

function wave_gen(src, event, f_s)
    %%read f_ou from workspace
    a = evalin('base', 'out_amp');
    duration = 0.1;
    speed= 30;
    t = 0:1/f_s:duration;  % signal evaluation time, サンプルレートは1/f_sとする。
    D = 0:1.0/speed:duration;          % pulse delay times
    w = 0.02;          % width of each pulse
    yp = a * square(10*(t-0.5) / pi) .* pulstran(t,D,@rectpuls,w);   % generate plustran vector

  %%課題1の内容とout_ampを関係させる

    queueOutputData(src,repmat(yp',1,1));
end