clc;clear all;
%% Punto 2
% figure("Name","Tono 20Hz");    %genera la figura
% subplot(211);                   % en la figura superior grafica la original
% graficacionfunciones(20,256); %funcion que grafica
% subplot(212);                   %repite el proceso para la funcion sin Vmedio
% graficacionfunciones(20,16);
% 
% figure("Name","Tono 50Hz");    %genera la figura
% subplot(211);                   % en la figura superior grafica la original
% graficacionfunciones(50,256); %funcion que grafica
% subplot(212);                   %repite el proceso para la funcion sin Vmedio
% graficacionfunciones(50,16);
% 
% figure("Name","Tono 200Hz");    %genera la figura
% subplot(211);                   % en la figura superior grafica la original
% graficacionfunciones(200,256); %funcion que grafica
% subplot(212);                   %repite el proceso para la funcion sin Vmedio
% graficacionfunciones(200,16);

%% Punto 3
%Abrir archivo wav
[x,Fs] = audioread('Perro.wav');
%Genera y guarda los valores en un txt
arch = fopen('Tono_11025HzPerro.txt', 'wt');
fprintf(arch, '%.0f\n', Fs);
for i=1:length(x)
fprintf(arch, '%.10f\n', x(i));
end
fclose(arch);
%ejecuta el procesamiento en c
system("DSP3.exe")
%grafica las salidas
figure("Name","Perro 11025Hz");    %genera la figura
subplot(211);                   % en la figura superior grafica la original
graficacionfunciones(11025,4096); %funcion que grafica
subplot(212);                   %repite el proceso para la funcion sin Vmedio
graficacionfunciones(200,16);




%% funciones utilizadas
function graficacionfunciones(freq,muestras) %%abre el archivo y lo grafica
arch=load("Tono_"+freq+"Hz_Transformada"+muestras+".txt"); 
%abre el archivo "i" y mod es para agregar si esta correlacionado,
%es la se�al sumada, restada o sin valor medio.
Fs=arch(1);                     %guarda Fs
%n=0:1/Fs:(length(arch)-2)/Fs;   %Genera base temporal en base a Fs y la longitud
%dtplot(n,arch(2:length(arch))); %Grafica la funcion
plot(arch(2:length(arch)));
title("Tono de "+freq+" Hz con "+muestras+" puntos");   %Agrega titulo
grid;xlim([1 muestras]);
end