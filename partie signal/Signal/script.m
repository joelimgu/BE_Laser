
clear all;
close all;
clc;

Fsin = 14;
Tsin = 1/Fsin; 
T = 5 * Tsin; % k * Tsin
M = 32;
Te = T/M;
Fe = 1/Te;
Tsim = T - Te;
Res = sim('SimulDFT');
plot(Res.Sinus_Continu);
hold on; % permet de superposer la courbe à suivre
plot(Res.Sinus_Echanti,'o');
hold off;
grid;


% echelle = linspace(0,31,32);
% sinf = abs(fft( Res.Sinus_Echanti.Data)/M);
% plot(echelle,sinf,'o');

df = 1/T;
freq = df*(0:1:M-1);
sinf = abs(fft( Res.Sinus_Echanti.Data)/M);
figure;
stem(freq,sinf,'o');