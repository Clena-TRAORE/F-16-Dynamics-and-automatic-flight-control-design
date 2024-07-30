clc; clear all; close all; 
load('ABCD.mat');

acl = A-B*0.1*C(3,:);
qfb = ss(acl, B, C(2,:),0);
z =3; p=1;
lag = ss(-p,1,z-p,1);
csys = series(lag, qfb);
[a, b, c, d]=ssdata(csys);
k = logspace(-2, 0, 2000);
r = rlocus(a, b, c, d, k);
plot(r)
grid on
axis([-20, 1, -10, 10])
