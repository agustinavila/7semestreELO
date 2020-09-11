clear all; close all; clc;
T0=0.005; fin=200;
t(1)=0;
nd=[0 .0008826 0];  %valores de la FT discreta
dd=[1 -1.864 .8694];%para simulink
ref=1.5;            %entrada de referencia

% Primer prueba midiendo valores en lazo abierto:
sim('motorLA.slx');
plot(Salida),grid minor,xlim([0 .5]);title('Respuesta a lazo abierto');
%A partir de la grafica anterior se estiman los parametros
Tu=.03; %Tiempo de retardo puro estimado
Tg=.14; %Tiempo de subida estimado
Ke=.165;%Valor final de ganancia
K=((1.2*Tg)/(Ke*(Tu+(T0/2))))-((.3*Tg*T0)/(Ke*(Tu+(T0/2))^2));
Ki=(.6*Tg)/(K*Ke*(Tu+(T0/2))^2);
Td=.5*Tg/(K*Ke);
kp=K
ki=K*Ki
kd=K*Td
%Valores obtenidos aproximados:
% kp = 30;          ki=481;         kd=0.4242;
sim('motor.slx');
figure();
subplot(211),plot(Salida),grid;title('Salida para ZN-LA')
subplot(212),plot(Accioncontrol),grid;
title('Accion de control para ZN-LA');
Max=max(Accioncontrol.Data) %Valor maximo de la accion de control
% llega rapidamente al valor pedido pero la accion 
%de control llega casi a 20. Se prueban otros valores:

kp=30;
ki=280;
kd=.5;


A=-(kp+(kd/T0))
B=(kp+(2*kd/T0))
C=-kd/T0
D=ki*T0

for k=1:1:fin
    if (k>1)
        t(k)=t(k-1)+T0;
    end
    % La accion de control esta incluida en el mismo if
    % que el modelo del motor
    if (k>2)
        y(k)=1.864*y(k-1)-.8694*y(k-2)+.0008826*u(k-1);     %Salida
        u(k)=u(k-1)+A*y(k)+B*y(k-1)+C*y(k-2)+D*(ref-y(k-1));%Accioncontrol
    else
        if (k>1)
            y(k)=1.864*y(k-1)+.0008826*u(k-1);              %Salida   
            u(k)=u(k-1)+A*y(k)+B*y(k-1)+D*(ref-y(k-1));     %Accion control
        else
            y(k)=0;
            u(k)=0;
        end
    end 
    % establecimiento del período de muestro
    pause(.005);
end
Max=max(u) %Para comprobar que no exceda los 12V
figure();subplot(2,1,1); 
plot(t(1:fin),u(1:fin),'r');title("Acción de control");grid;
xlabel("tiempo [s]");ylabel("tension [V]");ylim([0 12]);

subplot(2,1,2); plot(t(1:fin),y(1:fin));grid;
title("Salida");xlabel("tiempo [s]");ylabel("\omega [rev/s]");

%% Comparacion entre los dos metodos
sim("motor.slx");
figure()
subplot(2,1,1); 
plot(t(1:fin),u(1:fin),'r'); hold on;
plot(t(1:fin),Accioncontrol.Data(1:fin),'k--');
legend(".m",".slx");
title("Acción de control");grid;
xlabel("tiempo [s]");
ylabel("tension [V]");ylim([0 12]);

subplot(2,1,2); 
plot(t(1:fin),y(1:fin));grid; hold on;
plot(tout(1:fin),Salida.Data(1:fin),'y--');
legend(".m",".slx");
title("Salida");
xlabel("tiempo [s]");
ylabel("\omega [rev/s]");
