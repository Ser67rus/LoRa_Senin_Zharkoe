%%
clc
clear
close all
%%
f0 = 250e3;
SF = 7;
BW = 125e3;
k = 102;
idxs = zeros(1,128);
% for k=0:127
fs = 2*(f0+BW/2);
buf = getSignal(f0,BW,SF,fs,k);
s = buf.values;
s = bandpass(s,[f0-BW/2 f0+BW/2],fs);
t = buf.time;
deltaF = buf.deltaF;
%%
buf = getSignal(f0,BW,SF,fs,0);
s0 = buf.values;
s0 = bandpass(s0,[f0-BW/2 f0+BW/2],fs);
%%
if (length(s0)<length(s))
    s = s(1:length(s0));
else
    s0 = s0(1:length(s));
end
y = s.*s0;
specty = fft(y,640*16);
figure
plot(-fs/2:fs/length(specty):fs/2-fs/length(specty),fftshift(abs(specty)));
grid on;
xlim([0,BW]);
sp = fftshift(abs(specty));
spex = sp(640*8+1:640*16);
[Smax idx] = max(spex);
k1 = floor(idx*fs/length(specty) /deltaF);
% idxs(k+1) = idx;
% end
% figure
% plot(0:127,idxs)
% grid on;
