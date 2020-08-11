% Juan Agustin Avila
% Julio 2020
% Reg 26076 - ELO
%clc;clear all;
extra1="_Transformada";extra2="Puntos";
%% Punto 2
% Nombres=["Tono_20Hz","Tono_50Hz","Tono_200Hz"];
% puntos=[8 16 256]; n=length(puntos);
% for i=1:3
%     figure("Name",Nombres(i));    %genera la figura
%     nombre=Nombres(i); offset=20;
%     for j=1:n
%         subplot((n*100)+10+j);
%         system("DSP3.exe "+nombre+" "+puntos(j)+" "+offset); %Corre el archivo
%         graficacionfunciones(nombre,offset,puntos(j),extra1,extra2);
%     end
% end
% n=n-1;
% for i=1:3
%     figure("Name",Nombres(i));    %genera la figura
%     nombre=Nombres(i); offset=20;
%     for j=1:n
%         subplot((n*100)+10+j);
%         system("DSP3.exe "+nombre+" "+puntos(j)+" "+offset); %Corre el archivo
%         graficacionfunciones(nombre,offset,puntos(j),extra1,extra2);
%         hold on;
%         graficacionfunciones(nombre+"Arduino",offset,puntos(j),extra1,extra2);
%         legend('Transformada en C','Transformada en Arduino');
%     end
% end

%% Punto 3
% hz1=load("Tono_50Hz.txt");
% hz2=load("Tono_20Hz.txt");
% hz3=load("Tono_200Hz.txt");
% %Genera y guarda los valores en un txt
% arch = fopen('Tono_Suma.txt', 'wt');
% fprintf(arch, '%.0f\n', hz1(1));
% for i=2:length(hz1)
% fprintf(arch, '%.5f\n', (hz1(i)+hz2(i)+hz3(i)));
% end
% fclose(arch);
arch = fopen('FiltroFIR_LP40Hz.txt', 'wt');
for i=1:length(FiltroFIR_LP40Hz)
fprintf(arch, '%.5f\n', FiltroFIR_LP40Hz(i));
end
fclose(arch);  
system("DSP4.exe FiltroFIR_LP40Hz Tono_Suma");
original=load("Tono_Suma.txt");
filtrado=load("Tono_SumaFiltroFIR_LP40Hz.txt");
figure();
subplot(211);
plot(original(2:length(original)));
subplot(212);
plot(filtrado(2:length(filtrado)));
system("..\DSP3\DSP3.exe Tono_Suma 512 10")
system("..\DSP3\DSP3.exe Tono_SumaFiltroFIR_LP40Hz 512 10")
original=load("Tono_Suma_Transformada512Puntos.txt");
filtrado=load("Tono_SumaFiltroFIR_LP40Hz_Transformada512Puntos.txt");
figure();
subplot(211);
plot(original(2:length(original)));
subplot(212);
plot(filtrado(2:length(filtrado)));



%% funcion utilizada
function graficacionfunciones(nombre,offset,puntos,extra1,extra2) %%abre el archivo y lo grafica
arch=load(nombre+extra1+puntos+extra2+".txt"); 
plot(arch(2:length(arch)));
title("Transformada del archivo '"+nombre+"' con "+puntos+" puntos");   %Agrega titulo
grid on;xlim([1 puntos]);
end