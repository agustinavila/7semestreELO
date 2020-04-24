clc; close all;
%**************** Punto 1 *************************
%Funciones continuas
t=-6:0.01:10; %base temporal de señales continuas
x1t=6*sin(2*pi*t);
x2t=5*ustep(t-3);
x3t=4*tri((t+2)/4);
x4t=x1t+x2t+x3t;

%Graficacion de funciones continuas
figure('Name','Grafica de funciones continuas');
subplot(2,2,1); plot(t,x1t);
title('x1(t)=6*sen(2*pi*t)');
grid on; hold on;
subplot(2,2,2); plot(t,x2t);
title('x2(t)=5*u(t-3)');
grid on;
subplot(2,2,3); plot(t,x3t);
title('x3(t)=4*tri[(t+2)/4]');
grid on;
subplot(2,2,4); plot(t,x4t);
title('x4(t)=x1(t)+x2(t)+x3(t)');
grid on;


%Funciones discretas
n=-6:0.25:10;
x1n=6*sin(2*pi*n);
x2n=5*ustep(n-3);
x3n=4*tri((n+2)/4);
x4n=x1n+x2n+x3n;

%Graficacion de funciones discretas
figure('Name','Grafica de funciones discretas');
subplot(2,2,1); dtplot(n,x1n);
title('x1(n)=6*sen(2*pi*n)');
grid on;hold on;
subplot(2,2,2); dtplot(n,x2n);
title('x2(n)=5*u(n-3)');
grid on;
subplot(2,2,3); dtplot(n,x3n);
title('x3(n)=4*tri[(n+2)/4]');
grid on;
subplot(2,2,4); dtplot(n,x4n);
title('x4(n)=x1(n)+x2(n)+x3(n)');
grid on;

%Obtencion de maximos de x4(t) y x4(n)
M4c=max(x4t)
M4d=max(x4n)
iM4c=find(x4t==M4c);
iM4d=find(x4n==M4d);
tM4c=t(iM4c)	
tM4d=n(iM4d)


%************** Punto 2 *******************
n=-30:1:30;     %paso unitario
t=-30:0.01:30;  %paso de 0.01
y1n=2*cos((pi/2)*n).*sin((pi/6)*n);
y2n=2*cos((pi/2)*n)+cos((pi/5)*n);
y3n=5*sin((pi/8)*n+pi/4)+5*cos((pi*n)/5-pi/4);
y4n=cos(0.8*n);
y1t=2*cos((pi/2)*t).*sin((pi/6)*t);
y2t=2*cos((pi/2)*t)+cos((pi/5)*t);
y3t=5*sin(((pi*t)/8)+pi/4)+5*cos((pi*t)/5-pi/4);
y4t=cos(0.8*t);

%graficacion de funciones
figure('Name','y1(n), y1(t)'); 
dtplot(n,y1n); hold on; grid on; plot(t,y1t);
figure('Name','y2(n), y2(t)'); 
dtplot(n,y2n); hold on; grid on; plot(t,y2t);
figure('Name','y3(n), y3(t)'); 
dtplot(n,y3n); hold on; grid on; plot(t,y3t);
figure('Name','y4(n), y4(t)'); 
dtplot(n,y4n); hold on; grid on; plot(t,y4t);

%buscar periodo de las funciones
N1=lcm(4,12)
N2=lcm(4,10)
N3=lcm(16,10)

%Laboratorio Nº 1 - Ejercicio 3
%Operaciones Básicas con Señales Discretas
%---------------------------------------------------------------
% Inicialización
clear all;
close all;
% Adquisición de audio con Fs
Fs=11025; % Este valor puede ser modificado para experimentar
r=audiorecorder(Fs,8,1);%estas tres lineas
recordblocking(r,3)     %reemplazan al comando
x=getaudiodata(r);      %wavrecord
soundsc(x, Fs);
input('sonido original');
N = length(x);
%---------------------------------------------------------------
% Generación de eco mediante la suma de la versión retrasada de la señal.
delay = 0.4 % Este valor puede ser modificado para experimentar
atten = 0.5 % Este valor puede ser modificado para experimentar
n0 = round(delay.*Fs)
n_ext = [1:1:N+n0]';
x_delay(n0+1:N+n0) = x(n_ext(n0+1:N+n0)-n0);
x_delay=x_delay(:); %se transpolo este vector para evitar errores
x_extend = x;
x_extend(N+1:N+n0) = zeros(1,n0);
y = x_extend + atten.*x_delay;  %si no aqui generaba una matriz enorme
t_extend = (n_ext-1)./Fs;
subplot(2,1,1), plot(t_extend,x_extend);
xlabel('t seg');
title('Sonido Original');
soundsc(x,Fs);
input('Sonido con Eco')
subplot(2,1,2), plot(t_extend,y);
xlabel('t seg');
title('Sonido con Eco');
soundsc(y,Fs);
%---------------------------------------------------------------
% Reflexión
n = 1:1:N;
minus_n = N+1 - n;
z = x(minus_n);
t = (n-1)./Fs;
input('Sonido Original')
figure;
subplot(2,1,1), plot(t, x);
xlabel('t seg');
title('Sonido Original');
soundsc(x,Fs);
input('Sonido Reflejado')
subplot(2,1,2), plot(t, z);
xlabel('t seg');
title('Sonido Reflejado');
soundsc(z,Fs);
%---------------------------------------------------------------
% Submuestreo por 2 - Decimación
%Procesamiento Digital de Señales Ciclo 2020 Laboratorio 1
z = zeros(1,N);
z(1:ceil(N/2)) = x(1:2:N);
z(ceil(N/2)+1:N) = zeros(1,N-ceil(N/2));
input('Sonido Original')
figure;
subplot(2,1,1), plot(t,x);
xlabel('t seg');
title('Sonido Original');
soundsc(x,Fs);
input('Sonido Submuestreado por 2')
subplot(2,1,2), plot(t,z);
xlabel('t sec');
title('Sonido Submuestreado por 2');
soundsc (z,Fs);
%---------------------------------------------------------------
% Sobremuestreo por 2
z = zeros(1,2.*N);
z(1:2:2.*N) = x(1:N);
x_extend(N+1:2.*N) = zeros(1,N);
n_extend = 1:1:2.*N;
t_extend = n_extend./Fs;
input('Sonido Original')
figure;
subplot(2,1,1), plot(t_extend,x_extend);
xlabel('t seg');
title('Sonido Original');
soundsc(x,Fs);
input('Sonido Sobremuestreado por 2')
subplot(2,1,2), plot(t_extend,z);
xlabel('t seg');
title('Sonido Sobremuestreado por 2');
soundsc(z,Fs);

