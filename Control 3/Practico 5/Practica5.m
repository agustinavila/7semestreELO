%% punto 1
nc=1;                           %numerador continuo
dc=[.4 4.2 3];                  %Denominador cont.
T0=.5;                          %Tiempo de muestreo
[nd,dd]=c2dm(nc,dc,T0,'zoh')    %nd y dd son los valores discretos
q0=1/sum(nd)
q1=dd(2)*q0
q2=dd(3)*q0
p1=nd(2)*q0
p2=nd(3)*q0
ndc=[q0 q1 q2];                 %Denominador del controlador
ddc=[1 -p1 -p2];                %Numerador del controlador
sim('Punto1.slx');              %Simula el modelo armado
% graficacion
figure();
plot(Entrada);
hold on; grid minor;
plot(Salida);
legend('r(t)','H2(t)');ylim([0 1.2]);
title('H2(t) ante una entrada escalon unitaria');
xlabel('tiempo (s)'),ylabel('altura (m)');
figure();
plot(Entrada);hold on; grid on;
plot(AccionControl);
legend('r(t)','q_0(t)');ylim([0 10]);
title('q0(t) ante una entrada escalon unitaria');
xlabel('tiempo (s)'),ylabel('caudal');


%%punto2

R=8;L=.08;Te=L/R;Kem=0.67;
J=2.22*10^-3;f=1.86*10^-3;Tm=J/f;
Tcarga=0.1;
sim('punto2.slx');
figure();
plot(Entrada);
hold on; grid on;
plot(VelocidadRPM);
title('Relacion entre tension de armadura y velocidad en RPM');
legend('Velocidad','Va');
xlabel('tiempo(s)');
%Para obtener el modelo discreto del motor en vacio:
G1=tf(1/R,[Te 1]);
G2=tf(1/f,[Tm 1]);
wc=feedback(G1*G2*Kem,Kem);
T0=0.02;
[nc,dc]=tfdata(wc,'v');
[nd,dd]=c2dm(nc,dc,T0,'zoh')
q0=1/sum(nd)
q1=dd(2)*q0
q2=dd(3)*q0
p1=nd(2)*q0
p2=nd(3)*q0
sim('punto2.slx');
figure();
plot(AccionControl);
title("Accion de control aplicada con una carga de 2Nm a los 0.1s");
grid on;
figure();
plot(Entrada);
grid on;hold on;
plot(VelocidadRPM);
title('Respuesta del motor con carga de 2Nm a los 0.1s');
legend('referencia velocidad','Velocidad del motor')
xlabel('tiempo(s)'),ylabel('velocidad (RPM)');


%% punto 3
nc=1;                           %numerador continuo
dc=[.0000001 .0001 1];          %Denominador cont.
T0=.0002;                       %Tiempo de muestreo
[nd,dd]=c2dm(nc,dc,T0,'zoh')    %nd y dd son los valores discretos 
q0=1/sum(nd)
q1=dd(2)*q0
q2=dd(3)*q0
p1=nd(2)*q0
p2=nd(3)*q0
sim('Punto3.slx');
figure();
plot(Entrada);
hold on; grid on;
plot(Salida);
title("Entrada y salida del sistema controlado");
legend('referencia','Salida');
xlabel('tiempo'),ylabel('Tension');

%% punto 4
nc=1;                           %numerador continuo
dc=[.4 4.2 3];                  %Denominador cont.
T0=.5;                          %Tiempo de muestreo
[nd,dd]=c2dm(nc,dc,T0,'zoh')    %nd y dd son los valores discretos
ndc=[dd];                 %Denominador del controlador
ddc=[nd 0 0]-[0 0 nd];                %Numerador del controlador
ddc=ddc(2:end)
sim('Punto1.slx');              %Simula el modelo armado
% graficacion
figure();
plot(Entrada);
hold on; grid;
plot(Salida);
legend('r(t)','H2(t)');
title('H2(t) ante una entrada escalon unitaria');
xlabel('tiempo (s)'),ylabel('altura (m)');
figure();
plot(Entrada);hold on; grid on;
plot(AccionControl);
legend('r(t)','q_0(t)');
title('q0(t) ante una entrada escalon unitaria');
xlabel('tiempo (s)'),ylabel('caudal');