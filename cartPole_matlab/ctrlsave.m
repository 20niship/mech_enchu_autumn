function ctrlsave(A, B, C, D, FN)
%   [] = ctrlsave(A, B, C, D, FN)
%
%   write CONTROLLER MATRIX to data_file
%       FN      =>  output file name (file name must be quated)
%       A,B,C,D =>  as bellow....
%                   .
%                   x = A x + B u
%                   y = C x + D u
%
%   Usage:  ctrlsave(Ad, Bd, Cd, Dd, 'control.dat')
%
%           written by Hiro KAWAKAMI    1997/12/17


FP = fopen(FN, 'w');
% �R���g���[���̃p�����[�^
in_size = size(B, 2);		% ���͂̐�
out_size = size(C, 1);		% �o�͂̐�
state_size = size(A, 1);	% ��Ԃ̐�

% �R���g���[���̃p�����[�^�̏�������
fprintf(FP, '\tInput Size\n');
fprintf(FP, '%d\n', in_size);
fprintf(FP, '\tOut Size\n');
fprintf(FP, '%d\n', out_size);
fprintf(FP, '\tState Size\n');
fprintf(FP, '%d\n', state_size);

% �s��`�̏�������
fprintf(FP, '\tA Matrix\n');
for i = 1:state_size		% �s
	for j = 1:state_size	% ��
		fprintf(FP, '%+e\n', A(i, j));
	end
end
% �s��a�̏�������
fprintf(FP, '\tB Matrix\n');
for i = 1:state_size		% �s
	for j = 1:in_size		% ��
		fprintf(FP, '%+e\n', B(i, j));
	end
end
% �s��b�̏�������
fprintf(FP, '\tC Matrix\n');
for i = 1:out_size			% �s
	for j = 1:state_size	% ��
		fprintf(FP, '%+e\n', C(i, j));
	end
end
% �s��c�̏�������
fprintf(FP, '\tD Matrix\n');
for i = 1:out_size			% �s
	for j = 1:in_size		% ��
		fprintf(FP, '%+e\n', D(i, j));
	end
end
fclose(FP);


