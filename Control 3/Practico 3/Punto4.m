clc;close all;
%% punto 4
n=1;d=[1 3 2];          %se cargan los valores de num y denom
G=tf(n,d)               %se arma la funcion de transferencia
T0=.1;
[nd,dd]=c2dm(n,d,T0,'zoh')
gg=tf(nd,dd,T0) 
n=0:T0:7;
kp=4;ki=2;kd=2;
%hasta este punto, carga los datos previos
sim("punto1.slx");  %grafica la planta original
figure();
subplot(2,1,1);     
plot(Salida); 
subplot(2,1,2);
plot(Accioncontrol);

r=.3;               %Coeficiente que determina relacion entre
                    %el menor error y la menor variacion de la accion
coef_menor=10000;   %Valor grande para ser sobreescrito
cant_iter=5;        %Define la cantidad de valores que prueba en cada K
porcentaje=.2;              %Define el rango en que varia
min=1-porcentaje;           %cada ganancia se varia un +-70%
max=1+porcentaje;           %Ya que al variar solo un +-20%,
i=kp*min:(max-min)*kp/cant_iter:kp*max+.1;     %Kp tomaba el menor
j=ki*min:(max-min)*ki/cant_iter:ki*max+.1;     %valor. La idea fue
k=kd*min:(max-min)*kd/cant_iter:kd*max+.1;    %no limitar los valores
                                
c=[];               %c guarda todos los valores de los coeficientes                             
for kp=i           %evalua todo el rango de valores
    for ki=j       %para las tres variables
        for kd=k
            sim('punto1.slx');
            %el coeficiente utilizado realiza la sumatoria de
            %cada valor del error al cuadrado mas la desviacion
            %de la accion de control respecto al promedio al cuadrado
            %ponderada por un indice "r"
            accion=Accioncontrol.Data;  %para instrucciones mas cortas
            error=sum((Salida.Data-1).^2);
            %el error es la salida menos la entrada,
            %al ser un escalon su valor siempre es 1
            delta_accion=sum((accion-mean(accion)).^2);
            coef=error+delta_accion*r;  %obtiene el coeficiente
            c=[c; coef kp ki kd];
            if coef<coef_menor          %Si es menor 
                coef_menor=coef         %que el menor anterior
                kpf=kp;                 %guarda todas las variables
                kdf=kp;
                kif=ki;
            end
%             error=0;accion=0;
%             for l=1:length(Salida.Data)
%                 
%             end
        end
    end
end
kd=kdf; ki=kif; kp=kpf; %finalmente se reemplazan las variables
sim("punto1.slx");      %por los valores anteriores y se vuelve a
subplot(2,1,1);hold on; %graficar.
plot(Salida); 
grid;title("Salida del sistema");
legend("Salida original","Salida optimizada con r="+r);
subplot(2,1,2); hold on;
plot(Accioncontrol);
grid;title("Accion de control");
legend("Accion original","Accion optimizada con r="+r);
str = {"Valores optimizados:","Kp="+kp,"Ki="+ki,"Kd="+kd};
annotation('textbox',[0.7 0.1 0.3 0.3],'String',str,'FitBoxToText','on');
 