clc;clear all;
%% punto 2
n=1;d=[.0000001 .0001 1];
H=tf(n,d);
pp=pole(H);

step(H,0.002); grid
T0=.0002;
[dd,nd]=c2dm(n,d,T0,'zoh')
Gz=c2d(H,T0,'zoh')
%step(Gz)
T0=T0/10
t=0:T0:.01;
y=step(H,t);%   Respuesta al escalón
dy=diff(y)/T0;% Derivada
[m,p]=max(dy);% Punto de inflexión
d2y=diff(dy)/T0;%Derivada Segunda
yi=y(p);
ti=t(p);
L=ti-yi/m;
Tau=(y(end)-yi)/m+ti-L;
plot(t,y,'b',[0 L L+Tau t(end)],[0 0 y(end) y(end)],'k');
title('Respuesta al escalón');
ylabel('Amplitud');
xlabel('tiempo(s)');
legend('Exacta','Aproximación Lineal','Location','southeast');
xlim([0 .008]);%ylim([0 0.275]);
grid on;