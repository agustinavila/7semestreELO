%Laboratorio N2 de Procesamiento digital de señales
%Primer semestre 2020
%Juan Agustin Avila
%Realizado en MatLab R2017b
clc;close all;
%ejercicio 1
F=1;%se utiliza la freq digital como variable
nx=-6:F:6;
x=4*tri((nx-2)/3)-4*tri((nx+2)/3);
nh=-4:F:4;
h=-5*urect(nh/7);
%punto a: graficar ambas señales
% figure('Name','Grafica de x[n]');
% stem(nx,x);
% title('Grafica de x[n]');grid on;
% figure('Name','Grafica de h[n]');
% stem(nh,h);
% title('Grafica de x[n]');grid on;ylim([-6 1]);

%punto 1.2:
y1=convnum(x,h);
l1=length(y1);
ny1=-((l1-1)*F/2):F:(l1-1)*F/2;
y2=convnum(h,x);
l2=length(y2);
ny2=-((l2-1)*F/2):F:(l2-1)*F/2;
y3=convnum(x,x);
l3=length(y3);
ny3=-((l3-1)*F/2):F:(l3-1)*F/2;
y4=convnum(h,h);
l4=length(y4);
ny4=-((l4-1)*F/2):F:(l4-1)*F/2;

%graficacion
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

%punto 1.3
figure('Name','y1[n]-y2[n]=0');
plot(ny1,y1-y2);title('y1[n]-y2[n]=0');

%punto 1.4

