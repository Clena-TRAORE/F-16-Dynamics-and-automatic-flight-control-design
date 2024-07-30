clc; clear all; close all; 
load('ABCD.mat');
k = logspace(-2, 1, 2000);
r = rlocus(A,B,C(3,:),0,k);
figure
plot(r)
grid on
axis([-20, 1, -10, 10])
acl = A-B*0.5*C(3,:);
[z, p, m ]= ss2zp(acl, B, C(2,:),0)
r2 = rlocus(acl, B,C(2,:),0);
figure
plot(r2)
