%% RLC system
clear;
close all;
clc;

%% Question 1

% data
tSpace = 0:1e-5:150;
u1 = @(t) 3*sin(pi*t);
u2 = 2.5*ones(length(tSpace), 1);
[vr, vc] = v(tSpace);

% poles
p1 = 50;
p2 = 50;

% phi matrix
denominator = [1, p1+p2, p1*p2];
phi1 = lsim(tf([-1 0],denominator),vc,tSpace);     
phi2 = lsim(tf(-1,denominator),vc,tSpace);         
phi3 = lsim(tf([1 0],denominator),u1(tSpace),tSpace);      
phi4 = lsim(tf(1,denominator),u1(tSpace),tSpace);
phi5 = lsim(tf([1 0],denominator),u2,tSpace);
phi6 = lsim(tf(1,denominator),u2,tSpace);
phi = zeros(length(tSpace),6);
phi(:,1) = phi1;
phi(:,2) = phi2;
phi(:,3) = phi3;
phi(:,4) = phi4;
phi(:,5) = phi5;
phi(:,6) = phi6;

% calculate theta
phiTphi = phi.'*phi;
VCTphi = vc*phi;
theta0 = VCTphi/phiTphi;
theta = theta0 + [p1+p2 p1*p2 0 0 0 0];

% estimate parameters
RC = 1/theta(1);
RC_inv = theta(1);
LC = 1/theta(2);
LC_inv = theta(2);

% calculate vc_bar
odefun = @(t,y) [y(2); -RC_inv*y(2)-LC_inv*y(1)+RC_inv*3*pi*cos(pi*t)+LC_inv*2.5];
[t,y] = ode45(odefun,tSpace,[vc(1),0]);
vc_bar = y(:,1);

% plot vc from measures
figure();
plot(tSpace,vc, 'LineWidth',0.1);
xlabel('t (sec)');
ylabel('Voltage (V)');
title('$V_{C}$', 'Interpreter','latex');

% plot vc bar
figure();
plot(tSpace,vc_bar, 'LineWidth',0.1);
xlabel('t (sec)');
ylabel('Voltage (V)');
title('$\hat{V_C}$', 'Interpreter','latex');

% plot error vc
figure();
plot(tSpace, vc-vc_bar','LineWidth',0.1);
xlabel('t (sec)');
ylabel('Voltage (V)');
title('$V_{C}$-$\hat{V_C}$', 'Interpreter','latex');

% plot vr from measures
figure();
plot(tSpace,vr,'LineWidth',0.1);
xlabel('t (sec)');
ylabel('Voltage (V)');
title('$V_{R}$', 'Interpreter','latex');

% plot vr_bar
vr_bar = u1(t)+u2-vc_bar;
figure();
plot(tSpace,vr_bar,'LineWidth',0.1);
xlabel('t (sec)');
ylabel('Voltage (V)');
title('$\hat{V_R}$', 'Interpreter','latex');

% plot error vr
figure();
plot(tSpace, vr-vr_bar','LineWidth',0.1);
xlabel('t (sec)');
ylabel('Voltage (V)');
title('$V_{R}$-$\hat{V_R}$', 'Interpreter','latex');


%% Question 2

% generate random errors and new Vc
random_t = randi([0 length(vc)], 20, 1);
vc2 = vc;
vc2(random_t) = vc2(random_t) + 50*vc(random_t);

% recalculate phi matrix (ph1 and phi2 changes)
phi1 = lsim(tf([-1 0],denominator),vc2,tSpace);     
phi2 = lsim(tf(-1,denominator),vc2,tSpace);
phi(:,1) = phi1;
phi(:,2) = phi2;

% recalculate theta
phiTphi = phi.'*phi;
VCTphi = vc2*phi;
theta0 = VCTphi/phiTphi;
theta = theta0 + [p1+p2 p1*p2 0 0 0 0];

% reestimate parameters
RC2 = 1/theta(1);
RC2_inv = theta(1);
LC2 = 1/theta(2);
LC2_inv = theta(2);

% plot vc2_bar
odefun = @(t,y) [y(2); -RC2_inv*y(2)-LC2_inv*y(1)+RC2_inv*3*pi*cos(pi*t)+LC2_inv*2.5];
[t,y] = ode45(odefun,tSpace,[vc2(1),0]);
vc2_bar = y(:,1);
figure();
plot(tSpace,vc2_bar, 'LineWidth',0.1);
xlabel('t (sec)');
ylabel('Voltage (V)');
title('New $\hat{V_C}$', 'Interpreter','latex');
