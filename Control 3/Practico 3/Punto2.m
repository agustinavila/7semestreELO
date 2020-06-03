clc;clear all;
%% punto 2
n=1;d=[.0000001 .0001 1];
H=tf(n,d);
pp=pole(H);
T0=.0002;
%step(H,0.002);grid;grid minor;
[nd,dd]=c2dm(n,d,T0,'zoh')

Tu=.00025;
Tg=.00075;
Ke=1.6;

K=((1.2*Tg)/(Ke*(Tu+(T0/2))))-((.3*Tg*T0)/(Ke*(Tu+(T0/2))^2));
Ki=(.6*Tg)/(K*Ke*(Tu+(T0/2))^2);
Td=.5*Tg/(K*Ke);
kp=K
ki=K*Ki
kd=K*Td
% s = tf('s');
% C = K+(K*Ki/s)+K*Td*s;
% Gpid=tf(C)
% %Gpid=pid(Kp,Kd,Ki);
% [nGpid,dGpid]=tfdata(Gpid,'v');
% Gz=c2d(Gpid,T0)
sim('punto2.slx');
figure();
subplot(2,1,1);     %grafica la salida en la parte superior
    plot(Salida); 
    hold on;
    subplot(2,1,2);
    plot(Accioncontrol);%Grafica la accion de control
%step(Gz)

% 
% T0=T0/10
% t=0:T0:.002;
% y=step(H,t);%   Respuesta al escalón
% dy=diff(y)/T0;% Derivada
% [m,p]=max(dy);% Punto de inflexión
% d2y=diff(dy)/T0;%Derivada Segunda
% yi=y(p);
% ti=t(p);
% yy=y(51);
% L=ti-yi/m;
% Tau=(yy-yi)/m+ti-L;
% plot(t,y,'b',[0 L L+Tau t(end)],[0 0 yy yy],'k');
% title('Respuesta al escalón');
% ylabel('Amplitud');
% xlabel('tiempo(s)');
% legend('Exacta','Aproximación Lineal','Location','southeast');
% xlim([0 .001]);%ylim([0 0.275]);
% grid on;