function ex8b(coef)
% coef�́Cex8a�ō�����d��
% pred = glmval(coef, fout', 'logit');
% ���傫�����/a/�C���������/i/�D
% �G���[: audioDeviceReader/setup
% �ƂȂ�����Cclear���Ă�������

Fs = 8000;
Mic = audioDeviceReader('SampleRate', Fs);
delete(findobj(gcf, 'Type', 'Axes'))

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
    fout = fout(1:length(fout)/2+1);
    findpeaks(fout, 'MinPeakDistance', 10);
    %fout(1:10) = 0;  % ���ʎ��Ɏg��Ȃ����������O�i���̗�ł͒���g���f�[�^�j
    % �\�[�g����FFT�̃s�[�N�𒊏o
    [pks, locs] = findpeaks(fout, 'SortStr', 'descend', 'MinPeakDistance', 10);
    xlim([0, length(fout)/2]);
    ylim([0, 20]);
    
    pred = glmval(coef, fout', 'logit');

    feature_x = pks(1);  % ������1��݌v
    feature_y = pred;  % ������2��݌v
    subplot(224); hold on;
    %xlim([0, 10]);
    %ylim([0, 1]);

    if feature_x<0 & feature_y<0
        title('a');  % �����ʂɊ�Â����ޏ���
        plot(feature_x, feature_y, '.b');
    elseif feature_x<0 & feature_y > 0
        title('i');
        plot(feature_x, feature_y, '.r');
    else
        title('s');
        plot(feature_x, feature_y, '.k');
    end
    
    drawnow;  % �`��O���t�����A���^�C���ōX�V
    if strcmp(get(gcf, 'currentcharacter'), 'q')  % q��������I���(break)
        set(gcf, 'currentcharacter', '0');
        break
    end
end
