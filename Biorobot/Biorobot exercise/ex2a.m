clear all;

% Load test data (Hallelujah)
load handel;

t_slow = [];
t_fast = [];

for i = 1:100
%% Default setting for fft
yDFT_slow = @()fft(y); % Discrete Fourier Transform of data
t_slow(i) = timeit(yDFT_slow);

%% Fast Setting for fft by triggering Radix-2 fft algorithm
% To use the fft function to convert the signal to the frequency domain, first identify a new input length that is the next power of 2 from the original signal length. This will pad the signal X with trailing zeros in order to improve the performance of fft.

% ‚±‚±‚ÅnextPowerOfTwo‚ð’è‹`‚µ‚æ‚¤
s  = size(y);
p = nextpow2(s(1));
nextPowerOfTwo = 2^p;

yDFT_fast = @()fft(y, nextPowerOfTwo); % Discrete Fourier Transform of data
t_fast(i) = timeit(yDFT_fast);
end

bar(t_slow)
hold on;
bar(t_fast)

legend('t slow','t fast')
T = title('D-FFT performance comparison');
xlabel('#')
ylabel('execution time (s)')