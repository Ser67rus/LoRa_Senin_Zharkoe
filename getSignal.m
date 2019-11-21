function signal = getSignal(f0,BW,SF,fs,k)
%������� ��������� ������� LoRa
% f0 - ������� �������
% BW - ������ ������
% SF - ����������� ���������� �������
% fs - ������� �������������
% k - �������������� ������
%������ �������
fdown = f0 - BW/2;
%������� �������
fup = f0 + BW/2;

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
%��������� 1-� ����� �������
signal1 = chirp(t1,fstart,T1,fup);
%��������� 2-� ����� �������
signal2 = chirp(t2,fdown,Tsym,fstart);

signal3 = zeros(1,1024);

%��������� ������� � �������
t = [t1, t2];
s = [signal1, signal2, signal3];
signal.values = s;
signal.time = t;
signal.deltaF = deltaF;
signal.Tsym = Tsym;