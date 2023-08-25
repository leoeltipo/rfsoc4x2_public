clear all;
close all;

% Number of lanes.
L = 4;

% Number of channels.
N = 1024;

% Sampling frequency.
fclk = 100e6;
fs = fclk*L;

% Channel center.
fc = fs/N;

% Channel bandwidth.
fb = fs/(N/2);

file = sprintf('dout.csv');
data = csvread(file, 1, 0);

% Data is captured when it's valid, and it's aligned with tlast.
% First sample is channel 0 of FIR core.
tlast = data(:,2);
xi = data(:,3);
xq = data(:,4);
x = double(xi) +1i*double(xq);

% Data out of 4x32 PFB + Switch is as follows:
% FIR0: 0 8  16 24
% FIR1: 1 9  17 25
% FIR2: 2 10 18 26
% FIR3: 3 11 19 27
% FIR4: 4 12 20 28
% FIR5: 5 13 21 29
% FIR6: 6 14 22 30
% FIR7: 7 16 23 31
%
% The testbench writes 8 samples per clock, so samples will be on the file
% with the same order, but in one column:
%
% 0 1 2 3 ...
%

% Number of N points blocks.
M = floor(length(x)/N) - 1;

% Output channels vector.
y = zeros(N, M);

% Compute N points FFTs to demodulate channels.
for i=0:M-1
    % N-point vector.
    xx = x(i*N+1:(i+1)*N-1+1); % +1 is per matlab indexing.
    
    % Without Hardware FFT.
    %yy = fft(xx);
    %y(:,i+1) = yy;
    
    % With Hardware FFT.
    y(:,i+1) = xx;
end

%%
figure; hold on;
for K=0:N-1
    xk = y(K+1,:);
    xk = xk(20:end);
    
    %if (mod(K,2) ~= 0)
    %    nn = 0:length(xk)-1;
    %    pm = (-1).^nn;
    %    xk = xk.*pm;
    %end
    
    % Spectrum.
    xk = xk;
    hh = hanning(length(xk));
    X = abs(fftshift(fft(xk.*hh.')));
    F = -length(xk)/2:length(xk)/2-1;
    F = F/length(F);
    F = F*fs/(N/2) + K*fc;
    plot(F/1000/1000,20*log10(X))
end