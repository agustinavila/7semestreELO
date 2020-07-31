Juan Agustin Avila
Reg 26076 - julio 2020
clc;clear all;

%% Punto 2:
arch5=load("ts5.txt");
arch10=load("ts10.txt");
arch30=load("ts30.txt");
arch5=arch5*5/1024;
arch10=arch10*5/1024;
arch30=arch30*5/1024;
t5=0:0.005:length(arch5)*0.005;
t10=0:0.01:length(arch10)*0.01;
t30=0:0.03:length(arch30)*0.03;
figure();
subplot(311);plot(t5(1:length(t5)-1),arch5);
xlim([0 1]);title("Reconstruccion con Ts=5ms");
grid on;
subplot(312);plot(t10(1:length(t10)-1),arch10);
xlim([0 1]);title("Reconstruccion con Ts=10ms");
grid on;
subplot(313);plot(t30(1:length(t30)-1),arch30);
xlim([0 1]);title("Reconstruccion con Ts=30ms");
grid on;
%% Punto 3: Filtro promediador
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
%grafica con arduino:
arch10=load("ts10.txt");
arch10prom=load("promarduino.txt");
arch10=arch10*5/1024;
arch10prom=arch10prom*5/1024;
t10=0:0.01:length(arch10)*0.01;
t10prom=0:0.01:length(arch10prom)*0.01;
figure();
subplot(211);plot(t10(1:length(t10)-1),arch10);
xlim([0 1]);title("Señal original");
grid on;
subplot(212);plot(t10prom(1:length(t10prom)-1),arch10prom);
xlim([0 1]);title("Señal promediada");
grid on;

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
grafica con arduino:
arch10=load("ts10.txt");
arch10p4=load("punto4arduino.txt");
arch10=arch10*5/1024;
arch10p4=arch10p4*5/1024;
t10=0:0.01:length(arch10)*0.01;
t10p4=0:0.01:length(arch10p4)*0.01;
figure();
subplot(211);plot(t10(1:length(t10)-1),arch10);
xlim([0 1]);title("Señal original");
grid on;
subplot(212);plot(t10p4(1:length(t10p4)-1),arch10p4);
xlim([0 1]);title("Señal con la funcion aplicada");
grid on;
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