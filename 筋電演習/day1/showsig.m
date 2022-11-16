clear all;
Fs = 16000;  % �T���v�����O���g���iHz�j
RNG = 2;  % �\�����鎞�ԁi�b�j
Mic = audioDeviceReader(Fs);  % �T���v�����O���g��Fs�ŁC1024�̃f�[�^���擾�D
record = zeros(1);

while(true)
    audio = step(Mic);  % Mic������͓ǂݍ���
    record = vertcat(record, audio);  % record�ɑS�L�^��ۑ�
    peak2peak = max(audio) - min(audio);

%% ���g�`�`��    
    t = (1:length(record))/Fs;
    plot(t, record);
    xlim([max(t)-RNG, max(t)]);  % ����RNG�b�͈̔͂�\��
    % myRecording = partvec(record, 10*Fs);  % ����10�b�̐؂�o��
    xlabel('����[s]');
    title(num2str(peak2peak));  % �U��
    drawnow limitrate nocallbacks  % �`��O���t�����A���^�C���ōX�V
    if length(record) > Fs*6000  % 60�b�ŏI��
        break;
    end
end

%% ���n��f�[�^�̍Ōォ�璷��L��؂�o���֐�
function vec_ = partvec(vec, L)
    if length(vec) > L
        vec_ = vec(end-L+1:end);
    else
        vec_ = vec;
    end
end
