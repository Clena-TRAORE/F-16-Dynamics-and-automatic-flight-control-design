ap = [-1.0189 0.90506; 0.82225 -1.0774]; %x1 = alpha x2 = q
bp = [-2.1499e-3; -1.7555e-1 ];  % Elevator input
cp = [57.29578 0; 0 57.29578];  % y1 = alpha, y2 = q
dp = [0 0];
sysp = ss(ap,bp,cp,dp); %plant
sysa = ss(-20.2, 20.2, -1, 0); %actuator and sign change
[sys1]=series(sysa, sysp); %actuator then plant
sysf = ss(-10, [10 0], [1; 0], [0 0; 0 1]);  %alpha filter
[sys2] = series(sys1, sysf);
[a b c d] = ssdtata(sys2);
acl = a -b*[k$ 0]*c;  %close alpha-loop
[]=ss2zp(acl, b, c(2,:),0)  % q/u1 transf. fn