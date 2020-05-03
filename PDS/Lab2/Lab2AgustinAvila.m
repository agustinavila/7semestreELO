%Laboratorio N2 de Procesamiento digital de señales
%Primer semestre 2020
%Juan Agustin Avila
%Realizado en MatLab R2017b

clc;close all;

% %ejercicio 1
% F=.1;    %se utiliza la freq digital como variable
% nx=-6:F:6;
% x=4*tri((nx-2)/3)-4*tri((nx+2)/3);
% nh=-4:F:4;
% h=-5*urect(nh/7);
% %punto a: graficar ambas señales
% figure('Name','Grafica de x[n]');
% stem(nx,x);
% title('Grafica de x[n]');grid on;
% figure('Name','Grafica de h[n]');
% stem(nh,h);
% title('Grafica de x[n]');grid on;ylim([-6 1]);
% 
% %punto 1.2:
% y1=convnum(x,h);
% l1=length(y1);
% ny1=-((l1-1)*F/2):F:(l1-1)*F/2;
% y2=convnum(h,x);
% l2=length(y2);
% ny2=-((l2-1)*F/2):F:(l2-1)*F/2;
% y3=convnum(x,x);
% l3=length(y3);
% ny3=-((l3-1)*F/2):F:(l3-1)*F/2;
% y4=convnum(h,h);
% l4=length(y4);
% ny4=-((l4-1)*F/2):F:(l4-1)*F/2;
% 
% %graficacion
% figure('Name','Grafica de x[n]*h[n]');
% stem(ny1,y1);
% title('Grafica de x[n]*h[n]');grid on;
% figure('Name','Grafica de h[n]*x[n]');
% stem(ny2,y2);
% title('Grafica de h[n]*x[n]');grid on;
% figure('Name','Grafica de x[n]*x[n]');
% stem(ny3,y3);
% title('Grafica de x[n]*x[n]');grid on;
% figure('Name','Grafica de h[n]*h[n]');
% stem(ny4,y4);
% title('Grafica de h[n]*h[n]');grid on;
% 
% %punto 1.3
% %Se grafica y1-y2, se comprueba que son iguales
% %Ya que la resta da 0 para todos los valores
% figure('Name','y1[n]-y2[n]=0');
% plot(ny1,y1-y2);title('y1[n]-y2[n]=0');
% 
% %punto 1.4
% % Para verificar esto se comprueba que la longitud de la convolucion
% % es igual a la longitud de x+h-1.
% Dif=length(nx)+length(nh)-1-l1
% %Se comprueba que el resultado es 0
% 
% %punto 1.5: verificar propiedad suma?
% sy3=sum(y3);   %la suma de todos los valores de y3
% sxx=sum(x)^2;  %la suma de todos los valores de x al cuadrado    
% Dif=sy3-sxx
% 
% %%%%%%punto 2 %%%%%%%%%%%%%%%%
% % punto 2.1:
% F=1;
% n=0:F:50;
% x=cos(0.4*pi*n); 
% figure('Name','Grafica de x[n]');
% stem(n,x);
% title('Grafica de x[n]');grid on;
% h=[1 2 3 4 5 6 7 8];
% 
% %punto 2.2:
% y=conv(x,h,'same');
% l=length(y);
% figure('Name','Grafica de y[n]');
% stem(n,y);
% title('Grafica de y[n]=x[n]*h[n]');grid on;
% 
% %punto 2.3:
% figure('Name','Señales individuales');
% subplot(2,1,1);
% stem(n,x);title('Grafica de x[n]');grid minor;
% subplot(2,1,2);
% stem(n,y);title('Grafica de y[n]');grid minor;
% 
% %punto 2.4
% %desarrollo teorico?


%%%%%%%%%%%%%%% punto 3 %%%%%%%%%%%%%%%%%%%%%%%%%%
%punto 3.1
F3=1;
n=-10:F3:10;
x=5*tri(.2*(n+5))-5*tri(.2*(n-5));
h1=[.5 .5];
y1=conv(x,h1,'same');

%punto 3.2
h2=[1 -1];
y2=conv(x,h2,'same');

%punto 3.3
figure();
subplot(4,1,1);
stem(n,x);grid minor;
title('Entrada 1');
subplot(4,1,2);
stem(n,y1);grid minor;
title('Salida con a0=a1=0.5');
subplot(4,1,3);
stem(n,x);grid minor;
title('Entrada 2');
subplot(4,1,4);
stem(n,y2);grid minor;
title('Salida con a0=1 y a1=-1');

%punto 3.4
%El filtro a promedia entre los dos valores
%El filtro b marca la pendiente de la entrada

%punto 3.5