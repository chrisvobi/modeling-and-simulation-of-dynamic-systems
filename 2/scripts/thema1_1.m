clear;
clc;
close all;

% real parameters
a = 4;
b = 1.5;

u = 5;
t = 0:0.1:10;

%% find gamma
g = [10,15,20,25,30,35];
am = 5;

% sim
for i = 1:length(g)
    odefun = @(t,x) [-a*x(1)+b*u;
        g(i)*x(4)*(x(1)-x(6));
        g(i)*x(5)*(x(1)-x(6));
        -am*x(4)+x(1);
        -am*x(5)+u;
        x(2)*x(6)-am*x(6)+x(3)*u];
    [t,x] = ode45(odefun,t,[0,0,0,0,0,0]);
    x_real = x(:,1);
    x_est = x(:,6);
    e = x_real - x_est;
    e = abs(e);
    figure();
    plot(t,e);
    grid on;
    title(['|e| for γ=', num2str(g(i))]);
    xlabel = ('Time (s)');
end

%% find am
g = 35;
am = [3,3.5,4,4.5,5,5.5];

% sim
for i = 1:length(am)
    odefun = @(t,x) [-a*x(1)+b*u;
        g*x(4)*(x(1)-x(6));
        g*x(5)*(x(1)-x(6));
        -am(i)*x(4)+x(1);
        -am(i)*x(5)+u;
        x(2)*x(6)-am(i)*x(6)+x(3)*u];
    [t,x] = ode45(odefun,t,[0,0,0,0,0,0]);
    a_est = am(i) - x(:,2);
    b_est = x(:,3);
    figure();
    hold on;
    plot(t,a_est);
    plot(t,b_est);
    yline(4);
    yline(1.5);
    hold off;
    grid on;
    title('am = ',num2str(am(i)));
    legend('$\hat{a}$','$\hat{b}$','$a_{real}$','$b_{real}$','interpreter','latex','FontSize',15);
end

%% simulation with optimal parameters
g = 35;
am = 4;

odefun = @(t,x) [-a*x(1)+b*u;
    g*x(4)*(x(1)-x(6));
    g*x(5)*(x(1)-x(6));
    -am*x(4)+x(1);
    -am*x(5)+u;
    x(2)*x(6)-am*x(6)+x(3)*u];
[t,x] = ode45(odefun,t,[0,0,0,0,0,0]);

x_real = x(:,1);
x_est = x(:,6);
e = x_real - x_est;
a_est = am - x(:,2);
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
yline(4);
yline(1.5);
hold off;
legend('$\hat{a}$','$\hat{b}$','$a$','$b$','interpreter','latex','FontSize',15);