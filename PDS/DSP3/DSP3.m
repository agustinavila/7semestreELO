clc;clear all;
%% Punto 2
extra1="_Transformada";extra2="Puntos";

figure("Name","Tono 20Hz");    %genera la figura
nombre="Tono_20Hz"; offset=20; puntos=8; 
subplot(311);                   % en la figura superior grafica la original
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica
subplot(312);                   %repite el proceso para la funcion sin Vmedio
puntos=16;
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica
subplot(313);                   %repite el proceso para la funcion sin Vmedio
puntos=256;
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica

figure("Name","Tono 50Hz");    %genera la figura
nombre="Tono_50Hz"; offset=100; puntos=8; 
subplot(311);                   % en la figura superior grafica la original
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica
subplot(312);                   %repite el proceso para la funcion sin Vmedio
puntos=16;
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica
subplot(313);                   %repite el proceso para la funcion sin Vmedio
puntos=256;
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica

figure("Name","Tono 20Hz");    %genera la figura
nombre="Tono_200Hz"; offset=100; puntos=8; 
subplot(311);                   % en la figura superior grafica la original
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica
subplot(312);                   %repite el proceso para la funcion sin Vmedio
puntos=16;
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica
subplot(313);                   %repite el proceso para la funcion sin Vmedio
puntos=256;
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica

%% Punto 3
%Abrir archivo wav
[x,Fs] = audioread('Perro.wav');
%Genera y guarda los valores en un txt
arch = fopen('TonoPerro.txt', 'wt');
fprintf(arch, '%.0f\n', Fs);
for i=1:length(x)
fprintf(arch, '%.10f\n', x(i));
end
fclose(arch);
figure("Name","Ladrido de perro");    %genera la figura
nombre="Perro"; offset=1000; puntos=16; 
subplot(211);                   % en la figura superior grafica la original
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica
subplot(212);                   % en la figura superior grafica la original
puntos=1024;
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica


%%Punto 4
figure("Name","Transformada de Red Electrica");    %genera la figura
nombre="DatosRedElectrica"; offset=100; puntos=8; 
subplot(211);                   % en la figura superior grafica la original
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica
subplot(212);                   % en la figura superior grafica la original
puntos=256;
graficacionfunciones(nombre,offset,puntos,extra1,extra2); %funcion que grafica


%% funciones utilizadas
function graficacionfunciones(nombre,offset,puntos,extra1,extra2) %%abre el archivo y lo grafica
system("DSP3.exe "+nombre+" "+puntos+" "+offset) %Corre el archivo
arch=load(nombre+extra1+puntos+extra2+".txt"); 
Fs=arch(1);                     %guarda Fs
n=0:1/Fs:(length(arch)-2)/Fs;   %Genera base temporal en base a Fs y la longitud
plot(n,arch(2:length(arch))); %Grafica la funcion
plot(arch(2:length(arch)));
title("Transformada del archivo '"+nombre+"' con "+puntos+" puntos");   %Agrega titulo
grid;xlim([1 puntos]);
end