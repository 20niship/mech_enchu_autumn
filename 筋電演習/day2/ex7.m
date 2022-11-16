function ex7
% �G���[: audioDeviceReader/setup
% �ƂȂ�����Cclear���Ă�������

Fs = 8000;
Mic = audioDeviceReader(Fs);  % Fs Hz�ŁC1024�̃f�[�^���擾�D

while 1
    audio = step(Mic);  % Mic������͓ǂݍ���
    
    %% ���g�`�`��
    t = (1:length(audio))/Fs;
    subplot(211);
    plot(t, audio);
    xlim([0, max(t)]);  % ����1s�͈̔͂�\��
    xlabel('����[s]');
    
    %% FFT
    subplot(223);
    fout = abs(fft(audio));
    fout = fout(1:length(fout)/2);
    findpeaks(fout, 'MinPeakDistance', 10);
    fout(1:10) = 0;  % ���ʎ��Ɏg��Ȃ����������O�i���̗�ł͒���g���f�[�^�j
    % �\�[�g����FFT�̃s�[�N�𒊏o
    [pks, locs] = findpeaks(fout, 'SortStr', 'descend', 'MinPeakDistance', 10);
    xlim([0, length(fout)/2]);
    ylim([0, 20]);
    
    feature_x = pks(1)  > 5;  % ������1��݌v
    feature_y = locs(1) > 70;  % ������2��݌v

    subplot(224);
    plot(feature_x, feature_y, 'x');
    xlim([0, 1]);
    ylim([0, 1]);
    if feature_x & feature_y
        title('a');  % �����ʂɊ�Â����ޏ���
    elseif feature_x
        title('i');
    else
        title('s');
    end
    
    drawnow;  % �`��O���t�����A���^�C���ōX�V
    if strcmp(get(gcf, 'currentcharacter'), 'q')  % q��������I���(break)
        set(gcf, 'currentcharacter', '0');
        break
    end
end
