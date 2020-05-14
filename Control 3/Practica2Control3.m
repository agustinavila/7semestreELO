% nc=1;                           %numerador continuo
% dc=[.4 4.2 3];                  %Denominador cont.
% T0=.5;                          %Tiempo de muestreo
% [nd,dd]=c2dm(nc,dc,T0,'zoh')    %nd y dd son los valores discretos  
% figure();
% plot(H2C);
% hold; grid;
% plot(H2D);
% title('Respuesta al escalon de G(s) y G(z)');
% legend('G(s)','G(z)');

nc=1;                           %numerador continuo
dc=[.0000001 .0001 1];          %Denominador cont.
T1=.0005;T2=.002;               %Tiempo de muestreo
[nd,dd]=c2dm(nc,dc,T1,'zoh')    %nd y dd son los valores discretos 
[nd2,dd2]=c2dm(nc,dc,T2,'zoh')    %nd y dd son los valores discretos
figure();
plot(Voc);
hold; grid;
plot(Vod1);
title('Respuesta al escalon de G(s) y G(z) con T1=0,5ms');
legend('G(s)','G1(z)');
figure();
plot(Voc);
hold; grid;
plot(Vod2);
title('Respuesta al escalon de G(s) y G(z) con T1=2ms');
legend('G(s)','G2(z)');