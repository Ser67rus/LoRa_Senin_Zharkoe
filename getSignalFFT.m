function spect = getSignalFFT(fs,signal)
%получение спектра сигнала
s = fftshift(abs(fft(signal)));
step = fs/length(s);
freq = -fs/2:step:fs/2 - step;

spect.values = s;
spect.freqs = freq;