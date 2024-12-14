clear;
clc;
close all;

% data
a = 2;
b = 5;

t = 0:0.001:20;

u = @(t)5*sin(2*t);

n0 = 0.5;
f = 40;
n = @(t)n0*sin(2*pi*f*t);

g1 = 5;
g2 = 1;

%% find thetam
thetam = 0.1:0.1:2;
for i = 1:length(thetam)
    odefun = @(t,x)[-a*x(1)+b*u(t);
        -g1*x(1)*(x(1)-x(4));
        g2*u(t)*(x(1)-x(4));
        -x(2)*x(4)+x(3)*u(t)+(x(1)-x(4))*thetam(i)];
    [t,x] = ode45(odefun, t, [0,0,0,0]);
    e = x(:,1) - x(:,4);
    abse = abs(e);
    figure();
    plot(t,abse);
    grid on;
    title(['|e| for θm = ',num2str(thetam(i))]);
end

%% sim
thetam = 0.1;
odefun = @(t,x)[-a*x(1)+b*u(t);
    -g1*(x(1)+n(t))*(x(1)-x(4));
    g2*u(t)*(x(1)+n(t)-x(4));
    -x(2)*x(4)+x(3)*u(t)+(x(1)+n(t)-x(4))*thetam];
[t,x] = ode45(odefun, t, [0,0,0,0]);
x_real = x(:,1);
x_est = x(:,4);
e = x_real + n(t) - x_est;
a_est = x(:,2);
b_est = x(:,3);

% plot x and x_est
figure();
hold on;
plot(t,x_real);
plot(t,x_est);
hold off;
grid on;
legend('$x$','$\hat{x}$','interpreter','latex','FontSize',15);

% plot e
figure();
plot(t,e);
grid on;
title(['e = x - $\hat{x}$'],'interpreter','latex','FontSize',15);

% plot a and b
figure();
hold on;
grid on;
plot(t,a_est);
plot(t,b_est);
yline(2);
yline(5);
hold off;
legend('$\hat{a}$','$\hat{b}$','$a$','$b$','interpreter','latex','FontSize',15);
