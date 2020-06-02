clc;clear all;
%% graficacion de funciones originales y sin valores medios:
for i=1:5                       %grafica las 5 funciones
figure("Name","Funcion "+i);    %genera la figura
subplot(211);                   % en la figura superior grafica la original
graficacionfunciones(i,"","original"); %funcion que grafica
dim=[0.2 0.6 0.3 0.3];          % estas dimensiones son para agregar un cuadro con datos
valores(i,"",dim);              %la funcion valores calcula max,min,medio y freq
subplot(212);                   %repite el proceso para la funcion sin Vmedio
graficacionfunciones(i,"Vmedio","Sin el valor medio");
dim=[0.2 0.1 0.3 0.3];
valores(i,"Vmedio",dim);
end

%% grafica de la suma y resta
s1=1;s2=2;  %%funciones que se sumaron o restaron
sumayresta(s1,s2,"Suma");
sumayresta(s1,s2,"Resta");

%% correlacion:
figure("Name","Correlacion de se�ales 1 y 2");
graficacionfunciones(12,"correlacion","correlacionada");
title("Correlacion de se�ales 1 y 2");
figure("Name","Autocorrelacion de se�al 2");
graficacionfunciones(2,"correlacion","autocorrelacionada");

%% funciones utilizadas
function tiempo=graficacionfunciones(i,mod,tipo) %%abre el archivo y lo grafica
arch=load("Signal_0"+i+mod+".txt"); 
%abre el archivo "i" y mod es para agregar si esta correlacionado,
%es la se�al sumada, restada o sin valor medio.
Fs=arch(1);                     %guarda Fs
n=0:1/Fs:(length(arch)-2)/Fs;   %Genera base temporal en base a Fs y la longitud
n=n-r;
dtplot(n,arch(2:length(arch))); %Grafica la funcion
title("Funcion "+i+" "+tipo);   %Agrega titulo
grid;
tiempo=(length(arch)-1)/Fs;     %Devuelve el tiempo(Util para que todas tengan la misma longitud)
end

function sumayresta(s1,s2,tipo)    %grafica ambas se�ales y suma o resta
figure();
subplot(311);
graficacionfunciones(s1,"","Se�al "+s1+" original");
subplot(312);
graficacionfunciones(s2,"","Se�al "+s2+" original");
subplot(313);
t=graficacionfunciones(s1*10+s2,tipo,tipo+" de las dos funciones");
%devuelve el tiempo de la se�al sumada o restada para ajustar los
%ejes de las graficas originales y asegurarse que haya 
%correspondencia en las graficas
subplot(311);xlim([0 t]);
subplot(312);xlim([0 t]);
end

function valores(i,mod,dim) %analiza varios valores
arch=load("Signal_0"+i+mod+".txt"); %abre el archivo, idem anterior
Fs=arch(1);                          %Idem anterior
Vmedio=sum(arch(2:length(arch)))/(length(arch)-1); %Calcula el promedio
maximo=max(arch(2:length(arch)));   %Obtiene maximo
minimo=min(arch(2:length(arch)));   %Obtiene minimo
[m1, n1]=max(arch(2:length(arch-1)));       %Se obtienen los indices de
[m2, n2]=min(arch(n1:length(arch-n1)));     %distintos max y min, se
[m3, n3]=max(arch(n1+n2:length(arch-n1-n2)));%evita el primer periodo ya
[m2, n4]=min(arch(n1+n2+n3:length(arch-n1-n2-n3)));%que en una funcion
[m3, n5]=max(arch(n1+n2+n3+n4:length(arch-n1-n2-n3-n4)));%no era igual
freq=Fs/(n4+n5);                         %Calcula la frecuencia analogica  
%Agrega un textbox al grafico
str = {"V medio: "+Vmedio,"Vmax: "+maximo,"Vmin: "+minimo,"Freq: "+freq+"Hz"};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
end