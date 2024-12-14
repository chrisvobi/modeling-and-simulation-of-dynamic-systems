clear;
clc;
close all;

% data
theta1 = 0.5;
theta2 = 2;

u = @(t)1.5*sin(2*pi*t).* exp(-3*t);
f = @(x)-0.25*x.^2;

t = 0:0.1:15;

%% sim
g1 = 950;
g2 = 500;
am = 5;
odefun = @(t,x)[-theta1*f(x(1))+theta2*u(t);
            -g1*(x(1)-x(4))*f(x(1));
            g2*(x(1)-x(4))*u(t);
            -x(2)*f(x(1))+x(3)*u(t)+am*(x(1)-x(4))];
[t,x] = ode45(odefun,t,[0,0,0,0]);

% plot x and x_est
x_real = x(:,1);
x_est = x(:,4);
figure();
hold on;
plot(t,x_real);
plot(t,x_est);
hold off;
grid on;
legend('$x$','$\hat{x}$','interpreter','latex','FontSize',15);

% plot e
e = x_real-x_est;
figure();
plot(t,e);
grid on;
title(['$e$ = $x$ - $\hat{x}$'],'interpreter','latex','FontSize',15);

% plot theta1
theta1_est = x(:,2);
figure();
hold on;
plot(t,theta1_est);
yline(theta1);
hold off;
grid on;
legend('$\theta_1$','$\hat{\theta_1}$','interpreter','latex','FontSize',15);

% plot theta2
theta2_est = x(:,3);
figure();
hold on;
plot(t,theta2_est);
yline(theta2);
hold off;
grid on;
legend('$\theta_2$','$\hat{\theta_2}$','interpreter','latex','FontSize',15);