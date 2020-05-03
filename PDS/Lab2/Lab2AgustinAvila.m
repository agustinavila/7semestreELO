%Laboratorio N2 de Procesamiento digital de señales
%Primer semestre 2020
%Juan Agustin Avila
%Realizado en MatLab R2017b

%ejercicio 1
nx=-6:1:6;
x=4*tri((nx-2)/3)-4*tri((nx+2)/3);
nh=-4:1:4;
h=-5*urect(nh/7);
figure();
dtplot(nx,x)
figure();
dtplot(nh,h)