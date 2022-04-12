clc
clear

N = input('Nombre d''�chantilllons pour ce signal : ');
Frel = input('Fr�quence normalis�e (nombre de p�riodes dans la dur�e totale) : ');
Ph0 = input('Phase a l''origine (en degr�s) : ');
Ph0 = Ph0 * pi / 180.0; % a present en radian

Ampl = 2048;
Offset = 2048;
%% Cr�ation du fichier .asm

fileID = fopen(['Signal.asm'], 'w');
fprintf(fileID,'\tAREA Signal, DATA, READONLY\n');
fprintf(fileID,'\texport LeSignal\n');

fprintf(fileID,'LeSignal\n');

for  i = 1: N
     % fonction a modifier en fonction des besoins
     Sig(i) = Offset + Ampl * cos( 2*pi*Frel*(i-1)/N + Ph0 );
     % arrondi
     iSig = int16(Sig(i));
     % bornage du signal similaire a la sortie brute de l'ADC 12 bits
     if ( iSig < 0 )
         iSig = 0;
     end
     if ( iSig > 4095 )
         iSig = 4095;
     end
     
     fprintf(fileID,'\tDCW\t0x%04x\t; %2d %4d  %7.5f\n',iSig, i-1, iSig, double(iSig) / 4096.0 );

end

fprintf(fileID,'\tEND\n');
fclose(fileID);
plot(Sig);