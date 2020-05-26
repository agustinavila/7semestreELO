% nd=[0 2 -.5];
% dd=[1 -1.1 .2125];
% sim('Punto3b.slx'); 
% plot(Y); 
% grid on;grid minor; 
% 
% %comprobacion de resultados de ec. en diferencias:
% b=[0, 2, -0.5];     %coeficientes de r
% a=[1, -1.1, .2125]; %coeficientes de y
% x=[ones(1,10)];
% y=filter(b,a,x)


nd=[0 2 -.5];
dd=[1 -1.1 .2125];
sim('Punto3c.slx'); 
plot(entrada);grid;grid minor;title('Entrada');
figure();
plot(Y);grid on;grid minor;title('Respuesta a la entrada dada');
sim('Punto3Cimpulso.slx');
figure(); plot(Yimpulso);grid;grid minor;
title('Respuesta de la ecuacion de respuesta ante un impulso discreto');
%comprobacion de resultados de ec. en diferencias:
b=[0, 2, -0.5];     %coeficientes de r
a=[1, -1.1, .2125]; %coeficientes de y
x=[0 1 1 2 3 4 5 6 7 8 9];
y=filter(b,a,x)