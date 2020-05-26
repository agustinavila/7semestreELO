clc;close all;
% %% punto 1.1
% n=1;d=[1 3 2];          %se cargan los valores de num y denom
% G=tf(n,d)               %se arma la funcion de transferencia
% t=stepinfo(G);          %se analiza la respuesta al escalon
% t=t.SettlingTime;       %Se le asigna el t de establecimiento
% T0=t/15                 %se busca un tiempo de muestreo     
% T0=.1;
% %% punto 1.2
% p=pole(G)               %Se obtienen los polos de la planta
% G2=c2d(G,T0,'impulse')
% [nd,dd]=c2dm(n,d,T0,'zoh');
% 
% 
% %% punto 1.3
% ki=0;kd=0;
% mkp=2;
% nkp=3;
% mkd=1;
% nkd=1;
% mki=1;
% 
% 
% 
% figure();
% Legend=cell(5,2);%  two positions
% for i=1:5
%     kp=mkp*i;
%     sim('punto1.slx');
%     subplot(2,1,1);
%     plot(Salida); 
%     Legend{i,1}="Salida con Kp="+kp;
%     hold on;
%     subplot(2,1,2);
%     plot(Accioncontrol);
%     hold on;
%     Legend{i,2}="Accion con Kp="+kp;
% end
% subplot(2,1,1);
% title('Salida de la planta variando el Kp');
% legend(Legend{:,1});grid on;
% subplot(2,1,2);
% title('Accion del controlador variando el Kp');
% legend(Legend{:,2});grid on;
% 
% %% para kd
% kp=mkp*nkp;
% figure();
% Legend=cell(5,2);%  two positions
% for i=1:5
%     kd=mkd*i;
%     sim('punto1.slx');
%     subplot(2,1,1);
%     plot(Salida); 
%     Legend{i,1}="Salida con Kd="+kd;
%     hold on;
%     subplot(2,1,2);
%     plot(Accioncontrol);
%     hold on;
%     Legend{i,2}="Accion con Kd="+kd;
% end
% subplot(2,1,1);
% title('Salida de la planta variando el Kd');
% legend(Legend{:,1});grid on;
% subplot(2,1,2);
% title('Accion del controlador variando el Kd');
% legend(Legend{:,2});grid on;
% 
% %% para ki
% kd=mkd*nkd;
% figure();
% Legend=cell(5,2);%  two positions
% for i=1:5
%     ki=mki*i;
%     sim('punto1.slx');
%     subplot(2,1,1);
%     plot(Salida); 
%     Legend{i,1}="Salida con Ki="+ki;
%     hold on;
%     subplot(2,1,2);
%     plot(Accioncontrol);
%     hold on;
%     Legend{i,2}="Accion con Ki="+ki;
% end
% subplot(2,1,1);
% title('Salida de la planta variando el Ki');
% legend(Legend{:,1});grid on;
% subplot(2,1,2);
% title('Accion del controlador variando el Ki');
% legend(Legend{:,2});grid on;
% 
% 

