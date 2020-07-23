%%%punto 1
nc=1;                           %numerador continuo
dc=[.4 4.2 3];                  %Denominador cont.
T0=.5;                          %Tiempo de muestreo
[nd,dd]=c2dm(nc,dc,T0,'zoh')    %nd y dd son los valores discretos  
ndc=[9.4518 -6.5019 0.0491];    %Denominador del controlador
ddc=[1 -0.8251 -0.1748];        %Numerador del controlador
sim('Punto1.slx');              %Simula el modelo armado
%% graficacion
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