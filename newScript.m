%%
clc
clear
close all
%%
f0 = 250e3;
SF = 7;
BW = 125e3;
% k = 65;
SNR = 20;
k1 = zeros(1,128);
i = 1;
for k=0:127
fs = 16*f0;
buf = getSignal(f0,BW,SF,fs,k);
s = buf.values;

% figure;
% plot(-fs/2:fs/length(s):fs/2-fs/length(s),fftshift(abs(fft(s))));
% grid on;
% xlim([f0-BW,f0+BW]);


s = awgn(s,SNR);
% figure;
% plot(-fs/2:fs/length(s):fs/2-fs/length(s),fftshift(abs(fft(s))));
% grid on;
% xlim([f0-BW,f0+BW]);


s = bandpass(s,[f0-BW/2 f0+BW/2],fs);
t = buf.time;
deltaF = buf.deltaF;
% figure;
% plot(-fs/2:fs/length(s):fs/2-fs/length(s),fftshift(abs(fft(s))));
% grid on;
% xlim([f0-BW,f0+BW]);


%%
buf = getSignal(f0,BW,SF,fs,0);
s0 = buf.values;
% figure;
% plot(-fs/2:fs/length(s0):fs/2-fs/length(s0),fftshift(abs(fft(s0))));
% grid on;
% xlim([f0-BW,f0+BW]);
%%
if (length(s0)<length(s))
    s = s(1:length(s0));
else
    s0 = s0(1:length(s));
end
y = s.*s0;
specty = fft(y,2^13);
% figure
% plot(-fs/2:fs/length(specty):fs/2-fs/length(specty),fftshift(abs(specty)));
% grid on;
% xlim([0,BW]);
sp = fftshift(abs(specty));
spex = sp(2^12+1:2^13);
[Smax idx] = max(spex);
k1(i) = floor(idx*fs/length(specty) /deltaF);
i = i+1;
end
goodMtx = 0:127;
dif = abs(goodMtx - k1);
% idxs(k+1) = idx;
% end
% figure
% plot(0:127,idxs)
% grid on;
