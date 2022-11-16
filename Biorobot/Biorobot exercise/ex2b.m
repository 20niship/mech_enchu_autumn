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

%Start!
startBackground(s)

%% self-defined functions
function continuous_fft(data, Fs, plotHandle)
    % Calculate FFT(data) and update plot with it. 
    %%ここにパフォーマンスのいいFFTを組み込もう
    s = size(data);
    p = nextpow2(s(1));
    nextPowerOfTwo = 2^p;
    h = fft(data, nextPowerOfTwo); % Discrete Fourier Transform of data
    % h = yDFT(1:plotRange);
    abs_h = abs(h);
    plotRange = abs_h; %sh(1) / 2; % <--- ???
    
    freqRange = (0:nextPowerOfTwo-1) * (Fs / nextPowerOfTwo);  % Frequency range
    gfreq = freqRange(1:plotRange);  % Only plotting upto n/2 (as other half is the mirror image)
    
    set(plotHandle, 'ydata', abs_h(1:end/2), 'xdata', gfreq); % Updating the plot
    drawnow; % Update the plot
end

function wave_gen(src, ~, f_s)
    duration = 3;
    speed= 1.0;
    t = 0:1/f_s:duration;  % signal evaluation time, サンプルレートは1/f_sとする。
    D = 0:1.0/speed:duration;          % pulse delay times
    w = 0.02;          % width of each pulse
    yp = 0.8 * square(10*(t-0.5) / pi) .* pulstran(t,D,@rectpuls,w);   % generate plustran vector

    %Qeueu output data
    queueOutputData(src,0.8*repmat(yp',1,1));
end