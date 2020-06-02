clc;clear all;
%% punto 3
R=8;H=.08;Te=H/R;Kem=0.67;
J=2.22*10^-3;f=1.86*10^-3;Tm=J/f;
Va=100;Tcarga=0.15;
G1=tf(1/R,[Te 1]);
G2=tf(1/f,[Tm 1]);
L=feedback(G1*G2*Kem,Kem)
[n,d]=tfdata(L,'v');
p=pole(L)
figure;
hold on;
for i=1:5
Kp=1000*i;
Kd=0;
Ki=0;
Gpid=pid(Kp,Kd,Ki);
H=feedback(Gpid*L,1);
step(H);
end