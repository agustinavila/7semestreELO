clc;close all;
%% punto 1.1
n=1;d=[1 3 2];          %se cargan los valores de num y denom
G=tf(n,d)               %se arma la funcion de transferencia
t=stepinfo(G)          %se analiza la respuesta al escalon
t=t.RiseTime;       %Se le asigna el t de establecimiento
T0=t/15                 %se busca un tiempo de muestreo     
p=pole(G)               %Se obtienen los polos de la planta
T0=.1;
%% punto 1.2

[nd,dd]=c2dm(n,d,T0,'zoh')
Gz=c2d(G,T0,'zoh')



%% punto 1.3
ki=0;kd=0;  %define kd y ki=0 para variar solo kp
mkp=2;  %los m son los "pasos" que dara en cada prueba
nkp=2;  %para fijar una constante, se elige m*n
mkd=2;  %En este caso, kp=mkp*nkp=2*2=4, kd=2*1=2
nkd=1;  %se usaron estas variables para facilitar
mki=1;  %el uso de distintos rangos

figure();
Legend=cell(5,2);% Arreglo de celdas para nombrar señales en la grafica
for i=1:5               %hace 5 iteraciones, desde 1 hasta 5
    kp=mkp*i;           %kp varia desde mkp*1 hasta mkp*5
    sim('punto1.slx');  %simula la planta en simulink
    subplot(2,1,1);     %grafica la salida en la parte superior
    plot(Salida); 
    Legend{i,1}="Salida con Kp="+kp;
    hold on;
    subplot(2,1,2);
    plot(Accioncontrol);%Grafica la accion de control
    hold on;
    Legend{i,2}="Accion con Kp="+kp;
end
subplot(2,1,1); %fuera del bucle, se vuelve a la grafica superior
title('Salida de la planta variando el Kp');
legend(Legend{:,1});grid on; %agrega todos los nombres de las señales
subplot(2,1,2);
title('Accion del controlador variando el Kp');
legend(Legend{:,2});grid on;

%% para kd
kp=mkp*nkp;     %Fija el Kp en un valor dado por m*n
figure();
Legend=cell(6,2);
for i=0:5       %En este caso se comienza el bucle desde cero para
    kd=mkd*i;   %graficar la respuesta sin la accion derivativa
    sim('punto1.slx');
    subplot(2,1,1);
    plot(Salida); 
    Legend{i+1,1}="Salida con Kd="+kd;
    hold on;
    subplot(2,1,2);
    plot(Accioncontrol);
    hold on;
    Legend{i+1,2}="Accion con Kd="+kd;
end
subplot(2,1,1);
title("Salida de la planta variando el Kd con Kp="+kp);
legend(Legend{:,1});grid on;
subplot(2,1,2);
title("Accion del controlador variando el Kd con Kp="+kp);
legend(Legend{:,2});grid on;

%% para ki (procedimiento igual a kd)
kd=mkd*nkd;     
figure();
Legend=cell(6,2);
for i=0:5
    ki=mki*i;
    sim('punto1.slx');
    subplot(2,1,1);
    plot(Salida); 
    Legend{i+1,1}="Salida con Ki="+ki;
    hold on;
    subplot(2,1,2);
    plot(Accioncontrol);
    hold on;
    Legend{i+1,2}="Accion con Ki="+ki;
end
subplot(2,1,1);
title("Salida de la planta variando el Ki con Kp="+kp+" y Kd="+kd);
legend(Legend{:,1});grid on;
subplot(2,1,2);
title("Accion del controlador variando el Ki con Kp="+kp+" y Kd="+kd);
legend(Legend{:,2});grid on;



