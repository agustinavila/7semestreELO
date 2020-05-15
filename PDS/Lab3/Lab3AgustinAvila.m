%
clc;close all;
%% punto 1
%declaraciones temporales
F=100;
t=0:1/F:5;
tcorr=-5:1/F:5;
%declaracion de funciones
x1=6*sin(2*pi*6*t);
x2=3*cos(2*pi*6*t);
x3=5*ones(1,length(t));
x4=10*ones(1,length(t));
x5=urect((t-2.5)/3);
x6=urect((t-2.5)/.5);
x7=3*exp(-5*t);
x8=randn(1,length(t));
%% 1)a: obtencion y graficacion de correlaciones
xx1=grafcorr(x1,t,tcorr,'x1(t)');
xx2=grafcorr(x2,t,tcorr,'x2(t)');
xx3=grafcorr(x3,t,tcorr,'x3(t)');
xx4=grafcorr(x4,t,tcorr,'x4(t)');
xx5=grafcorr(x5,t,tcorr,'x5(t)');
xx6=grafcorr(x6,t,tcorr,'x6(t)');
xx7=grafcorr(x7,t,tcorr,'x7(t)');
xx8=grafcorr(x8,t,tcorr,'x8(t)');


%% 1.e
F0=1e8;
T0=1/F0;

%%%generacion de señal
duracion=500; comienzo=400; resto=400;
N=comienzo+duracion+resto;
signal=randn(1,duracion);
p=[zeros(1,comienzo),signal,zeros(1,resto)];
figure();
plot((1:N)*T0,p);axis([0 N*T0 -10 10]);
xlabel('tiempo');ylabel('p(t)');
title('pulso de radar transmitido');


%% punto 2


%% funciones auxiliares:
function xx=grafcorr(x,t,tcorr,nombre); %obtiene la correlacion y grafica
    xx=xcorr(x,x);
    figure('name', nombre+" autocorrelacionada");
    title("grafica de "+nombre+" y su autocorrelacion");
    subplot(2,1,1);
    plot(t,x);
    hold on;grid on;
    title(nombre);
    subplot(2,1,2);
    plot(tcorr,xx);
    hold on;grid on;
    title(nombre+" autocorrelacionada");
end