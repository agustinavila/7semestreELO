% Juan Agustin Avila
% Julio 2020
% Reg 26076 - ELO
clc;clear all;
extra1="_Transformada";extra2="Puntos";
%% Punto 2
Nombres=["Tono_20Hz","Tono_50Hz","Tono_200Hz"];
puntos=[8 16 256]; n=length(puntos);
for i=1:3
    figure("Name",Nombres(i));    %genera la figura
    nombre=Nombres(i); offset=20;
    for j=1:n
        subplot((n*100)+10+j);
        system("DSP3.exe "+nombre+" "+puntos(j)+" "+offset); %Corre el archivo
        graficacionfunciones(nombre,offset,puntos(j),extra1,extra2);
    end
end
n=n-1;
for i=1:3
    figure("Name",Nombres(i));    %genera la figura
    nombre=Nombres(i); offset=20;
    for j=1:n
        subplot((n*100)+10+j);
        system("DSP3.exe "+nombre+" "+puntos(j)+" "+offset); %Corre el archivo
        graficacionfunciones(nombre,offset,puntos(j),extra1,extra2);
        hold on;
        graficacionfunciones(nombre+"Arduino",offset,puntos(j),extra1,extra2);
        legend('Transformada en C','Transformada en Arduino');
    end
end

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
nombre="Perro"; offset=1000; puntos=4096; 
subplot(211);                   % en la figura superior grafica la original
system("DSP3.exe "+nombre+" "+puntos+" "+offset) %Corre el archivo
graficacionfunciones(nombre,offset,puntos,extra1,extra2);
title("Transformada con "+puntos+" puntos en C");
subplot(212);                   % en la figura superior grafica la original
xm=fft(x,puntos);               %calcula la DFT en matlab
plot(1:puntos,abs(xm));
title("Transformada con "+puntos+" puntos en matlab");   %Agrega titulo
grid on;xlim([1 puntos]);


%% Punto 4
figure("Name","Transformada de Red Electrica");    %genera la figura
nombre="DatosRedElectrica"; offset=10; puntos=16; 
subplot(211); 
system("DSP3.exe "+nombre+" "+puntos+" "+offset) 
graficacionfunciones(nombre,offset,puntos,extra1,extra2);
subplot(212);   
puntos=450;
system("DSP3.exe "+nombre+" "+puntos+" "+offset)
graficacionfunciones(nombre,offset,puntos,extra1,extra2);

%% funcion utilizada
function graficacionfunciones(nombre,offset,puntos,extra1,extra2) %%abre el archivo y lo grafica
arch=load(nombre+extra1+puntos+extra2+".txt"); 
plot(arch(2:length(arch)));
title("Transformada del archivo '"+nombre+"' con "+puntos+" puntos");   %Agrega titulo
grid on;xlim([1 puntos]);
end