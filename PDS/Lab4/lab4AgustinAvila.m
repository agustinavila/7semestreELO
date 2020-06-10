%% Punto 1
x1=[1 2 3 2 1];
x2=[1 2 2 1];
x3=[-1 2 0 2 -1];
x4=[-1 -2 2 1];
grafF(x1,"x1");
grafF(x2,"x2");
grafF(x3,"x3");
grafF(x4,"x4");

%% Punto 2
x=[1 6 6 6 2 4 4 4 1];
n=-4:4;
F=(0:199)/200; 
W=2*pi*F; 
X=freqz(x,[zeros(1,4) 1 zeros(1,4)], W); 
Y=freqz(x,[1 zeros(1,6)], W); 
figure (1); 
subplot(211),plot(F,abs(X));
title("Magnitud de X(F)"); grid on;
subplot(212),plot(F,abs(Y)); 
title("Magnitud de Y(F)"); grid on;
figure (2); 
subplot(221),plot(F,angle(X)*180/pi); ylim([-180 180]);
title("Fase de X(F)acotada"); grid on;
subplot(222),plot(F,angle(Y)*180/pi); ylim([-180 180]);
title("Fase de Y(F) acotada"); grid on;
subplot(223),plot(F,unwrap(angle(X))*180/pi); 
title("Fase de X(F) completa"); grid on;
phi=unwrap(angle(Y)-angle(X));
subplot(224),plot(F,phi*180/pi);
title("Diferencia de fase entre X e Y"); grid on;
deltaphi=phi(length(phi))-phi(1);
deltaF=F(length(F))-F(1);
D=(-deltaphi/deltaF)/(2*pi);


%% punto 3
n=0:8; 
x=tri((n-4)/4); 
F=-2:0.01:1.99;W=2*pi*F; 
X=freqz(x, [1 zeros(1,8)], W); 
G=freqz(conv(x,x), [1 zeros(1,16)],W); 
H=freqz(x.*x,[1 zeros(1,8)], W); 
subplot(311), plot(F,abs(X));
grid on; title("Grafica de X(F)");
subplot(312), plot(F,abs(X).^2);hold;
plot(F,abs(G),'--r','LineWidth',2);
grid on; title("Grafica de X(F)^2 y G(F)");
legend('X(F)^2','G(F)');
Yp=convp(X,X)/length(X); 
subplot(313), plot(F,abs(Yp));hold on;
plot(F,abs(H),'--r','LineWidth',1.5);
grid on; title("Grafica de Y_p(F) y X^2(F)");
legend('Y_p(F)','H(F)');

function grafF(x,nombre)
    f=500;
    F=0:1/f:1;
    W=2*pi*F;
    X=freqz(x,1, W);
    F1=0;
    F2=.25;
    F3=.5;
    F1v=abs(X(find(F==F1)));
    F2v=abs(X(find(F==F2)));
    F3v=abs(X(find(F==F3)));
    disp("Para "+nombre+":")
    disp("El valor de "+nombre+" para F=0 es "+F1v)
    disp("El valor de "+nombre+" para F=0.25 es "+F2v)
    disp("El valor de "+nombre+" para F=0.5 es "+F3v)
    figure();
    plot(F,abs(X)); grid on;
    title("X(F) de "+nombre);
end