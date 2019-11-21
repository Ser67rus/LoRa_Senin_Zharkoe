function signal = getSignal(f0,BW,SF,fs,k)
%функци€ генерации сигнала LoRa
% f0 - несуща€ частота
% BW - ширина полосы
% SF - коэффициент расширени€ спектра
% fs - частота сэмплировани€
% k - информационный символ
%нижн€€ частота
fdown = f0 - BW/2;
%верхн€€ частота
fup = f0 + BW/2;

%длительность 1 символа
Tsym = 2^SF / BW;
%величина дикрета частоты на 1 символ
deltaF = BW / (2^(SF+1)) ;
%начальна€ частота
fstart = fdown + k*deltaF;
%врем€ достижени€ максимального значени€ частоты
T1 = ((2^(SF+1)-k)/2^(SF+1))*Tsym;
%создаем 1-й вектор времени (рост частоты от fstart до fup)
t1 = 0:1/fs:T1;
%создаем 2-й вектор времени (рост частоты от fstart до fup)
t2 = T1+1/fs:1/fs:Tsym;
%формируем 1-ю часть сигнала
signal1 = chirp(t1,fstart,T1,fup);
%формируем 2-ю часть сигнала
signal2 = chirp(t2,fdown,Tsym,fstart);

signal3 = zeros(1,1024);

%соедин€ем вектора и выводим
t = [t1, t2];
s = [signal1, signal2, signal3];
signal.values = s;
signal.time = t;
signal.deltaF = deltaF;
signal.Tsym = Tsym;