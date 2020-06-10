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
% figure;
% hold on;
% for i=1:5
% Kp=20*i;
% H=feedback(Kp*L,1);
% step(H,0.04);
% end
%hold; step(H,0.04);grid
Tl=(.036-.0052)/3
Kl=100;
Ki=2/Tl;
Td=Tl/8;
K=.6*Kl;
kp=K;
ki=
kd=

