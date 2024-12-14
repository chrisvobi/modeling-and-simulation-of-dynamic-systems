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


%% find g1 g2
g1 = 1:1:5;
g2 = g1;
for i=1:length(g1)
    for j=1:length(g2)
        odefun = @(t,x)[-a*x(1)+b*u(t);
            -g1(i)*x(4)*(x(1)-x(4));
            +g2(j)*u(t)*(x(1)-x(4));
            -x(2)*x(4)+x(3)*u(t)];
        [t,x] = ode45(odefun,t ,[0,0,0,0]);
        e = x(:,1) - x(:,4);
        abse = abs(e);
        figure();
        plot(t,abse);
        grid on;
        title(['|e| for γ1 = ',num2str(g1(i)),', γ2 = ',num2str(g2(j))]);
    end
end

%% sim
g1 = 5;
g2 = 1;
odefun = @(t,x)[-a*x(1)+b*u(t);
            -g1*x(4)*(x(1)-x(4)+n(t));
            +g2*u(t)*(x(1)-x(4)+n(t));
            -x(2)*x(4)+x(3)*u(t)];
[t,x] = ode45(odefun,t,[0,0,0,0]);
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

%% change n0
n0 = [0.5,0.75,1.25,1.50,1.75,2];
f = 40;
for i = 1:length(n0)
    n = @(t)n0(i)*sin(2*pi*f*t);
    odefun = @(t,x)[-a*x(1)+b*u(t);
            -g1*x(4)*(x(1)-x(4)+n(t));
            +g2*u(t)*(x(1)-x(4)+n(t));
            -x(2)*x(4)+x(3)*u(t)];
    [t,x] = ode45(odefun,t,[0,0,0,0]);
    e = x(:,1) +n(t) - x(:,4);
    figure();
    plot(t,e);
    title(['e for n0 = ', num2str(n0(i))]);
end

%% change f
n0 = 0.5;
f = [5,10,15,20,40,60];
for i = 1:length(f)
    n = @(t)n0*sin(2*pi*f(i)*t);
    odefun = @(t,x)[-a*x(1)+b*u(t);
            -g1*x(4)*(x(1)-x(4)+n(t));
            +g2*u(t)*(x(1)-x(4)+n(t));
            -x(2)*x(4)+x(3)*u(t)];
    [t,x] = ode45(odefun,t,[0,0,0,0]);
    e = x(:,1) +n(t) - x(:,4);
    figure();
    plot(t,e);
    title(['e for f = ',num2str(f(i))]);
end
