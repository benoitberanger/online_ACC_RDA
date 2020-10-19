function [frequency,power] = FFT(~,signal,fs)

L = length(signal);
Y = fft(signal);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
power = P1;
frequency = fs*(0:(L/2))/L;

end % function
