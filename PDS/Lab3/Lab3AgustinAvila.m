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

% 1.e
F0=1e8;
T0=1/F0;
%%%generacion de señal
duracion=500; comienzo=400; resto=400;
N=comienzo+duracion+resto;
t1=0:T0:T0*(N-1);
signal=randn(1,duracion);
p=[zeros(1,comienzo),signal,zeros(1,resto)];
figure();
plot((1:N)*T0,p);axis([0 N*T0 -10 10]);
xlabel('tiempo');ylabel('p(t)');
title('pulso de radar transmitido');
una vez obtenida la respuesta del pulso, se cargan ambos datos:
%una vez obtenida la respuesta, se analiza el retraso:
load('RespuestaRadarAgustinAvila.mat');
load('PulsoRadarAgustinAvila.mat');
%x=[zeros(1,10000),p,zeros(1,resto+24700)]; %prueba un retraso de 0.1 ms
ret=xcorr(x,p);                 % correlación entre x y p
tx=0:T0:T0*(length(x)-1);       % base temporal para graficar la respuesta
tret=-T0*(length(x)-1):T0:T0*(length(x)-1);
%como p se rellena con ceros, la longitud total de la correlacion
%va desde -tx(maximo adelanto) hasta tx(maximo atraso)
[v,i]=max(ret);                 % valor y posicion del maximo de correlacion
retardo=tret(i)*1000            %valor del retardo en ms
d=((3e5)*(retardo/1000))/2      %c en km, retardo en seg.
figure();
plot(tx,x);grid;title('Respuesta del pulso');
xlabel('tiempo(s)');ylabel('amplitud');
figure();
plot(tret,ret);grid;title('Correlacion entre la señal y su respuesta');
xlabel('tiempo(s)');ylabel('amplitud');

%% punto 2

t=0:0.1/200:0.1;
x1=cos(90*pi*t);
x2=cos(150*pi*t);
S1=200;S2=100;S3=50;
reconstruccion(x1,x2,t,S1);
reconstruccion(x1,x2,t,S2);
reconstruccion(x1,x2,t,S3);


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

function reconstruccion(x1,x2,t,S);
    x=x1+x2;
    tn=0:1/S:0.1;
    [fa1 fd1]=alias(45,S); [fa2 fd2]=alias(75,S);
    xn1=cos(90*pi*tn);
    xn2=cos(150*pi*tn);
    xn=xn1+xn2;
    xr1=cos(2*pi*fa1*t);
    xr2=cos(2*pi*fa2*t);
    xr=xr1+xr2;
    fd1*S
    fd2*S
    %graficacion:
    figure();
    subplot(311);
    plot(t,x1,'b','LineWidth',2);
    hold on;
    plot(t,xr1,'g');
    dtplot(tn,xn1);
    grid;title("Graficacion de x1(t), xr1(t) y xn1[n] para S="+S);
    legend('x1(t)','xr1(t)','xn1[n]');
    
    subplot(312);
    plot(t,x2,'b','LineWidth',2);
    hold on; 
    plot(t,xr2,'g');
    dtplot(tn,xn2);
    grid; title("Graficacion de x2(t), xr2(t) y xn2[n] para S="+S);
    legend('x2(t)','xr2(t)','xn2[n]');
    
    subplot(313);
    plot(t,x,'b','LineWidth',2);
    hold on; 
    plot(t,xr,'g');
    dtplot(tn,xn);
    grid;title("Graficacion de x(t), xr(t) y xn[n] para S="+S);
    legend('x(t)','xr(t)','xn[n]');
end
