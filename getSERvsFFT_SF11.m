clc
clear
close all
%%
%основные параметры
f0 = 0; %промежуточная частота
SF = 11; %коэффициент расширения спектра
% SNR = 20; %с/ш в дБ
BW = 125e3; %ширина спектра
k = 1024;
N = 10000; %число испытаний
fs = 2e6; %частота дискретизации
%%
%формирование сигнала
%нижняя частота
fdown = f0-BW/2;
%верхняя частота
fup = f0+BW/2;
%длительность 1 символа
Tsym = 2^SF / BW;
%величина дикрета частоты на 1 символ
deltaF = BW / (2^(SF+1)) ;
nums = zeros(1,1024);
j = 1;
fstart = fdown + k*deltaF;
%время достижения максимального значения частоты
T1 = ((2^(SF+1)-k)/2^(SF+1))*Tsym;
%создаем 1-й вектор времени (рост частоты от fstart до fup)
t1 = 0:1/fs:T1;
%создаем 2-й вектор времени (рост частоты от fstart до fup)
t2 = T1+1/fs:1/fs:Tsym;
t3 = Tsym+1/fs:1/fs:2.5*Tsym;

%формируем 1-ю часть сигнала
signal1 = chirp(t1,fstart,T1,fup) + 1i*chirp(t1,fstart,T1,fup,'linear',90);
%формируем 2-ю часть сигнала
signal2 = chirp(t2,fdown,Tsym,fstart)+1i*chirp(t2,fdown,Tsym,fstart,'linear',90);
signal3 = zeros(1,length(t3));
s = [signal1, signal2, signal3];
t = [t1,t2,t3];
%сам сигнал
% figure; plot(-fs/2:fs/length(signal):fs/2-fs/length(signal),fftshift(abs(fft(signal))));
% grid on;
%%
%правильно добавляем шум
errorsSF11 = zeros(1,length(-60:0.5:10));
j = 1;
for SNR = -60:0.5:10
    for i=1:N
        signal = awgn(s,SNR);
        %%
        %формируем опорный сигнал
        t0 = 0:1/fs:Tsym;
        signal0 = chirp(t0,fdown,Tsym,fup) + 1i*chirp(t0,fdown,Tsym,fup,'linear',90);
        signal0 = [signal0, signal3];
        % figure; plot(-fs/2:fs/length(signal0):fs/2-fs/length(signal0),fftshift(abs(fft(signal0))));
        % grid on;
        %%
        %сворачиваем с опорным
        signal = signal.*conj(signal0);
        Spect = fft(signal,2^(SF+5));
        freqs = -fs/2:fs/length(Spect):fs/2-fs/length(Spect);

        sp = fftshift(abs(Spect));
        [Smax idx] = max(sp);
        k1 = 32769 - idx;
        if(k1 == k)
            errorsSF11(j) = errorsSF11(j) + 1;
        end
    end
j = j + 1;
end
save SF11;