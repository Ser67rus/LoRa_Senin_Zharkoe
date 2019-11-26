%%
clc
clear
close all
%%
getSERvsFFT_SF7;
getSERvsFFT_SF8;
getSERvsFFT_SF9;
getSERvsFFT_SF10;
getSERvsFFT_SF11;
getSERvsFFT_SF12;
%%
clear
load SF7;
load SF8;
load SF9;
load SF10;
load SF11;
load SF12;
%%
figure; plot(-60:0.5:10,errorsSF7);
hold on; plot(-60:0.5:10,errorsSF8);
hold on; plot(-60:0.5:10,errorsSF9);
hold on; plot(-60:0.5:10,errorsSF10);
hold on; plot(-60:0.5:10,errorsSF11);
hold on; plot(-60:0.5:10,errorsSF12);
grid on;
