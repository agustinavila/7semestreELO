clc;clear all;
%% punto 2
%analisis de la planta
n=1;d=[.0000001 .0001 1];
H=tf(n,d);
pp=pole(H);
T0=.0002;
st=stepinfo(H)
step(H,st.PeakTime);grid
[nd,dd]=c2dm(n,d,T0,'zoh')

%% primer aproximacion
Tu=.0002;
Tg=.0006;
Ke=1.6;
K=((1.2*Tg)/(Ke*(Tu+(T0/2))))-((.3*Tg*T0)/(Ke*(Tu+(T0/2))^2));
Ki=(.6*Tg)/(K*Ke*(Tu+(T0/2))^2);
Td=.5*Tg/(K*Ke);
kp=K
ki=K*Ki
kd=K*Td
sim('punto2.slx');
figure();
subplot(2,1,1);     
plot(Salida); 
grid;title("Salida del sistema");
subplot(2,1,2);
plot(Accioncontrol);
grid;title("Accion de control")


%% variando el Tu
figure();
for i=1:5
    Tu=.0002+i*.00003
    K=((1.2*Tg)/(Ke*(Tu+(T0/2))))-((.3*Tg*T0)/(Ke*(Tu+(T0/2))^2));
    Ki=(.6*Tg)/(K*Ke*(Tu+(T0/2))^2);
    Td=.5*Tg/(K*Ke);
    kp=K
    ki=K*Ki
    kd=K*Td
    sim('punto2.slx');  %simula la planta en simulink
    subplot(2,1,1);     %grafica la salida en la parte superior
    plot(Salida); 
    Legend{i,1}="Salida con Tu="+Tu;
    hold on;
    subplot(2,1,2);
    plot(Accioncontrol);%Grafica la accion de control
    hold on;
    Legend{i,2}="Accion con Tu="+Tu;
end
subplot(2,1,1); %fuera del bucle, se vuelve a la grafica superior
title('Salida de la planta aumentando el Tu');
legend(Legend{:,1});grid on; %agrega todos los nombres de las señales
subplot(2,1,2);
title('Accion del controlador aumentando el Tu');
legend(Legend{:,2});grid on;


%% variando el Tg
Tu=.00035
figure();
Legend=cell(5,2);% Arreglo de celdas para nombrar señales en la grafica
for i=1:5               %hace 5 iteraciones, desde 1 hasta 5
    Tg=.0003+.0001*i
    K=((1.2*Tg)/(Ke*(Tu+(T0/2))))-((.3*Tg*T0)/(Ke*(Tu+(T0/2))^2));
    Ki=(.6*Tg)/(K*Ke*(Tu+(T0/2))^2);
    Td=.5*Tg/(K*Ke);
    kp=K
    ki=K*Ki
    kd=K*Td
    sim('punto2.slx');  %simula la planta en simulink
    subplot(2,1,1);     %grafica la salida en la parte superior
    plot(Salida); 
    Legend{i,1}="Salida con Tg="+Tg;
    hold on;
    subplot(2,1,2);
    plot(Accioncontrol);%Grafica la accion de control
    hold on;
    Legend{i,2}="Accion con Tg="+Tg;
end
subplot(2,1,1); %fuera del bucle, se vuelve a la grafica superior
title('Salida de la planta variando Tg');
legend(Legend{:,1});grid on; %agrega todos los nombres de las señales
subplot(2,1,2);
title('Accion del controlador variando Tg');
legend(Legend{:,2});grid on;


%% grafica final, con los parametros finales elegidos
Tu=.00035;
Tg=.0004;
K=((1.2*Tg)/(Ke*(Tu+(T0/2))))-((.3*Tg*T0)/(Ke*(Tu+(T0/2))^2));
Ki=(.6*Tg)/(K*Ke*(Tu+(T0/2))^2);
Td=.5*Tg/(K*Ke);
kp=K
ki=K*Ki
kd=K*Td
sim('punto2.slx');
figure();
subplot(2,1,1);     
plot(Salida); 
grid;title("Salida del sistema");
subplot(2,1,2);
plot(Accioncontrol);
grid;title("Accion de control")