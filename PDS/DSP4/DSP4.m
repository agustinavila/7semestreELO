% Juan Agustin Avila
% Julio 2020
% Reg 26076 - ELO
clc;clear all;
load('filtros.mat');    %se carga el archivo con los valores de los filtros
%% Punto 1

FiltrosFIR=[FiltroFIR_HP150Hz;FiltroFIR_BP40_100Hz;FiltroFIR_LP40Hz];

%con filterDesigner se exportaba el filtro IIR como una
%matriz SOS y un vector de ganancia G, eso se paso a una FT
[a,b]=sos2tf(SOSHP150Hz,GHP150Hz);
FiltroIIR_HP150Hz=[b a];        %Y luego numerador y denominador se unieron
[a,b]=sos2tf(SOSBP,GBP);
FiltroIIR_BP40_100Hz=[b a];
[a,b]=sos2tf(SOSLP40Hz,GLP40Hz);
FiltroIIR_LP40Hz=[b a];
FiltrosIIR=[FiltroIIR_HP150Hz;FiltroIIR_BP40_100Hz;FiltroIIR_LP40Hz];

nombre_senial=["OndaCuadrada","Perro"];
puntos=[512 4096];
offset=[10 500];
for j=1:length(nombre_senial)
    Nombres=["FiltroFIR_HP150Hz","FiltroFIR_BP40_100Hz","FiltroFIR_LP40Hz"];
    n=length(Nombres);
    for i=1:n
        nombre_filtro=Nombres(i);
        filtro=FiltrosFIR(i,:);
        filt(nombre_filtro,filtro,nombre_senial(j),puntos(j),offset(j));
    end
    
    %% filtros IIR
    Nombres=["FiltroIIR_HP150Hz","FiltroIIR_BP40_100Hz","FiltroIIR_LP40Hz"];
    for i=1:n
        nombre_filtro=Nombres(i);
        filtro=FiltrosIIR(i,:);
        filt(nombre_filtro,filtro,nombre_senial(j),puntos(j),offset(j));
    end
end

%% Graficacion en arduino:
figure();
for i=1:n
    nombre=Nombres(i);
    subplot((n*100)+10+i);
    graficacionfunciones(nombre,nombre_senial(1));
end


%% Realizacion del ecualizador
puntos=2048; ts=11025;
Gtotal=eye(5);  %Matriz identidad para probar cada filtro
for i=1:5
    ganancia=Gtotal(i,:);   %selecciona la columna I
    sim('ecualizador.slx');
    transformada=fft(Salida.Data,puntos);
    figure();
    plot((1:puntos),abs(transformada)); grid; xlim([1 puntos/2]);
    title("Respuesta frecuencial en la banda "+i);
end
puntos=4096;
ganancia=[1 1 1 1 1];       %Ganancias unitarias
sim('ecualizador.slx');
transformada=fft(Salida.Data,puntos);
figure();
plot((1:puntos),abs(transformada));
ganancia=[.001 4 8 2 .1]; %distintas ganancias por banda
sim('ecualizador.slx');
transformada=fft(Salida.Data,puntos);
hold on; grid on; 
plot((1:puntos),abs(transformada));xlim([1 puntos/2]);
legend("Señal con ganancias unitarias","Señal con distintas ganancias");
title("Comparacion entre señal original y con distintas ganancias");
%% funciones utilizadas
function filt(nombre_filtro,filtro,nombre_senial,puntos,offset)
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
    plot(original(2:length(original))); xlim([offset puntos]);grid on;
    title("Señal "+nombre_senial+" original");
    subplot(212);
    plot(filtrado(2:length(filtrado))); xlim([offset puntos]);grid on;
    title("Señal "+nombre_senial+" con el filtro "+nombre_filtro+" aplicado");
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
    title("Transformada de "+puntos+" puntos de la señal "+nombre_senial+" filtrada con "+nombre_filtro);

end

function graficacionfunciones(nombre,nombre_senial) %%abre el archivo y lo grafica
    arch=load(nombre_senial+nombre+"Arduino.txt");
    plot(arch(2:length(arch)));
    title("señal '"+nombre_senial+"' fitrada con el filtro "+nombre+" en arduino");   %Agrega titulo
    grid on;xlim([20 140]);
end