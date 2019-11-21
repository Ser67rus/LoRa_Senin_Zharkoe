clc
clear
close all
%%
%�������� ���������
f0 = 0; %������������� �������
SF = 7; %����������� ���������� �������
%SNR = -30; %�/� � ��
BW = 125e3; %������ �������
k = 2;
N = 1000; %����� ���������
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
%��������� �������
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
errors = zeros(1,length(-30:1:10));
j = 1;
for SNR = -30:1:10
    for i=1:N
        signal = awgn(s,SNR);
        % sigma = 10^(-SNR);
        % noise = sigma*randn(1,length(t)) .* exp(1i*2*pi*rand(1,length(t)));
        % signal = signal + noise;
        % figure; plot(-fs/2:fs/length(signal):fs/2-fs/length(signal),fftshift(abs(fft(signal))));
        % grid on;
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
        % figure;
        % plot(freqs/deltaF,fftshift(abs(Spect)));
        % grid on;
        
        % figure;
        % plot(fftshift(abs(Spect)));
        % grid on;
        sp = fftshift(abs(Spect));
        [Smax idx] = max(sp);
        k1 = -(idx-(2^(SF+4)+1));
        if(k1 == k)
            errors(j) = errors(j) + 1;
        end
    end
    j = j + 1;
end
figure; plot(-30:1:10,errors); grid on;