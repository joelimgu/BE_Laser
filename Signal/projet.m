clear all;
close all ; 
clc;

Fe = 320e3;
Te = 1/Fe; 
T = 1/5e3;
M = T*Fe;

Tsim = T - Te;
Res = sim('simulProjet');
Res_bourre = sim('signal_bourre');
carr = sim('sig_carre');

plot(Res.echant);

grid;


df = 1/T;
freq = df*(0:1:M-1);

sinf = abs(fft( Res.echant.Data)/M);

% 
% % % % % % % % % % % % % % % % % % % 
% % % % % % signal avec fréquences décalées en échelle log
% % % % % % % % % % % % % % % % % % % 
% 
% sinf_bourre = abs(fft(Res_bourre.echant.Data)/M);
% figure;
% stem(freq,sinf);
% hold on; 
% stem(freq,sinf_bourre);
% 
% 
% figure; 
% semilogy(freq,sinf_bourre,'r*');
% hold on;
% semilogy(freq,sinf,'g+');
% hold off; 
% grid;
% legend('avec erreur de frequence','sans erreur de frequence');
% 
% 
% % % % % % % % % % % % % % % % % % % 
% % % % % % signal tronqué
% % % % % % % % % % % % % % % % % % % 
% 
% res_tronq = Res.echant_tronque.Data;
% sinf_t = abs(fft(res_tronq)/M);
% figure; 
% plot(Res.echant,'g');
% hold on;
% plot(Res.echant_tronque,'r');
% hold off; 
% 
% figure; 
% stem(freq,sinf,'g*');
% hold on; 
% stem(freq,sinf_t,'r+');
% hold off; 


% % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % fft signal carré
% % % % % % % % % % % % % % % % % % % % % % 
% 
sinf_c = abs(fft(carr.echant.Data)/M);
% figure; 
% plot(carr.echant,'g');
% figure;
% stem(freq,sinf_c,'r');


H = tf(1,[1.7483e-23 7.6663e-18 1.162e-11 3.0332e-6 1]);

bode(H); 

plot(carr.echantfiltre);
figure;
stem(freq, abs(fft(carr.echantfiltre.Data)/M));
hold on;
stem(freq,sinf_c,'r');

