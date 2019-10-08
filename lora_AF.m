%%
clc
clear
close all
%������ ��������� ��� �������
f0 = 0; %������� �������
BW = 125; %������ ������
%��������� ������� � ������ ������� �������
fup = f0 + BW;
fdown = f0;
%����������� ���������� �������
SF = 7;
%������������ 1 �������
Tsym = 2^SF / BW;
%�������� ����� �������
mu = BW/Tsym;
%������� �������������
fs = 10*BW;

%%
%���������� ��� ������
t = 0:(1/fs):Tsym;
%%signal = cos(2*3.14*f0*t + mu*(t.^2)/2);

signal = chirp(t,fdown,Tsym,fup);

%%
h = chirp(t,fup,Tsym,fdown);

y = signal.* h;

%%
spect = fftshift(abs(fft(y)));
%%
n = length(spect);
m = -n/2:n/2-1;
step = fs/n;
f = (-fs/2:step:fs/2-step);
%%
figure;
plot(f,spect);
title ('������ �������������� ������� � �������');
grid on;

%%
k1 = (2^SF)/2; % ���. ������
%k1 = 32;

deltaF = (BW / (2^(SF+1))) ;

fstart = deltaF * k1;

T1 = (2^(SF+1)-k1)/(2^(SF+1)) * Tsym;

t1 = 0:1/fs:T1;
t2 = T1+1/fs:1/fs:Tsym;

signal1 = chirp(t1,fstart,T1,fup);
signal2 = chirp(t2,fdown,Tsym,fstart);


t0 = [t1, t2];
signal0 = [signal1, signal2];
figure
plot(t0,signal0);
title ('�������������� ������');
grid on
%%
y0 = signal0.*signal;
figure
plot(t0,y0);
title ('������������� ������. ������ � �������');

%%
spect0 = abs(fftshift(fft(y0)));
%%
n = length(spect0);
m = -n/2:n/2-1;
step = fs/n;
f = (-fs/2:step:fs/2-step);
%%
figure;
plot(f,spect0);
title ('������ �������������� ������. ������� � �������');
xlim([0 20]);
grid on;
%%
% ������ ������������ ���������� 
r = zeros(1,2^SF);
for k2=1:2^SF

T2 = (2^(SF+1)-k2)/(2^(SF+1)) * Tsym;

t11 = 0:1/fs:T2;
t22 = T2+1/fs:1/fs:Tsym;
fstart1 = deltaF * k2;

signal11 = chirp(t11,fstart1,T1,fup);
signal22 = chirp(t22,fdown,Tsym,fstart1);

signal00 = [signal11, signal22];


P = corrcoef(signal0, signal00);
r(k2) = P(1,2);
end

figure;
plot(r);
grid on;
title ('����. ����������');
xlim ([1,2^SF]);