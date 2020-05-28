clc;clear all;
for i=1:5
figure("Name","Funcion "+i);
subplot(211);
graficacionfunciones(i,"","original");
dim=[0.2 0.6 0.3 0.3];
valores(i,"",dim);
subplot(212);
graficacionfunciones(i,"Vmedio","Sin el valor medio");
dim=[0.2 0.1 0.3 0.3];
valores(i,"Vmedio",dim);
end
% %% grafica de la suma y resta
% s1=1;s2=2;  %%funciones que se sumaron o restaron
% sumayresta(s1,s2,"Suma");
% sumayresta(s1,s2,"Resta");
% 
% %% correlacion:
% figure("Name","Correlacion de señales 1 y 2");
% graficacionfunciones(12,"correlacion","correlacionada");
% title("Correlacion de señales 1 y 2");
% figure("Name","Autocorrelacion de señal 2");
% graficacionfunciones(2,"correlacion","autocorrelacionada");

%% funciones utilizadas
function tiempo=graficacionfunciones(i,mod,tipo)
arch=load("Signal_0"+i+mod+".txt");
Fs=arch(1);
n=0:1/Fs:(length(arch)-2)/Fs;
dtplot(n,arch(2:length(arch)));
title("Funcion "+i+" "+tipo);
grid;
tiempo=(length(arch)-1)/Fs;
end

function sumayresta(s1,s2,tipo)
figure();
subplot(311);
graficacionfunciones(s1,"","Señal "+s1+" original");
subplot(312);
graficacionfunciones(s2,"","Señal "+s2+" original");
subplot(313);
t=graficacionfunciones(s1*10+s2,tipo,tipo+" de las dos funciones");
subplot(311);xlim([0 t]);
subplot(312);xlim([0 t]);
end

function valores(i,mod,dim)
arch=load("Signal_0"+i+mod+".txt");
Fs=arch(1);
Vmedio=sum(arch(2:length(arch)))/(length(arch)-1);
maximo=max(arch(2:length(arch)));
minimo=min(arch(2:length(arch)));

str = {"V medio: "+Vmedio,"Vmax: "+maximo,"Vmin: "+minimo};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
end