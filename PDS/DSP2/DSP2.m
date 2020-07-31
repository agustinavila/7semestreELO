% Juan Agustin Avila
% Reg 26076 - julio 2020

%% Punto 3: Filtro promediador
clc;clear all;
%% graficacion de funciones originales y sin valores medios:
figure();    %genera la figura
subplot(211);                   % en la figura superior grafica la original
arch=load("OndaCuadrada.txt"); 
Fs=arch(1);                     %guarda Fs
n=0:1/Fs:(length(arch)-2)/Fs;   %Genera base temporal en base a Fs y la longitud
plot(n,arch(2:length(arch))); %Grafica la funcion
title('Onda Cuadrada Original');   %Agrega titulo
grid;
subplot(212);                   %repite el proceso para la funcion sin Vmedio
arch2=load("OndaCuadradaPromedio.txt"); 
plot(n,arch2(2:length(arch2))); %Grafica la funcion
title("Onda promediada");   %Agrega titulo
grid;


%% Punto 4: Aplicacion de funcion
figure();    %genera la figura
subplot(211);                   % en la figura superior grafica la original
arch=load("OndaCuadrada.txt"); 
Fs=arch(1);                     %guarda Fs
n=0:1/Fs:(length(arch)-2)/Fs;   %Genera base temporal en base a Fs y la longitud
plot(n,arch(2:length(arch))); %Grafica la funcion
title('Onda Cuadrada Original');   %Agrega titulo
grid;
subplot(212);                   %repite el proceso para la funcion sin Vmedio
arch2=load("OndaCuadradaPunto4.txt"); 
plot(n,arch2(2:length(arch2))); %Grafica la funcion
title("Onda con funcion aplicada");   %Agrega titulo
grid;
 
 
%% Punto 5:  archivo wav


[x,Fs] = audioread('Perro.wav');
N = length(x);

% Promediador:
previo=x(1);
prom=previo;
for i=1:length(x)
    salida=(x(i)+previo)/2;
    previo=x(i);
    prom=[prom;salida];
end
soundsc(prom,Fs);
input('Sonido promediado')
% Generación de eco mediante la suma de la versión retrasada de la señal.
delay = 0.3 % Este valor puede ser modificado para experimentar
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