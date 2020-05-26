
clc;close all;
%% punto 1
% vlo=380;                    %tension de linea en vacio
% vlc=355;                    %tension de linea con carga
% I=40;                       %corriente
% R=.12;                      %Resistencia de armadura
% E0=vlo/sqrt(3);             %modulo de la tension en vacio
% vc=vlc/sqrt(3);             %tension en carga, es un vector real
% vr=R*I;                     %coseno phi es 1, la tension tambien es real
% delta=acos((vc+vr)/E0)*180/pi %resultado en radianes, convertido a grados
% vxs=sqrt(E0^2-(vc+vr)^2)*1i;%Se resuelve la parte imaginaria por trigonometria
% Xs=vxs/I                    %Se obtiene Xs
% E0=vc+vr+vxs                %es igual a la sumatora de todos los vectores.
% modulo=norm(E0)             %para comprobar el resultado
% Zs=R+Xs
% plot(real([0 vc]),imag([0 vc]),'-+','LineWidth',2);
% hold;grid;
% plot(real([vc vc+vr]),imag([vc vc+vr]),'-+','LineWidth',2);
% plot(real([vc+vr vc+vr+vxs]),imag([vc+vr vc+vr+vxs]),'-+','LineWidth',2);
% plot(real([0 E0]),imag([0 E0]),'-+','LineWidth',2);
% plot(real([0 I]),imag([0 I]),'-+','LineWidth',2);
% legend('Vc=Tension en bornes con carga','Vr=I*R','Vxs=I*Xs',"E'0(tension de fem)",'Corriente');
% axis([-5 230 -5 70]);
% xlabel('Eje real')
% ylabel('Eje Imaginario')
% title('Diagrama vectorial de una fase del estator')
% %% punto 2
% cosphi=.8;                   %coseno de phi
% Vl=400;                     %tension nominal de linea
% I=100;                      %corriente nominal
% f=60;                       %frecuencia
% Xs=1.03*1i;                 %Reactancia sincronica (compleja)
% Lfe=850;                    %Perdidas en el hierro
% Lroz=1100;                  %perdidas por rozamiento y ventilacion
% phi=-acos(cosphi)           %angulo negativo en este caso
% E0=Vl/sqrt(3);              %tension de fase
% Iphi=I*exp(phi*1i)          %El valor complejo de la tension
% Vxs=Iphi*Xs                 %Caida de tension en Xs
% E0c=sqrt(E0^2-imag(Vxs)^2)+imag(Vxs)*1i;
% %se calcula E0 en forma compleja, sabiendo que su parte imaginaria
% %debe ser igual a la parte imaginaria de Vxs
% Vc=E0c-Vxs                  %Modulo de Vc
% %E0c=Vc+Vxs;                %fem inducida expresada en forma compleja
% delta=angle(E0c)*180/pi      %Angulo delta entre E0 y Vc
%% punto 2
cosphi=.8;                   %coseno de phi
Vl=400;                     %tension nominal de linea
I=100;                      %corriente nominal
f=60;                       %frecuencia
Xs=1.03*1i;                 %Reactancia sincronica (compleja)
Lfe=850;                    %Perdidas en el hierro
Lroz=1100;                  %perdidas por rozamiento y ventilacion
phi=-acos(cosphi)           %angulo negativo en este caso
E0=Vl/sqrt(3);              %tension de fase
Iphi=I*exp(phi*1i)          %El valor complejo de la tension
Vxs=Iphi*Xs                 %Caida de tension en Xs
E0c=sqrt(E0^2-imag(Vxs)^2)+imag(Vxs)*1i;
%se calcula E0 en forma compleja, sabiendo que su parte imaginaria
%debe ser igual a la parte imaginaria de Vxs
Vc=E0c-Vxs                  %Modulo de Vc
%E0c=Vc+Vxs;                %fem inducida expresada en forma compleja
delta=angle(E0c)*180/pi      %Angulo delta entre E0 y Vc

%% Graficacion:
plot(real([0 Vc]),imag([0 Vc]),'-+','LineWidth',2);
hold;grid;
plot(real([Vc Vc+Vxs]),imag([Vc Vc+Vxs]),'-+','LineWidth',2);
plot(real([0 E0c]),imag([0 E0c]),'-+','LineWidth',2);
plot(real([0 Iphi]),imag([0 Iphi]),'-+','LineWidth',2);
legend('Vc=Tension en bornes con carga','Vxs=I*Xs',"E'0(tension de fem)",'Corriente');
%axis([-5 250 -5 120]);
xlabel('Eje real')
ylabel('Eje Imaginario')
title('Diagrama vectorial de una fase del estator con coseno phi=0.8')
