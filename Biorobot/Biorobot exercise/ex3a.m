%アナログ信号の出力
clear;
clear all;

%  -- View and select audio device
d = daq.getDevices;
dev_ou = d(4);
%  -- Create an input session
s = daq.createSession('directsound');
addAudioOutputChannel(s, dev_ou.ID, 1);
s.IsContinuous = true;
s.Rate = floor(8192);

%Add listener
f_s = 8192;
EMGtoEMS = @(s, event) wave_gen(s, event, f_s);
hl2 = addlistener(s, 'DataRequired', EMGtoEMS);

wave_gen(s, "", f_s)
startBackground(s)

input("Hit Enter to stop --> ");
s.stop()


%% self-defined functions
function wave_gen(s, event, f_s)
    speed = 2;
    duration = 3;
    t = 0:1/f_s:duration;  % signal evaluation time, サンプルレートは1/f_sとする。
    D = 0:1.0/speed:duration;          % pulse delay times
    w = 0.005;          % width of each pulse
    yp = square(10*(t-0.5) / pi) .* pulstran(t,D,@rectpuls,w);   % generate plustran vector
    queueOutputData(s,0.8*repmat(yp',1,1));
end
