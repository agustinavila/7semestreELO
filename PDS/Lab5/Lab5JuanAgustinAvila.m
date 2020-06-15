%%Punto 1
%1.a
f0=45; S=120; N=512; N1=1024;
n=0:N-1; f=(0:N1-1)*S/N1;
x=cos(2*pi*f0*n/S);
X=abs(fft(x,N1))/N1;
xa=x.*window(@bartlett,N)';
XA=abs(fft(xa,N1))/N1;
xh=x.*window(@hanning,N)';
XH=abs(fft(xh,N1))/N1;
xb=x.*window(@blackman,N)';
XB=abs(fft(xb,N1))/N1;
%Graficacion
subplot(411),plot(f,X);
title('Respuesta ventana Rectangular '); grid on;
subplot(412),plot(f,XA);
title('Respuesta ventana Bartlett '); grid on;
subplot(413),plot(f,XH);
title('Respuesta ventana Hanning '); grid on;
subplot(414),plot(f,XB);
title('Respuesta ventana Blackman '); grid on;

% 1.b
subplot(411),axis([40 50 0 0.25]);
subplot(412),axis([40 50 0 0.25]);
subplot(413),axis([40 50 0 0.25]);
subplot(414),axis([40 50 0 0.25]);

%1.c

S=f0*2;
punto1c(S,1);
S=f0*1.5;
punto1c(S,2);

%% punto 2
%2.1
punto2(256,1024,5);
punto2(256,1024,2);
punto2(256,1024,1);
%2.2
punto2(512,1024,1);
%2.3
punto2(256,2048,2);

%% funciones auxiliares

function punto2(N,N1,deltaf,num,tot,sub)
f0=90;
S=190;
n=0:N-1;
f=(0:(N1-1))*S/N1;
x=cos(2*pi*f0*n/S)+cos(2*pi*(f0+deltaf)*n/S); 
X=abs(fft(x,N1))/N1;
xh=x.*window(@hanning,N)';
XH=abs(fft(xh,N1))/N1;
%graficacion
figure();
subplot(2,1,1),plot(f,X);
title("Rectangular con N="+N+", N1="+N1+" y deltaf="+deltaf);
xlabel('Frecuencia(Hz)'),ylabel('Amplitud');grid on;
subplot(2,1,2),plot(f,XH);
title("Hanning con N="+N+", N1="+N1+" y deltaf="+deltaf);
xlabel('Frecuencia(Hz)'),ylabel('Amplitud');grid on;
end

function punto1c(S,sub)
f0=45;
N1=1024;
N=512;
n=0:N-1;
f=(0:N1-1)*S/N1; 
x=cos(2*pi*f0*n/S);
xb=x.*window(@blackman,N)';
Xb=abs(fft(xb,N1))/N1;
[fa fd]=alias(f0,S);
t=0:0.001:0.25;
xa=cos(2*pi*fa*t); 
figure(3);
subplot(2,1,sub),plot(t,xa);
title("Señal recuperada con S="+S);
xlabel('Tiempo(seg)'),ylabel('Amplitud');grid;
figure(4);
subplot(2,1,sub),plot(f,Xb);title("Blackman para S="+S),
xlabel('Frecuencia(Hz)'),ylabel('Amplitud'),grid;
end