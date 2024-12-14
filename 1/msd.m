%% Mass-Spring-Dumper system
clear
close all
clc


%% Real values of parameters
m = 8.5;
b = 0.65;
k = 2;
u = @(t) 10*cos(0.5*pi*t) + 3;


%% Simulation of real system

tSpace = 0:0.1:10;

% arxikes sinthikes
y0 = [0 0];

% solve ode
odefun = @(t,y) [y(2); (-b*y(2) - k*y(1) + u(t))/m];
[t,y] = ode45(odefun,tSpace,y0);
Y = y(:,1);

% plot
figure();
plot(t,Y);
ylabel('Output y');
xlabel('t (sec)');
title('Real system output');
grid on;
hold on;


%% Estimate with LSM

% pole placement
p1 = 1;
p2 = 1;

% phi matrix = zeta
denominator = [1 (p1+p2) p1*p2];
phi1 = lsim(tf([-1 0],denominator),Y,t);     
phi2 = lsim(tf(-1,denominator),Y,t);         
phi3 = lsim(tf(1,denominator),u(t),t);                  
phi = zeros(length(t),3);                                  
phi(:,1) = phi1;
phi(:,2) = phi2;
phi(:,3) = phi3;

% calculate theta0
phiTphi = phi.'*phi;                                       
YTphi = Y.'*phi;                                   
theta0 = YTphi/phiTphi;

% estimate parameters                       
mest = 1/theta0(3);                           
kest = mest*(theta0(2)+p1*p2);              
best = mest*(theta0(1)+p1+p2);                 

% estimate y
yest = phi * theta0';

% plot yest
figure();
plot(t,yest);
ylabel('Estimated output y');
xlabel('t (sec)');
title('LSM');
grid on;
hold on


%% Error plot
e = Y  - yest;
figure();
plot(t,e);
ylabel('');
xlabel('t (sec)');
title('Error y - yEstimated');
grid on;
hold on