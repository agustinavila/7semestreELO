
%% punto 2
n=1;d=[.0000001 .0001 1];
G=tf(n,d);
step(G,0.002); grid
