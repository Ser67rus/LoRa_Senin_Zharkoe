clc
clear
close all;
%%
f0 = 110e6;
SF = 7;
BW = 125e3;
BW_disp = 300e3;
fs = 2*(f0 + 2*BW);
k = 64;
buf = getSignal(f0,BW,SF,fs,k);
s = buf.values;
t = buf.time;
SNR = -20;

%�������� �������� �������
sum = 0;
for i=1:length(s)
    sum = sum + s(i)^2;
end

P = 10*log10(sum/length(s));
%%
figure;
plot(t,s);
grid on;

%%
clear buf;
buf = getSignalFFT(fs,s);
spect = buf.values;
freq = buf.freqs;

%%
figure;
plot(freq,spect);
grid on;
xlim([f0 - BW_disp f0 + BW_disp]);

%%
clear buf;
buf = getSignal(f0,BW,SF,fs,0);
h = buf.values;
t = buf.time;
T = max(t);
%%
y = s.*h;

%%
figure;
plot(t,y);
grid on;

%%
clear buf;
buf = getSignalFFT(fs,y);
spect = buf.values;
freq = buf.freqs;

%%
figure;
plot(freq(length(freq)/2:end),spect(length(freq)/2:end));
grid on;
xlim([0 2*BW_disp]);
