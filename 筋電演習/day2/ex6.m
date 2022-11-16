clear all;
Fs = 8000;
Mic = audioDeviceReader(Fs);
record = zeros(1);

while(true)
    audio = step(Mic);  % Mic������͓ǂݍ���
    record = vertcat(record, audio);  % record�ɑS�L�^��ۑ�

%% ���g�`�`��
    subplot(3, 1, 1);
    t = (1:length(record))/Fs;
    plot(t, record);
    xlim([max(t)-10, max(t)]);  % ����10s�͈̔͂�\��
    title('���g�`')
    myRecording = partvec(record, 10*Fs);
    xlabel('����[s]');
    
    if length(myRecording) < Fs*2  % �v�����Ԃ�2s�ȉ��Ȃ�c��̉�͂����Ȃ�
       continue 
    end
%% �X�y�N�g���O�����\��
    subplot(3, 1, 2)
    spectrogram(myRecording, 128, 120, 128, Fs, 'yaxis');
    colorbar('off');
    title('�X�y�N�g���O����')
%% fft�\��
    subplot(3, 1, 3)
    Y = abs(fft(myRecording));
    L = length(myRecording);
    P2 = abs(Y/L);
    P1 = abs(P2(1:round(L/2)));
    f = Fs*(1:round(L/2))/L;  % ���g�����̐���
    plot(f, P1)
    title('fft')
    xlabel('���g��[Hz]')
    
    drawnow limitrate nocallbacks  % �`��O���t�����A���^�C���ōX�V
    
end

%% ���n��f�[�^�̍Ōォ�璷��L��؂�o���֐�
function vec_ = partvec(vec, L)
    if length(vec) > L
        vec_ = vec(end-L+1:end);
    else
        vec_ = vec;
    end
end
