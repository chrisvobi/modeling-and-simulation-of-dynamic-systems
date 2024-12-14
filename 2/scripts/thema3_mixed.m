clear;
clc;
close all;

% data
a11 = -1;
a12 = 1;
a21 = -4;
a22 = 0;
b1 = 2;
b2 = 1;

g1 = 50;
g2 = 40;

t = 0:0.01:60;

u = @(t)(4*sin(pi*t)+2*sin(8*pi*t));
initial = zeros(1,10);

%% sim
thetam11 = -2;
thetam12 = 3;
thetam21 = -5;
thetam22 = 1;
odefun = @(t,y)[a11*y(1)+a12*y(2)+b1*u(t);
    a21*y(1)+a22*y(2)+b2*u(t);
    g1*y(1)*(y(1)-y(9));
    g1*y(2)*(y(1)-y(9));
    g1*y(1)*(y(2)-y(10));
    g1*y(2)*(y(2)-y(10));
    g2*(y(1)-y(9))*u(t);
    g2*(y(2)-y(10))*u(t);
    y(3)*y(1)+y(4)*y(2)+y(7)*u(t)-thetam11*(y(1)-y(9))-thetam12*(y(2)-y(10));
    y(5)*y(1)+y(6)*y(2)+y(8)*u(t)-thetam21*(y(1)-y(9))-thetam22*(y(2)-y(10))];
[t,y] = ode45(odefun,t,initial);

% plot x1,x1est,e1
x1_real = y(:,1);
x1_est = y(:,9);
e1 = x1_real - x1_est;
figure();
hold on;
plot(t,x1_real);
plot(t,x1_est);
hold off;
grid on;
legend('$x_1$','$\hat{x_1}$','interpreter','latex','FontSize',15);
figure();
plot(t,e1);
grid on;
title(['$e_1$ = $x_1$ - $\hat{x_1}$'],'interpreter','latex','FontSize',15);

% plot x2,x2est,e2
x2_real = y(:,2);
x2_est = y(:,10);
e2 = x2_real - x2_est;
figure();
hold on;
plot(t,x2_real);
plot(t,x2_est);
hold off;
grid on;
legend('$x_2$','$\hat{x_2}$','interpreter','latex','FontSize',15);
figure();
plot(t,e2);
grid on;
title(['$e_2$ = $x_2$ - $\hat{x_2}$'],'interpreter','latex','FontSize',15);

% plot a11
a11_est = y(:,3);
figure();
hold on;
plot(t,a11_est);
yline(a11);
hold off;
legend('$\hat{a_{11}}$','$a_{11}$','interpreter','latex','FontSize',15);
grid on;

% plot a12
a12_est = y(:,4);
figure();
hold on;
plot(t,a12_est);
yline(a12);
hold off;
legend('$\hat{a_{12}}$','$a_{12}$','interpreter','latex','FontSize',15);
grid on;

% plot a21
a21_est = y(:,5);
figure();
hold on;
plot(t,a21_est);
yline(a21);
hold off;
legend('$\hat{a_{21}}$','$a_{21}$','interpreter','latex','FontSize',15);
grid on;

% plot a22
a22_est = y(:,6);
figure();
hold on;
plot(t,a22_est);
yline(a22);
hold off;
legend('$\hat{a_{22}}$','$a_{22}$','interpreter','latex','FontSize',15);
grid on;

% plot b1
b1_est = y(:,7);
figure();
hold on;
plot(t,b1_est);
yline(b1);
hold off;
legend('$\hat{b_{1}}$','$b_{1}$','interpreter','latex','FontSize',15);
grid on;

% plot b2
b2_est = y(:,8);
figure();
hold on;
plot(t,b2_est);
yline(b2);
hold off;
legend('$\hat{b_{2}}$','$b_{2}$','interpreter','latex','FontSize',15);
grid on;