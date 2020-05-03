clc; close all;
db=-5;   %valor del snr en db
trabajo(db);
db=0;
trabajo(db);

function trabajo(snrdb)
A=1;        %amplitud de las seï¿½ales
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
%grafica la seï¿½al original:
graficatemporal(t,xt,"Señal original",snrdb);
%se le aï¿½ade ruido
pot=sum(xt.*xt)/length(xt);     %potencia de la seï¿½al
pn=pot/(10^(snrdb/10));         %potencia del ruido
xts=xt+sqrt(pn)*randn(1,length(xt));  %seï¿½al con el ruido agregado
%se hace la grafica temporal y luego el espectro de ambas
graficatemporal(t,xts,"Señal original con ruido agregado",snrdb);
graficaespectro(xt,xts,n,"señal original y señal con ruido",snrdb)

%***************diseï¿½o de los filtros*************
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
% comparandolo con la seï¿½al original con ruido
graficatemporal(t,xfiltrada,"Suma de señales filtradas",snrdb);
graficaespectro(xts,xfiltrada,n,"la señal con ruido y la señal filtrada",snrdb);
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
    plot(fshift,ampshift); %espectro de la señal original
    hold on; grid on;
    z=abs(fft(x2));
    y=fftshift(z);
    ampshift=abs(y).^2/n;
    plot(fshift,ampshift); %espectro de la señal originalplot(zr);%espectro con ruido agregado
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