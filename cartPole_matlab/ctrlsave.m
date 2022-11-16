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
% コントローラのパラメータ
in_size = size(B, 2);		% 入力の数
out_size = size(C, 1);		% 出力の数
state_size = size(A, 1);	% 状態の数

% コントローラのパラメータの書き込み
fprintf(FP, '\tInput Size\n');
fprintf(FP, '%d\n', in_size);
fprintf(FP, '\tOut Size\n');
fprintf(FP, '%d\n', out_size);
fprintf(FP, '\tState Size\n');
fprintf(FP, '%d\n', state_size);

% 行列Ａの書き込み
fprintf(FP, '\tA Matrix\n');
for i = 1:state_size		% 行
	for j = 1:state_size	% 列
		fprintf(FP, '%+e\n', A(i, j));
	end
end
% 行列Ｂの書き込み
fprintf(FP, '\tB Matrix\n');
for i = 1:state_size		% 行
	for j = 1:in_size		% 列
		fprintf(FP, '%+e\n', B(i, j));
	end
end
% 行列Ｃの書き込み
fprintf(FP, '\tC Matrix\n');
for i = 1:out_size			% 行
	for j = 1:state_size	% 列
		fprintf(FP, '%+e\n', C(i, j));
	end
end
% 行列Ｄの書き込み
fprintf(FP, '\tD Matrix\n');
for i = 1:out_size			% 行
	for j = 1:in_size		% 列
		fprintf(FP, '%+e\n', D(i, j));
	end
end
fclose(FP);


