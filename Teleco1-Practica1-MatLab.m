% Trabajo practico 1: MatLab
% Materia: Telecomunicaciones I
% Año 2020
%
% 2 Consignas
% 
% 2.1 Generar una señal  que contenga frecuencias de: 110Hz,
% 355Hz, 810Hz y 1550Hz cada una, con igual magnitud. Elija 
% una frecuencia de muestreo apropiada. (Cada grupo deberá 
% multiplicar. las frecuencias dadas, por su número de grupo,
% para obtener las frecuencias de trabajo)
% 
% 2.3 Sumarle ruido blanco a la señal tal que la relación señal
% a ruido sea de –5dB.
% 
% 2.4 Diseñe cuatro filtros apropiados tipo Chebyshev y/o 
% Butterworth, selectivamente filtre las cuatro sinusoides
% desde la señal ruidosa y luego recombínelas. Realice la 
% comparación amplitud/tiempo entre la señal original y la 
% señal ruidosa, filtrada. Hágalo mediante un programa MATLAB
% y presente el listado del mismo.
% 
% 2.5  Repita el punto 2.3, con una relación señal a ruido 
% de 0dB y luego repita el punto 2.4. Observe que diferencia
% existe con el punto anterior. Saque sus conclusiones.
% 
% Nota Importante: En cada etapa, obtener las señales 
% amplitud/tiempo y magnitud/frecuencia/. Explique el significado
% de los resultados. Rotule apropiadamente los gráficos. Además, 
% debe dar una representación gráfica de los filtros diseñados. 
% (Características de transferencia de magnitud y de fase).


%**Importante: Este script usa funciones asi que funciona a partir de matlab 2016

clc; close all;
db=-5;   %valor del snr en db
trabajo(db);
db=0;
trabajo(db);

function trabajo(snrdb)
A=1;        %amplitud de las se�ales
n=5;        %numero de grupo
f1=110*n;   %declaracion de las frecuencias
f2=355*n;
f3=810*n;
f4=1550*n;
t=0.0:.000025:.2;       %matriz temporal
x1=A*cos(2*pi*f1*t);    %declaracion de las funciones
x2=A*cos(2*pi*f2*t);
x3=A*cos(2*pi*f3*t);
x4=A*cos(2*pi*f4*t);
xt=x1+x2+x3+x4;         %suma de todas las funciones
%grafica la se�al original:
graficatemporal(t,xt,"Se�al original",snrdb);
%se le a�ade ruido
pot=sum(xt.*xt)/length(xt);     %potencia de la se�al
pn=pot/(10^(snrdb/10));         %potencia del ruido
xts=xt+sqrt(pn)*randn(1,length(xt));  %se�al con el ruido agregado
%se hace la grafica temporal y luego el espectro de ambas
graficatemporal(t,xts,"Se�al original con ruido agregado",snrdb);
graficaespectro(xt,xts,n,"se�al original y se�al con ruido",snrdb)

%***************dise�o de los filtros*************
xfilt1=filtro(f1,xts);
xfilt2=filtro(f2,xts);
xfilt3=filtro(f3,xts);
xfilt4=filtro(f4,xts);

%********* graficacion de los filtros***********
off=.1;                    %offset para graficar asi no comienta en t=0
graficafiltro(t,f1,xfilt1,"f1",off,snrdb);
graficafiltro(t,f2,xfilt2,"f2",off,snrdb);
graficafiltro(t,f3,xfilt3,"f3",off,snrdb);
graficafiltro(t,f4,xfilt4,"f4",off,snrdb);

xfiltrada=xfilt1+xfilt2+xfilt3+xfilt4; %suma las amplitudes
% Se grafica temporalmente la suma de los filtros y tambien su espectro
% comparandolo con la se�al original con ruido
graficatemporal(t,xfiltrada,"Suma de se�ales filtradas",snrdb);
graficaespectro(xts,xfiltrada,n,"la se�al con ruido y la se�al filtrada",snrdb);
end

function graficatemporal(t,x,nombre,snrdb)
figure('Name',nombre+" con un SNR de "+snrdb+"dB");
plot(t,x);
title(nombre+" con un SNR de "+snrdb+"dB");
xlabel('frecuencia?');ylabel('Amplitud');
xlim([.1 .11]); grid on;
end

function graficaespectro(x1,x2,n,graficas,snrdb)
    z=abs(fft(x1));
    a=length(z);
    fs=40000;
    y=fftshift(z);
    fshift=(-a/2:a/2 -1)*fs/a;
    ampshift=abs(y).^2/n;
    figure('Name',"espectro entre "+graficas+" para un SNR de"+snrdb+"dB");
    plot(fshift,ampshift); %espectro de la se�al original
    hold on; grid on;
    z=abs(fft(x2));
    y=fftshift(z);
    ampshift=abs(y).^2/n;
    plot(fshift,ampshift); %espectro de la se�al originalplot(zr);%espectro con ruido agregado
    title("espectro entre "+graficas+" para un SNR de "+snrdb+"dB");
    xlabel('frecuencia?');ylabel('Amplitud');
    xlim([-10000 10000]);
end

function xfilt=filtro(f,x)
wn=[f*.9 f*1.1]/20000;%la frecuencia de muestreo es 40000
[b,a]= butter(4,wn);
xfilt=filter(b,a,x); 
end

function graficafiltro(t,f,filtro,nombre,off,snrdb)
    figure('Name',"Filtro butterworth para "+nombre);
    plot(t,filtro);
    title("Filtro butterworth de orden 4 para "+nombre+" con un SNR de "+snrdb+"dB");
    xlabel('frecuencia?');ylabel('Amplitud');
    grid minor; grid on;
    xlim([off off+(20/f)]);  %grafica 20 periodos a partir de t=0,1
end