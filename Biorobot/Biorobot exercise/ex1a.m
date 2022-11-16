clear;
clear all;

%�A�i���O�M���̏o��
%View and select audio device
d = daq.getDevices;
dev_ou = d(4);

%Create an input session
% s = daq.createSession('directsound');
% addAudioOutputChannel(s, dev_ou.ID, 1);
% s.IsContinuous = false;
% s.Rate = floor(8192*1.0);
% % Queue the output example (Hallelujah)
% load handel;
% queueOutputData(s,0.2*repmat(y,1,1));
% s.startForeground();

%�ȉ��ɍĐ����[�g1.9�{�A�Đ�����5�{�ł̍Đ���ǋL
s = daq.createSession('directsound');
addAudioOutputChannel(s, dev_ou.ID, 1);
s.IsContinuous = false;
s.Rate = floor(8192*1.9);

% Queue the output example (Hallelujah)
load handel;
queueOutputData(s,repmat(y,1,1));
s.startForeground();
