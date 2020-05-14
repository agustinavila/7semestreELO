%%%punto 1
nc=1;                           %numerador continuo
dc=[.4 4.2 3];                  %Denominador cont.
T0=.5;                          %Tiempo de muestreo
[nd,dd]=c2dm(nc,dc,T0,'zoh')    %nd y dd son los valores discretos  
figure();
plot(H2C);
hold; grid;
plot(H2D);
title('Respuesta al escalon de G(s) y G(z)');
legend('G(s)','G(z)');

%%
%%%punto 2
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
%%
%%%punto 3
R=8;L=.08;Te=L/R;Kem=0.67;
J=2.22*10^-3;f=1.86*10^-3;Tm=J/f;
Va=100;Tcarga=0.15;
G1=tf(1/R,[Te 1]);
G2=tf(1/f,[Tm 1]);
w1c=feedback(G1*G2*Kem,Kem);
[n1c,d1c]=tfdata(w1c,'v');
w2c=feedback(G2,Kem*Kem*G1);
[n2c,d2c]=tfdata(w2c,'v');
figure();
plot(wm1);hold;grid;grid minor;
plot(wm2);plot(wm);
title('Respuesta del motor con Va=100V y Ca=1Nt(modelo continuo)');
legend('wm1','wm2','wm');
%discretizacion del sistema:
T0=0.015;
[n1d,d1d]=c2dm(n1c,d1c,T0,'zoh');
[n2d,d2d]=c2dm(n2c,d2c,T0,'zoh');
figure();
plot(wm1d);hold;grid;grid minor;
plot(wm2d);plot(wmd);
title('Respuesta del motor con Va=100V y Ca=1Nt(modelo discreto)');
legend('wm1','wm2','wm');
%comparacion salida continua y discreta:
figure();
plot(wm);hold;grid;grid minor;
plot(wmd);
title('Comparacion de salida discreta y continua');
legend('Sistema continuo','Sistema discreto');