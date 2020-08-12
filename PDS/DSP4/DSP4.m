% Juan Agustin Avila
% Julio 2020
% Reg 26076 - ELO
%clc;clear all;

puntos=512; offset=10;
load('filtros.mat');    %se carga el archivo con los valores de los filtros
%% Punto 1
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

nombre_senial="OndaCuadrada";
nombre_filtro="FiltroFIR_HP150Hz";filtro=FiltroFIR_HP150Hz;
%la funcion filtroFIR realiza todas las operaciones para el filtro dado
filtroFIR(nombre_filtro,filtro,nombre_senial,puntos,offset);

nombre_filtro="FiltroFIR_BP40_100Hz";filtro=FiltroFIR_BP40_100Hz;
filtroFIR(nombre_filtro,filtro,nombre_senial,puntos,offset);

nombre_filtro="FiltroFIR_LP40Hz";filtro=FiltroFIR_LP40Hz;
filtroFIR(nombre_filtro,filtro,nombre_senial,puntos,offset);

%% filtros IIR
%con filterDesigner se exportaba el filtro IIR como una
%matriz SOS y un vector de ganancia G, eso se paso a una FT
[a,b]=sos2tf(SOSHP150Hz,GHP150Hz);   
FiltroIIR_HP150Hz=[b a];        %Y luego numerador y denominador se unieron
[a,b]=sos2tf(SOSBP,GBP);
FiltroIIR_BP40_100Hz=[b a];
[a,b]=sos2tf(SOSLP40Hz,GLP40Hz);
FiltroIIR_LP40Hz=[b a];

nombre_filtro="FiltroIIR_HP150Hz";filtro=FiltroIIR_HP150Hz;
filtroFIR(nombre_filtro,filtro,nombre_senial,puntos,offset);

nombre_filtro="FiltroIIR_BP40_100Hz";filtro=FiltroIIR_BP40_100Hz;
filtroFIR(nombre_filtro,filtro,nombre_senial,puntos,offset);

nombre_filtro="FiltroIIR_LP40Hz";filtro=FiltroIIR_LP40Hz;
filtroFIR(nombre_filtro,filtro,nombre_senial,puntos,offset);
%% funcion utilizada
function filtroFIR(nombre_filtro,filtro,nombre_senial,puntos,offset)
extra1="_Transformada";extra2="Puntos";%variables extra para nombres
arch = fopen(nombre_filtro+".txt", 'wt');%abre un archivo con el nombre del filtro
for i=length(filtro):-1:1               %y lo guarda de atras para adelante
fprintf(arch, '%.10f\n', filtro(i));    %para facilitar el procesado en C
end
fclose(arch);  
system("DSP4.exe "+nombre_filtro+" "+nombre_senial);    
%ejecuta el programa en C con el nombre del filtro y el nombre de la señal
original=load(nombre_senial+".txt");        %luego, carga ambos archivos
filtrado=load(nombre_senial+nombre_filtro+".txt");  %el original y el filtrado
figure();   %grafica ambas señales
subplot(211);
plot(original(2:length(original))); xlim([100 500]);grid on;
title("Señal original "+nombre_senial);
subplot(212);
plot(filtrado(2:length(filtrado))); xlim([100 500]);grid on;
title("Señal original "+nombre_senial+" con el filtro "+nombre_filtro+" aplicado");
%luego, realiza la transformada de ambas señales, la original y la filtrada
system("..\DSP3\DSP3.exe "+nombre_senial+" "+puntos+" "+offset)
system("..\DSP3\DSP3.exe "+nombre_senial+nombre_filtro+" "+puntos+" "+offset)
%vuelve a cargarlas
original=load(nombre_senial+extra1+puntos+extra2+".txt");
filtrado=load(nombre_senial+nombre_filtro+extra1+puntos+extra2+".txt");
figure();   %y grafica los resultados
subplot(211);
plot(original(2:length(original))); xlim([1 puntos]);grid on;
title("Transformada de la señal "+nombre_senial+" con "+puntos+" puntos");
subplot(212);
plot(filtrado(2:length(filtrado)));  xlim([1 puntos]);grid on;
title("Transformada de la señal "+nombre_senial+" filtrada con "+puntos+" puntos");

end
