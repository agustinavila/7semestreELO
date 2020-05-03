clc; close all;
%************* Punto 1 ********************
n=-5:1:15;
x1n=ustep(n-3);
x2n=urect((n-5)/4);
% Graficación de ambas funciones
figure
dtplot(n,x1n);grid on;
title('Función x1(n)');ylim([-1 2]);
xlabel('Tiempo');ylabel('Amplitud');

figure
dtplot(n,x2n);grid on;
title('Función x2(n)');ylim([-1 2]);
xlabel('Tiempo');ylabel('Amplitud');


%************ punto 2 ****************
xn=[1,3,7,2,4];
N=length(xn);
%decimacion y luego interpolacion
xn_dec(1:ceil(N/2)) = xn(1:2:N);
xndec_int(1:2:2*length(xn_dec)) = xn_dec(1:length(xn_dec));
xn_dec_int(2:2:2*length(xn_dec)) = xn_dec(1:length(xn_dec));
%interpolacion y luego decimacion
xn_int(1:2:2*N) = xn(1:N);
xn_int(2:2:2*N) = xn(1:N);
xn_int_dec(1:N) = xn_int(1:2:2*N);
