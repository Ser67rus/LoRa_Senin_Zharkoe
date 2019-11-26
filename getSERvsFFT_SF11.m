clc
clear
close all
%%
%�������� ���������
f0 = 0; %������������� �������
SF = 11; %����������� ���������� �������
% SNR = 20; %�/� � ��
BW = 125e3; %������ �������
k = 1024;
N = 10000; %����� ���������
fs = 2e6; %������� �������������
%%
%������������ �������
%������ �������
fdown = f0-BW/2;
%������� �������
fup = f0+BW/2;
%������������ 1 �������
Tsym = 2^SF / BW;
%�������� ������� ������� �� 1 ������
deltaF = BW / (2^(SF+1)) ;
nums = zeros(1,1024);
j = 1;
fstart = fdown + k*deltaF;
%����� ���������� ������������� �������� �������
T1 = ((2^(SF+1)-k)/2^(SF+1))*Tsym;
%������� 1-� ������ ������� (���� ������� �� fstart �� fup)
t1 = 0:1/fs:T1;
%������� 2-� ������ ������� (���� ������� �� fstart �� fup)
t2 = T1+1/fs:1/fs:Tsym;
t3 = Tsym+1/fs:1/fs:2.5*Tsym;

%��������� 1-� ����� �������
signal1 = chirp(t1,fstart,T1,fup) + 1i*chirp(t1,fstart,T1,fup,'linear',90);
%��������� 2-� ����� �������
signal2 = chirp(t2,fdown,Tsym,fstart)+1i*chirp(t2,fdown,Tsym,fstart,'linear',90);
signal3 = zeros(1,length(t3));
s = [signal1, signal2, signal3];
t = [t1,t2,t3];
%��� ������
% figure; plot(-fs/2:fs/length(signal):fs/2-fs/length(signal),fftshift(abs(fft(signal))));
% grid on;
%%
%��������� ��������� ���
errorsSF11 = zeros(1,length(-60:0.5:10));
j = 1;
for SNR = -60:0.5:10
    for i=1:N
        signal = awgn(s,SNR);
        %%
        %��������� ������� ������
        t0 = 0:1/fs:Tsym;
        signal0 = chirp(t0,fdown,Tsym,fup) + 1i*chirp(t0,fdown,Tsym,fup,'linear',90);
        signal0 = [signal0, signal3];
        % figure; plot(-fs/2:fs/length(signal0):fs/2-fs/length(signal0),fftshift(abs(fft(signal0))));
        % grid on;
        %%
        %����������� � �������
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