clear all; close all; clc;

ap = [-1.0189 0.90506; 0.82225 -1.0774]; %x1 = alpha x2 = q
bp = [-2.1499e-3; -1.7555e-1 ];  % Elevator input
cp = [57.29578 0; 0 57.29578];  % y1 = alpha, y2 = q
dp = [0 ;0];
sysp = ss(ap, bp, cp, dp); %plant
sysa = ss(-20.2, 20.2, -1, 0); %actuator and sign change
[sys1]=series(sysa, sysp); %actuator then plant
sysf = ss(-10, [10 0], [1; 0], [0 0; 0 1]);  %alpha filter
[sys2] = series(sys1, sysf);  %actuator + plant + filter
[a b c d] = ssdata(sys2);  %axtract a, b, c, d
acl = a -b*[0.08 0]*c;  %close alpha-loop

[z, p, k]=ss2zp(acl, b, c(2,:),0);  % q/u1 transf. fn
sys3 = ss(acl, b, c,[0;0]);
figure 
step(sys3, 10)
sysi = ss(0, 3, 1, 1);
sys4 = series(sysi, sys3);
figure 
step(sys4, 10)
[aa bb cc dd]=ssdata(sys4);
k = linspace(0, .9,1000);
r = rlocus(aa, bb, cc(2,:),0,k);
figure
plot(r)
axis = ([-16, 0, -8, 8]);
grid on

%%

acl2 = aa-bb*0.5*cc(2,:);   % close outer loop
sys = ss(acl2, 0.5*bb, cc(2,:),0);   %unity feedback
figure
step(sys, 3)
grid on
