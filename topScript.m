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
deltaF = buf.deltaF;
SNR = 20;

c = 0;
m = 100;
c_arr = [];
SNR_arr = [];

for SNR=0:-1:-60
    c = 0;
    for q=1:m
        
        buf = getSignal(f0,BW,SF,fs,k);
        s = buf.values;
        t = buf.time;
        deltaF = buf.deltaF;
        
        %вычислим мощность сигнала
        sum = 0;
        for i=1:length(s)
            sum = sum + s(i)^2;
        end
        
        
        s = awgn(s,SNR);
        
        %%
%         figure;
%         plot(t,s);
%         grid on;
        
        %%
        clear buf;
        buf = getSignalFFT(fs,s);
        spect = buf.values;
        freq = buf.freqs;
        
        %%
%         figure;
%         plot(freq,spect);
%         grid on;
%         xlim([f0 - BW_disp f0 + BW_disp]);
        
        %%
        clear buf;
        buf = getSignal(f0,BW,SF,fs,0);
        h = buf.values;
        t = buf.time;
        T = max(t);
        %%
        y = s.*h;
        
        %%
%         figure;
%         plot(t,y);
%         grid on;
        
        %%
        clear buf;
        buf = getSignalFFT(fs,y);
        spect = buf.values;
        freq = buf.freqs / deltaF;
        
        k1 = getValue(spect,deltaF,fs);
        
        if (k1 == k)
            c = c+1;
        end
        
        %%
%         figure;
%         plot(freq(length(freq)/2:end),spect(length(freq)/2:end));
%         grid on;
%         xlim([0 2*BW_disp]);
%         close all;
    end
    SNR_arr = [SNR_arr SNR];
    c_arr = [c_arr c];
end
%%
figure;
plot(SNR_arr,(1-c_arr/m)*100);
grid on
title('SER');
