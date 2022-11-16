%View and select audio device
d = daq.getDevices;
%dev_in��dev_out���`���悤
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

%%������out_amp�������l��0�ɂĐ錾����
assignin('base','out_amp',0)

%Start!
startBackground(s)

%% self-defined functions
function continuous_fft(data, Fs, plotHandle)
    % Calculate FFT(data) and update plot with it. 
    
    %%�����Ƀp�t�H�[�}���X�̂���FFT��g�ݍ�����
    s = size(data);
    p = nextpow2(s(1));
    nextPowerOfTwo = 2^p;
    h = fft(data, nextPowerOfTwo);
    abs_h = abs(h);
    plotRange = abs_h;
    
    % �ؓd��50~100Hz�͈̔͂ɂ��邱�Ƃ������̂ŁA���[�p�X���|����
    %b = fir1(10, [50/(Fs/2) 100/(Fs/2)]); %Method1: �i�C�L�X�g=4000Hz 50Hz~100Hz  
    b = fir1(10, 100/4000, 'low'); %Method2: �i�C�L�X�g=4000Hz, ~100Hz
    Xf = filter(b, 1, abs_h); %
    
    %����Ƀ��[�p�X
    b2=[1 1 1 1 1 1 1 1 1 1]; %�ړ�����(Simple Moving Average)�F���[�p�X�t�B���^
    b2 = b2/length(b2); %���K��
    Xf_SMA = filter(b2,1,Xf);
    
    freqRange = (0:nextPowerOfTwo-1) * (Fs / nextPowerOfTwo);  % Frequency range
    gfreq = freqRange(1:plotRange);  % Only plotting upto n/2 (as other half is the mirror image)
    
    set(plotHandle, 'ydata', Xf_SMA(1:end/2), 'xdata', gfreq); % Updating the plot
    drawnow; % Update the plot
    
    %%if�������āCmax(Xf_SMA)������l�𒴂����out_amp���P�ɂ���A���̑��̏ꍇout_amp��0�ɂ���B���Ő؂�ւ��悤�ɒl�����肷��D
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
    t = 0:1/f_s:duration;  % signal evaluation time, �T���v�����[�g��1/f_s�Ƃ���B
    D = 0:1.0/speed:duration;          % pulse delay times
    w = 0.02;          % width of each pulse
    yp = a * square(10*(t-0.5) / pi) .* pulstran(t,D,@rectpuls,w);   % generate plustran vector

  %%�ۑ�1�̓��e��out_amp���֌W������

    queueOutputData(src,repmat(yp',1,1));
end